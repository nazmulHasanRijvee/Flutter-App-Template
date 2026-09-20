# API Integration Guide

This guide explains how to integrate APIs into the application using **Dio**, **Retrofit**, **Api.call**, and the **Repository Pattern**.

## Table of Contents

- [Overview](#overview)
- [Architecture & Data Flow](#architecture--data-flow)
- [Setting Up Network Services](#setting-up-network-services)
- [Defining Endpoints](#defining-endpoints)
- [REST Client with Retrofit](#rest-client-with-retrofit)
- [Interceptors](#interceptors)
- [Standardized API Calls (`Api.call`)](#standardized-api-calls-apicall)
- [Repository Integration](#repository-integration)
- [Examples](#examples)
- [Best Practices](#best-practices)

---

## Overview

The project provides a production-ready, scalable network stack built with:
- **Dio**: HTTP client with interceptor support and custom configurations
- **Retrofit**: Type-safe REST client code generation
- **`Api.call<T>`**: Standardized error handling, DioException parsing, and logging
- **Interceptors**: Automated auth token injection and refresh on 401
- **Clean Architecture Repository Pattern**: Decoupling API implementation from domain and UI

---

## Architecture & Data Flow

```
Widget / Screen (lib/src/presentation/feature/)
    ↓
ViewModel / Provider (view_model/)
    ↓
Repository Interface (lib/src/domain/repositories/)
    ↓
Repository Implementation (lib/src/data/repositories/)
    ↓
Api.call<T> (lib/src/data/services/network/api_handler.dart)
    ↓
RestClient (Retrofit) / DioClient (Dio)
    ↓
Interceptors (AccessTokenInterceptor, TokenRefreshInterceptor)
    ↓
Remote Backend API
```

---

## Setting Up Network Services

The network infrastructure is housed under `lib/src/data/services/network/`:

```
lib/src/data/services/network/
├── endpoints.dart                  # API endpoint constants
├── dio_client.dart                 # Dio instance setup & dioProvider
├── rest_client.dart                # Retrofit client definition & restClientProvider
├── rest_client.g.dart              # Generated Retrofit code
├── api_handler.dart                # Api.call<T> response & error handling
└── interceptors/
    ├── access_token_interceptor.dart  # Attaches Bearer token
    └── token_refresh_interceptor.dart # Handles 401 token refresh & retry
```

---

## Defining Endpoints

Define backend URL segments in `lib/src/data/services/network/endpoints.dart`:

```dart
class Endpoints {
  Endpoints._();

  static const String base = 'https://api.example.com/v1';

  // Auth endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String refreshToken = '/auth/refresh-token';
  static const String forgotPassword = '/auth/forgot-password';
}
```

---

## REST Client with Retrofit

Declare endpoints using Retrofit annotations in `lib/src/data/services/network/rest_client.dart`:

```dart
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dio_client.dart';
import 'endpoints.dart';

part 'rest_client.g.dart';

@RestApi(baseUrl: Endpoints.base)
abstract class RestClient {
  factory RestClient(Dio dio, {String? baseUrl, ParseErrorLogger errorLogger}) =
      _RestClient;

  @POST(Endpoints.register)
  Future<HttpResponse> register(@Body() Map<String, dynamic> request);

  @POST(Endpoints.login)
  Future<HttpResponse> login(@Body() Map<String, dynamic> request);

  @POST(Endpoints.forgotPassword)
  Future<HttpResponse> forgotPassword(@Body() Map<String, dynamic> request);
}

final restClientProvider = Provider<RestClient>((ref) {
  final dio = ref.watch(dioProvider);
  return RestClient(dio);
});
```

### Generating the Client Code
Run `build_runner` to generate `rest_client.g.dart`:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## Interceptors

Configured in `lib/src/data/services/network/dio_client.dart`:

1. **`AccessTokenInterceptor`**:
   - Runs `onRequest`
   - Fetches the saved token via `AuthService`
   - Attaches `Authorization: Bearer <token>` to request headers
2. **`TokenRefreshInterceptor`**:
   - Runs `onError` when receiving a `401 Unauthorized`
   - Calls the `refreshTokenEndpoint` to obtain a new token
   - Retries the failed request with the new access token
   - If refreshing fails, clears session credentials and redirects to the login screen using `navigatorKey`
3. **`LogInterceptor`**:
   - Only enabled in `kDebugMode` to avoid logging sensitive data in production releases

---

## Standardized API Calls (`Api.call`)

Located in `lib/src/data/services/network/api_handler.dart`, `Api.call<T>` wraps asynchronous HTTP calls to guarantee robust, uniform error parsing:

```dart
class Api {
  static Future<void> call<T>({
    required Future<HttpResponse<T>> action,
    required FutureOr<void> Function(T response) onSuccess,
    required FutureOr<void> Function(String error) onError,
  }) async {
    // 1. Awaits the action inside a try-catch block
    // 2. Catches DioException, logs detailed debug info via AppLogger.error
    // 3. Extracts backend-provided 'message' field from JSON response if present
    // 4. Invokes onError(errorMessage) for failures
    // 5. Invokes onSuccess(data) outside try-catch on success
  }
}
```

### Usage Example:

```dart
await Api.call<Map<String, dynamic>>(
  action: restClient.login({'email': email, 'password': password}),
  onSuccess: (data) {
    // Save session or return data
  },
  onError: (errorMessage) {
    // Show toast or emit failure state
    AppLogger.error('Login failed: $errorMessage');
  },
);
```

---

## Repository Integration

### 1. Domain Contract
```dart
// lib/src/domain/repositories/auth_repository.dart
abstract interface class AuthenticationRepository {
  Future<Map<String, dynamic>> login(Map<String, dynamic> data);
  Future<Map<String, dynamic>> register(Map<String, dynamic> data);
  Future<void> logout();
}
```

### 2. Concrete Data Implementation
```dart
// lib/src/data/repositories/auth_repository_impl.dart
import '../../domain/repositories/auth_repository.dart';
import '../services/auth/auth_service.dart';
import '../services/network/rest_client.dart';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  AuthenticationRepositoryImpl({
    required this.remote,
    required this.authService,
  });

  final RestClient remote;
  final AuthService authService;

  @override
  Future<Map<String, dynamic>> login(Map<String, dynamic> data) async {
    final response = await remote.login(data);
    return response.data as Map<String, dynamic>;
  }

  @override
  Future<Map<String, dynamic>> register(Map<String, dynamic> data) async {
    final response = await remote.register(data);
    return response.data as Map<String, dynamic>;
  }

  @override
  Future<void> logout() async {
    await authService.clearSession();
  }
}

// Provider registration
final authRepositoryProvider = Provider<AuthenticationRepository>((ref) {
  return AuthenticationRepositoryImpl(
    remote: ref.watch(restClientProvider),
    authService: ref.watch(authServiceProvider),
  );
});
```

---

## Best Practices

### ✅ DO:
1. **Always depend on Domain Repository Contracts** in presentation layer view-models, never directly on `RestClient` or `DioClient`.
2. **Centralize URLs** in `Endpoints.dart` to prevent endpoint drift.
3. **Use `Api.call<T>`** for unified error logging, toast messages, and state handling.
4. **Use `build_runner`** whenever changing `@RestApi` interfaces or `@JsonSerializable` models.

### ❌ DON'T:
1. **Don't hardcode HTTP requests** inside UI widgets.
2. **Don't write manual authorization header logic** in every request; rely on `AccessTokenInterceptor`.
3. **Don't leave `LogInterceptor` active** in production builds (already safeguarded with `kDebugMode` in `DioClient`).
