# API Integration Guide

This guide explains how to integrate APIs into the application using **Dio** and **Retrofit**.

## Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Setting Up Services](#setting-up-services)
- [Creating API Clients](#creating-api-clients)
- [Making Requests](#making-requests)
- [Error Handling](#error-handling)
- [Examples](#examples)
- [Best Practices](#best-practices)

## Overview

The project uses:
- **Dio**: HTTP client for making API requests
- **Retrofit**: Type-safe REST client generator
- **Repository Pattern**: Abstraction layer for data access

### Benefits

- ✅ **Type Safety**: Generated code ensures compile-time safety
- ✅ **Code Generation**: Reduces boilerplate
- ✅ **Centralized Config**: Single place to configure API
- ✅ **Error Handling**: Consistent error management
- ✅ **Testable**: Easy to mock and test

## Architecture

```
Widget (UI)
    ↓
Repository (Data Abstraction)
    ↓
ApiService (API Calls)
    ↓
Dio + Retrofit
    ↓
Backend API
```

### Data Flow Example

```dart
// 1. Repository
class UserRepository {
  Future<User> getUser(String id) async {
    final model = await _apiService.getUser(id);
    return model.toEntity();
  }
}

// 2. API Service (Retrofit)
@RestApi(baseUrl: 'https://api.example.com')
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;
  
  @GET('/users/{id}')
  Future<UserModel> getUser(@Path('id') String id);
}

// 3. Provider
final userProvider = FutureProvider.family<User, String>((ref, id) async {
  return ref.read(userRepositoryProvider).getUser(id);
});

// 4. Widget
final user = ref.watch(userProvider('123'));
```

## Setting Up Services

### Step 1: Create API Service

```dart
// lib/data/services/api/api_service.dart
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: 'https://api.example.com/v1')
abstract class ApiService {
  factory ApiService(Dio dio, {String? baseUrl}) = _ApiService;

  @GET('/users/{id}')
  Future<UserModel> getUser(@Path('id') String id);

  @GET('/users')
  Future<List<UserModel>> getUsers();

  @POST('/users')
  Future<UserModel> createUser(@Body() UserModel user);

  @PUT('/users/{id}')
  Future<UserModel> updateUser(
    @Path('id') String id,
    @Body() UserModel user,
  );

  @DELETE('/users/{id}')
  Future<void> deleteUser(@Path('id') String id);
}
```

### Step 2: Generate API Client

```bash
# Run build_runner to generate api_service.g.dart
flutter pub run build_runner build
```

### Step 3: Create Data Models

```dart
// lib/data/models/user_model.dart
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final String id;
  final String name;
  final String email;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
```

### Step 4: Setup Dio Provider

```dart
// lib/core/providers/dio_provider.dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.example.com/v1',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
    ),
  );

  // Add logging interceptor in debug mode
  if (kDebugMode) {
    dio.interceptors.add(
      LoggingInterceptor(),
    );
  }

  // Add auth interceptor
  dio.interceptors.add(AuthInterceptor(ref));

  return dio;
});

// API Service provider
final apiServiceProvider = Provider<ApiService>((ref) {
  final dio = ref.watch(dioProvider);
  return ApiService(dio);
});
```

### Step 5: Create Repository

```dart
// lib/data/repositories/user_repository.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../services/api/api_service.dart';

class UserRepository {
  final ApiService _apiService;

  UserRepository(this._apiService);

  Future<User> getUser(String id) async {
    try {
      final model = await _apiService.getUser(id);
      return model.toEntity();
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<User>> getUsers() async {
    try {
      final models = await _apiService.getUsers();
      return models.map((m) => m.toEntity()).toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          return ConnectionException('Connection timeout');
        case DioExceptionType.receiveTimeout:
          return ConnectionException('Receive timeout');
        case DioExceptionType.badResponse:
          return ApiException(
            'API Error: ${error.response?.statusCode}',
            error.response?.data?['message'] ?? 'Unknown error',
          );
        default:
          return ApiException('Request failed', error.message);
      }
    }
    return UnknownException('An unexpected error occurred');
  }
}

// Repository provider
final userRepositoryProvider = Provider<UserRepository>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return UserRepository(apiService);
});
```

## Creating API Clients

### GET Request

```dart
@RestApi(baseUrl: 'https://api.example.com/v1')
abstract class ApiService {
  // Simple GET
  @GET('/users/{id}')
  Future<UserModel> getUser(@Path('id') String id);

  // GET with query parameters
  @GET('/users')
  Future<List<UserModel>> getUsers(
    @Query('page') int page,
    @Query('limit') int limit,
  );

  // GET with named parameters
  @GET('/users')
  Future<List<UserModel>> searchUsers(
    @Query('name') String? name,
    @Query('email') String? email,
  );

  // GET with headers
  @GET('/profile')
  @Headers(<String, dynamic>{'Authorization': 'Bearer token'})
  Future<UserModel> getProfile();
}
```

### POST Request

```dart
// Simple POST
@POST('/users')
Future<UserModel> createUser(@Body() UserModel user);

// POST with headers
@POST('/login')
@Headers(<String, dynamic>{'Content-Type': 'application/json'})
Future<LoginResponse> login(@Body() LoginRequest request);

// POST with form data
@POST('/upload')
@MultiPart()
Future<UploadResponse> uploadImage(
  @Part(name: 'file') List<int> fileBytes,
  @Part(name: 'fileName') String fileName,
);
```

### PUT/PATCH Request

```dart
@PUT('/users/{id}')
Future<UserModel> updateUser(
  @Path('id') String id,
  @Body() UserModel user,
);

@PATCH('/users/{id}')
Future<UserModel> partialUpdate(
  @Path('id') String id,
  @Body() Map<String, dynamic> updates,
);
```

### DELETE Request

```dart
@DELETE('/users/{id}')
Future<void> deleteUser(@Path('id') String id);

// With response
@DELETE('/users/{id}')
Future<DeleteResponse> deleteUserWithResponse(@Path('id') String id);
```

## Making Requests

### In a Provider

```dart
// Simple async fetch
final userProvider = FutureProvider.family<User, String>((ref, userId) async {
  final repository = ref.watch(userRepositoryProvider);
  return repository.getUser(userId);
});

// Usage
final userAsync = ref.watch(userProvider('123'));
```

### In a Widget

```dart
class UserDetail extends ConsumerWidget {
  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider(userId));

    return userAsync.when(
      data: (user) => UserDisplay(user: user),
      loading: () => const LoadingWidget(),
      error: (error, st) => ErrorWidget(error: error.toString()),
    );
  }
}
```

### Manual Request

```dart
class UserNotifier extends AsyncNotifier<User> {
  @override
  Future<User> build() async {
    return await _repository.getUser('default-id');
  }

  Future<void> updateUser(String name) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      // Manual request
      return await _repository.updateUser(
        name: name,
      );
    });
  }
}
```

## Error Handling

### Custom Exception Classes

```dart
// lib/core/exceptions/exceptions.dart
abstract class AppException implements Exception {
  final String message;
  AppException(this.message);

  @override
  String toString() => message;
}

class ApiException extends AppException {
  final dynamic originalException;
  ApiException(String message, [this.originalException])
      : super(message);
}

class ConnectionException extends AppException {
  ConnectionException(String message) : super(message);
}

class UnknownException extends AppException {
  UnknownException(String message) : super(message);
}
```

### Error Handling in Repository

```dart
class UserRepository {
  Future<User> getUser(String id) async {
    try {
      final model = await _apiService.getUser(id);
      return model.toEntity();
    } on DioException catch (e) {
      AppLogger.error('API Error', e);
      throw _mapDioException(e);
    } catch (e) {
      AppLogger.error('Unexpected Error', e);
      rethrow;
    }
  }

  AppException _mapDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return ConnectionException('Connection timeout');
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        if (statusCode == 404) {
          return ApiException('User not found');
        } else if (statusCode == 401) {
          return ApiException('Unauthorized');
        }
        return ApiException('Server error: $statusCode');
      default:
        return ApiException('Network error: ${e.message}');
    }
  }
}
```

### Error Handling in UI

```dart
class UserList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(usersProvider);

    return usersAsync.when(
      data: (users) => ListView(
        children: users.map((user) => UserTile(user: user)).toList(),
      ),
      loading: () => const CircularProgressIndicator(),
      error: (error, stackTrace) {
        String message = 'Error loading users';

        if (error is ConnectionException) {
          message = 'Connection failed. Please check your internet.';
        } else if (error is ApiException) {
          message = error.message;
        }

        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(message),
              SizedBox(height: context.spacing.s16),
              ElevatedButton(
                onPressed: () => ref.refresh(usersProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        );
      },
    );
  }
}
```

## Examples

### Example 1: Simple User Fetch

```dart
// Model
@JsonSerializable()
class UserModel {
  final String id;
  final String name;
  final String email;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}

// API Service
@RestApi(baseUrl: 'https://api.example.com/v1')
abstract class ApiService {
  factory ApiService(Dio dio) = _ApiService;

  @GET('/users/{id}')
  Future<UserModel> getUser(@Path('id') String id);
}

// Repository
class UserRepository {
  final ApiService _apiService;

  UserRepository(this._apiService);

  Future<User> getUser(String id) async {
    final model = await _apiService.getUser(id);
    return User(
      id: model.id,
      name: model.name,
      email: model.email,
    );
  }
}

// Provider
final userProvider = FutureProvider.family<User, String>((ref, id) {
  return ref.watch(userRepositoryProvider).getUser(id);
});

// Widget
class UserDetail extends ConsumerWidget {
  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider(userId));

    return userAsync.when(
      data: (user) => Text(user.name),
      loading: () => CircularProgressIndicator(),
      error: (e, st) => Text('Error: $e'),
    );
  }
}
```

### Example 2: Authentication Flow

```dart
// Login Request/Response
@JsonSerializable()
class LoginRequest {
  final String email;
  final String password;

  LoginRequest({required this.email, required this.password});

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);

  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}

@JsonSerializable()
class AuthResponse {
  final String token;
  final UserModel user;

  AuthResponse({required this.token, required this.user});

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);
}

// API Service
@RestApi(baseUrl: 'https://api.example.com/v1')
abstract class ApiService {
  factory ApiService(Dio dio) = _ApiService;

  @POST('/auth/login')
  Future<AuthResponse> login(@Body() LoginRequest request);

  @POST('/auth/logout')
  @Headers(<String, dynamic>{'Authorization': 'Bearer'})
  Future<void> logout();
}

// Auth Notifier
class AuthNotifier extends AsyncNotifier<AuthState> {
  @override
  Future<AuthState> build() async {
    // Load stored token
    return AuthState.unauthenticated();
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final response = await ref
          .read(apiServiceProvider)
          .login(LoginRequest(email: email, password: password));

      // Save token
      await ref
          .read(secureStorageProvider)
          .save('auth_token', response.token);

      return AuthState.authenticated(response.user.toEntity());
    });
  }
}

// Provider
final authProvider = AsyncNotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);
```

## Best Practices

### ✅ DO:

1. **Use Repository Pattern**: Abstraction between API and widgets
   ```dart
   // ✅ Good
   ref.read(userRepositoryProvider).getUser(id);
   
   // ❌ Bad
   ref.read(apiServiceProvider).getUser(id);
   ```

2. **Map Models to Entities**: Separate API and business logic
   ```dart
   // ✅ Good
   final model = await api.getUser();
   return model.toEntity();  // UserModel → User
   ```

3. **Handle Errors Explicitly**: Map API errors to domain exceptions
   ```dart
   // ✅ Good
   catch (e is DioException) {
     if (e.response?.statusCode == 404) {
       throw NotFoundException();
     }
   }
   ```

4. **Use Interceptors**: For auth, logging, error handling
   ```dart
   dio.interceptors.add(AuthInterceptor());
   dio.interceptors.add(LoggingInterceptor());
   ```

5. **Cache Responses**: Avoid unnecessary API calls
   ```dart
   // ✅ Good
   ref.refresh(userProvider);  // Manual refresh
   
   // Auto-dispose after 5 minutes
   final userProvider = FutureProvider.autoDispose.family(...)
   ```

### ❌ DON'T:

1. **Avoid Direct API Calls in Widgets**
   ```dart
   // ❌ Bad
   apiService.getUser()
   
   // ✅ Good
   ref.watch(userProvider)
   ```

2. **Avoid Duplicate API Logic**
   ```dart
   // ❌ Don't repeat getUser() logic in multiple places
   // ✅ Create a repository method and reuse
   ```

3. **Don't Ignore Timeouts**
   ```dart
   // ✅ Good
   BaseOptions(
     connectTimeout: Duration(seconds: 10),
     receiveTimeout: Duration(seconds: 10),
   )
   ```

4. **Avoid Storing Secrets in Code**
   ```dart
   // ❌ Bad
   static const String API_KEY = 'secret123';
   
   // ✅ Good - Use environment variables or secure storage
   ```

5. **Don't Mix Async Patterns**
   ```dart
   // ✅ Good - Stick to one pattern (Riverpod)
   ref.watch(userProvider)
   
   // ❌ Avoid mixing with FutureBuilder or StreamBuilder
   ```

---

**Next Steps**:
- Check [State Management](./StateManagement.md) for provider patterns
- Review [Architecture](./Architecture.md) for overall design
- See [Conventions](./Conventions.md) for coding standards

For more info, visit [Retrofit Docs](https://pub.dev/packages/retrofit) and [Dio Docs](https://pub.dev/packages/dio)
