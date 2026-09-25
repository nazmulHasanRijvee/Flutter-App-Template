# Networking & API Integration

The network stack combines **Dio** for low-level HTTP transport and **Retrofit** for type-safe, declarative REST endpoint mapping.

---

## 1. Network Architecture Overview

```text
 ┌────────────────────────────────────────────────────────┐
 │                      Presentation                      │
 └───────────────────────────┬────────────────────────────┘
                             │ invokes
                             ▼
 ┌────────────────────────────────────────────────────────┐
 │                   Repository Layer                     │
 └───────────────────────────┬────────────────────────────┘
                             │ wraps via Api.call()
                             ▼
 ┌────────────────────────────────────────────────────────┐
 │                 RestClient (Retrofit)                  │
 └───────────────────────────┬────────────────────────────┘
                             │ translates to
                             ▼
 ┌────────────────────────────────────────────────────────┐
 │                    Dio HTTP Client                     │
 │  • Base Options (Timeout: 30s, Base URL)               │
 │  • Interceptors Chain:                                 │
 │    1. AccessTokenInterceptor (Adds Bearer token)       │
 │    2. TokenRefreshInterceptor (401 catch & refresh)    │
 │    3. LogInterceptor (Debug mode only)                 │
 └────────────────────────────────────────────────────────┘
```

---

## 2. Token Refresh & Concurrency Deep Dive

For a complete explanation with **Eraser-style architecture diagrams**, **Mermaid sequence diagrams**, single-flight concurrency, and token rotation details, see:

👉 **[Token Refresh Logic](token_refresh_logic.md)**

---

## 3. Invoking Endpoints via `Api.call`

Network calls are safely encapsulated with `Api.call`, ensuring standard error formatting and eliminating boilerplate `try/catch` logic in repositories:

```dart
final client = ref.read(restClientProvider);

await Api.call(
  action: client.login({'username': username, 'password': password}),
  onSuccess: (data) async {
    // Process JSON response map
  },
  onError: (errorMessage) async {
    // Surface user-friendly error message to the view model
  },
);
```

---

## 4. Adding a New API Endpoint

1. **Add Route Constant**: Add the route path to `lib/src/data/services/network/endpoints.dart`.
2. **Declare in RestClient**: Add the method with Retrofit annotations in `lib/src/data/services/network/rest_client.dart`:
   ```dart
   @POST(Endpoints.login)
   Future<dynamic> login(@Body() Map<String, dynamic> body);
   ```
3. **Run Code Generator**:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```
4. **Call from Repository**: Implement the repository method utilizing `Api.call`.
