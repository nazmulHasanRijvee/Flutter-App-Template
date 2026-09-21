# Routing

The app uses go_router with Riverpod-driven redirects.

## Route groups

The route enum is defined in `lib/src/presentation/core/routes/routes.dart`.

### Onboarding routes

- `/splash`
- `/onboarding`

### Authentication routes

- `/login`
- `/register_screen` nested under the login route
- `/reset_pass_screen`
- `/email_verification_screen` nested under reset password
- `/create_new_pass_screen` nested under reset password

### Authenticated shell routes

- `/home_screen`
- `/chat_screen`
- `/community_screen`

The authenticated routes are displayed through a `StatefulShellRoute.indexedStack`, so each bottom-navigation branch can preserve its navigation state.

## Gate policy

`routerStateProvider` derives one destination from three providers:

```text
startup loading or failed → splash
onboarding incomplete     → onboarding
valid stored session      → home shell
no valid session          → login
```

`RedirectGate.redirect` is a pure function. It keeps users on a required gate, permits the complete authentication flow while the login gate is active, and redirects authenticated users away from gate-only routes.

## Adding a route

1. Add a path to the `Routes` enum.
2. Add the `GoRoute` to `parts/onboarding_routes.dart`, `parts/authentication_routes.dart`, or `parts/shell_routes.dart`.
3. Add the screen under the appropriate presentation feature.
4. Add redirect behavior only if the route changes the gate policy.
5. Test direct navigation, back navigation, and behavior after login/logout.

Nested routes use relative paths in go_router. Keep the enum path and route registration aligned so named navigation remains predictable.
