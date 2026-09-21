# Networking

The network stack uses Dio for transport and Retrofit for declarative API clients.

## Configuration

`Endpoints.base` and `Endpoints.communityBase` read compile-time values:

```dart
static const base = String.fromEnvironment('BASE_URL');
static const communityBase = String.fromEnvironment('COMMUNITY_URL');
```

Provide them with `--dart-define` or `--dart-define-from-file`. They are not runtime secrets.

## Request flow

```text
provider → RestClient → DioClient → interceptors → backend
                         ↓
                    Api.call error boundary
```

`DioClient` configures JSON headers and 30-second connect/receive timeouts. It registers:

- `AccessTokenInterceptor` for attaching authentication data
- `TokenRefreshInterceptor` for refreshing expired access tokens
- Dio's body logger in debug mode only

`RestClient` currently declares register, login, and forgot-password methods. The endpoint constants also include reset-password, OTP, community, Quran, and chat paths for future or feature-specific clients.

## Calling an endpoint

Use the provider rather than creating a Dio or Retrofit client in a widget:

```dart
final client = ref.read(restClientProvider);

await Api.call(
  action: client.login(payload),
  onSuccess: (response) async {
    // Map the response and save the session.
  },
  onError: (message) async {
    // Show a user-facing error.
  },
);
```

## Error handling

`Api.call` handles `DioException` separately. If the backend returns a JSON map with a `message` field, that message is passed to `onError`; otherwise the Dio message or a fallback string is used. Unexpected exceptions, including mapping failures, are logged and passed to `onError`.

Keep business success handling outside the network try/catch boundary so application errors are not mistaken for transport errors.

## Adding an endpoint

1. Add the path to `Endpoints`.
2. Add a Retrofit annotation and method to `RestClient` or a feature-specific client.
3. Regenerate code:

   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. Expose the client through a provider.
5. Call it from a repository or notifier and cover success and failure cases with tests.
