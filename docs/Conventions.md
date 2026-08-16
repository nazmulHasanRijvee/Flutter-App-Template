# Coding Conventions & Best Practices

This document outlines the coding standards and best practices followed in this project.

## Table of Contents

- [Dart Style Guide](#dart-style-guide)
- [Flutter Best Practices](#flutter-best-practices)
- [Riverpod Patterns](#riverpod-patterns)
- [Code Organization](#code-organization)
- [Error Handling](#error-handling)
- [Comments & Documentation](#comments--documentation)
- [Testing](#testing)
- [Performance](#performance)

## Dart Style Guide

### Naming Conventions

```dart
// ✅ Classes - PascalCase
class UserProfile {}
class HttpClient {}

// ✅ Constants - camelCase with const keyword
const int maxRetries = 3;
const String appName = 'My App';
const double defaultPadding = 16.0;

// ✅ Variables & Methods - camelCase
String userName;
void updateUser() {}
bool isLoading;

// ✅ Private members - Leading underscore
String _privateVariable;
void _privateMethod() {}

// ✅ Enums - PascalCase for enum, camelCase for values
enum UserRole { admin, moderator, user }

// ✅ Typedefs - PascalCase
typedef UserCallback = void Function(User user);

// ✅ File names - snake_case
user_profile.dart
http_client.dart
```

### Formatting

```dart
// ✅ Line length - Maximum 80-100 characters
final String veryLongVariableName = 'This is a very long string that '
    'spans multiple lines for readability';

// ✅ Indentation - 2 spaces
if (condition) {
  print('Hello');
}

// ✅ Trailing commas in multi-line collections
const List<String> fruits = [
  'apple',
  'banana',
  'orange',
];

// ✅ Blank lines between logical sections
class User {
  String name;
  
  User(this.name);
  
  String greet() => 'Hello, $name';
}
```

### Type Safety

```dart
// ✅ Use explicit types
List<String> names = [];
Map<String, int> scores = {};

// ✅ Use final for immutable variables
final String userName = 'John';
final int age = 25;

// ✅ Use late for late initialization
late String lazyString;

// ❌ Avoid var without clear type inference
var x = 5;  // Type unclear without context

// ✅ Use dynamic only when necessary
dynamic unknownType = getSomething();
```

## Flutter Best Practices

### Widget Best Practices

```dart
// ✅ Use const constructors
const Text('Hello')
const SizedBox(height: 16)

// ✅ Extract complex widgets
class MyComplexWidget extends StatelessWidget {
  const MyComplexWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _header(),
        _body(),
        _footer(),
      ],
    );
  }

  Widget _header() => /* ... */;
  Widget _body() => /* ... */;
  Widget _footer() => /* ... */;
}

// ✅ Use named parameters
FloatingActionButton(
  onPressed: () {},
  tooltip: 'Add',
  child: const Icon(Icons.add),
)

// ✅ Prefer Column/Row with parameters
Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [child1, child2],
)

// ❌ Avoid Nested Columns/Rows
// ❌ Avoid mounting in build method
// ❌ Avoid rebuilding entire screens
```

### State Management

```dart
// ✅ Use ConsumerWidget for state management
class MyWidget extends ConsumerWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(myProvider);
    return Text(state);
  }
}

// ✅ Use .select() to watch specific properties
ref.watch(userProvider.select((user) => user.name))

// ✅ Use .when() for AsyncValue
userAsync.when(
  data: (user) => UserWidget(user: user),
  loading: () => LoadingWidget(),
  error: (error, stack) => ErrorWidget(error: error),
)

// ❌ Avoid mixing state management approaches
// ❌ Avoid setState in ConsumerWidget
// ❌ Avoid watching entire objects when only need property
```

### Async Operations

```dart
// ✅ Handle async properly
Future<void> fetchData() async {
  try {
    final data = await api.getData();
    setState(() => _data = data);
  } catch (e, stackTrace) {
    AppLogger.error('Failed to fetch', e, stackTrace);
  }
}

// ✅ Use AsyncValue for loading states
userAsync.whenData((user) => updateUI(user))
userAsync.maybeWhen(
  data: (user) => Text(user.name),
  orElse: () => CircularProgressIndicator(),
)

// ❌ Avoid bare try-catch without logging
// ❌ Avoid Future without proper error handling
// ❌ Avoid ignoring exceptions
```

## Riverpod Patterns

### Provider Definition

```dart
// ✅ Provider for simple values
final nameProvider = Provider<String>((ref) => 'John');

// ✅ FutureProvider for async operations
final userProvider = FutureProvider<User>((ref) async {
  return await fetchUser();
});

// ✅ FutureProvider.family for parameterized providers
final userByIdProvider = FutureProvider.family<User, String>((ref, id) {
  return fetchUser(id);
});

// ✅ AsyncNotifier for complex state management
class UserNotifier extends AsyncNotifier<User> {
  @override
  Future<User> build() async => await fetchUser();
  
  Future<void> updateUser(String name) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => api.updateUser(name));
  }
}

final userProvider = AsyncNotifierProvider<UserNotifier, User>(
  UserNotifier.new,
);

// ❌ Avoid StateNotifier for async operations (use AsyncNotifier)
// ❌ Avoid global state outside of providers
// ❌ Avoid side effects in provider build
```

### Provider Usage

```dart
// ✅ Watch for changes
ref.watch(myProvider);

// ✅ Read once
ref.read(myProvider);

// ✅ Listen to changes
ref.listen(myProvider, (previous, next) {
  if (next != previous) {
    showNotification();
  }
});

// ✅ Refresh data
ref.refresh(myProvider);

// ✅ Use .select() for efficiency
ref.watch(userProvider.select((user) => user.name))

// ❌ Avoid watching in build without using value
// ❌ Avoid unnecessary provider dependencies
// ❌ Avoid circular dependencies between providers
```

## Code Organization

### Class Structure

```dart
class User {
  // Constants first
  static const String defaultName = 'Unknown';
  
  // Static members
  static int userCount = 0;
  
  // Instance variables
  final String id;
  final String name;
  final String email;
  
  // Constructors
  const User({
    required this.id,
    required this.name,
    required this.email,
  });
  
  // Getters
  String get displayName => name.isEmpty ? defaultName : name;
  
  // Methods
  bool isEmailValid() => email.contains('@');
  
  // toString, == , hashCode
  @override
  String toString() => 'User(id: $id, name: $name)';
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
```

### Function Structure

```dart
// ✅ Organize by purpose
class UserRepository {
  // Fetch operations
  Future<User> getUser(String id) async { /* ... */ }
  Future<List<User>> getUsers() async { /* ... */ }
  
  // Create/Update operations
  Future<User> createUser(User user) async { /* ... */ }
  Future<User> updateUser(User user) async { /* ... */ }
  
  // Delete operations
  Future<void> deleteUser(String id) async { /* ... */ }
  
  // Helper methods
  User _parseResponse(Map<String, dynamic> json) => User.fromJson(json);
}
```

## Error Handling

```dart
// ✅ Handle errors explicitly
try {
  final user = await fetchUser();
  return user;
} on SocketException catch (e) {
  AppLogger.warning('Network error', e);
  rethrow;
} on FormatException catch (e) {
  AppLogger.error('Invalid format', e);
  throw InvalidDataException('Failed to parse user data');
} catch (e, stackTrace) {
  AppLogger.fatal('Unknown error', e, stackTrace);
  throw UnknownException('An unexpected error occurred');
}

// ✅ Use custom exceptions
class AppException implements Exception {
  final String message;
  final dynamic originalException;
  
  AppException(this.message, [this.originalException]);
  
  @override
  String toString() => message;
}

// ✅ Handle in UI with AsyncValue
userAsync.when(
  data: (user) => UserWidget(user: user),
  loading: () => LoadingWidget(),
  error: (error, stack) => ErrorWidget(
    error: error.toString(),
    onRetry: () => ref.refresh(userProvider),
  ),
)

// ❌ Avoid bare except
// ❌ Avoid silently catching exceptions
// ❌ Avoid not logging errors
```

## Comments & Documentation

```dart
// ✅ Class documentation
/// A user in the system.
/// 
/// Contains basic user information and provides methods
/// for validation and transformation.
class User {
  /// The unique identifier for this user.
  final String id;
  
  /// Creates a new [User] instance.
  ///
  /// Throws [ArgumentError] if [id] or [name] is empty.
  User({
    required String id,
    required String name,
  }) : id = id.isEmpty ? throw ArgumentError('id cannot be empty') : id;
  
  /// Validates if the email format is correct.
  ///
  /// Returns true if email contains '@' symbol, false otherwise.
  bool isEmailValid() => email.contains('@');
}

// ✅ Method documentation
/// Fetches a user by their ID.
///
/// Makes an API call to retrieve user data. Returns the user
/// if found, otherwise returns null.
///
/// Throws [NetworkException] if network request fails.
Future<User?> fetchUser(String id) async {
  try {
    final response = await http.get('/users/$id');
    return User.fromJson(response);
  } on SocketException catch (e) {
    throw NetworkException('Failed to fetch user', e);
  }
}

// ✅ Inline comments for complex logic
int calculateDiscount(int price) {
  // Apply 10% discount for prices over 100
  if (price > 100) {
    return (price * 0.9).toInt();
  }
  return price;
}

// ❌ Avoid obvious comments
// ❌ Avoid commented-out code (use version control)
// ❌ Avoid incomplete documentation
```

## Testing

```dart
// ✅ Organize tests by layer
test/
├── unit/
│   ├── entities/
│   └── repositories/
├── widget/
│   └── pages/
└── integration/

// ✅ Write descriptive test names
void main() {
  test('calculateDiscount returns 90 when price is 100', () {
    expect(calculateDiscount(100), equals(90));
  });
  
  test('User creation throws ArgumentError when id is empty', () {
    expect(
      () => User(id: '', name: 'John'),
      throwsArgumentError,
    );
  });
}

// ✅ Use arrange-act-assert pattern
testWidgets('displays loading when fetching', (WidgetTester tester) async {
  // Arrange
  await tester.pumpWidget(const MyApp());
  
  // Act
  await tester.pumpWidget(const UserScreen());
  
  // Assert
  expect(find.byType(CircularProgressIndicator), findsOneWidget);
});

// ✅ Mock providers for testing
testWidgets('shows user name', (WidgetTester tester) async {
  await tester.pumpWidget(
    ProviderContainer(
      overrides: [
        userProvider.overrideWithValue(
          AsyncValue.data(User(id: '1', name: 'John', email: 'john@example.com')),
        ),
      ],
      child: const MaterialApp(home: UserScreen()),
    ),
  );
  
  expect(find.text('John'), findsOneWidget);
});

// ❌ Avoid testing implementation details
// ❌ Avoid testing framework code
// ❌ Avoid non-deterministic tests
```

## Performance

```dart
// ✅ Use const widgets
const Text('Hello')
const Icon(Icons.add)

// ✅ Use const constructors
class MyWidget extends StatelessWidget {
  const MyWidget({super.key});  // ← const constructor
  
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

// ✅ Use select() for efficient rebuilds
ref.watch(userProvider.select((user) => user.name))  // Only rebuild on name change

// ✅ Lazy load heavy data
final heavyDataProvider = FutureProvider.autoDispose((ref) async {
  return await fetchHeavyData();
});

// ✅ Cache API responses
final cachedUserProvider = FutureProvider.autoDispose<User>((ref) async {
  final cached = _cache.get('user');
  if (cached != null) return cached;
  
  final user = await api.getUser();
  _cache.set('user', user);
  return user;
});

// ❌ Avoid unnecessary rebuilds
// ❌ Avoid watching entire objects when only need property
// ❌ Avoid loading large datasets on app start
// ❌ Avoid rendering large lists without lazy loading
```

## Summary Table

| Aspect | ✅ DO | ❌ DON'T |
|--------|-------|---------|
| **Naming** | PascalCase classes, camelCase methods | snake_case for everything |
| **Types** | Explicit typing, use final | var everywhere, dynamic |
| **Async** | Proper error handling, AsyncValue | Fire and forget, bare Future |
| **Widgets** | Const constructors, extract widgets | Large build methods, expensive operations |
| **State** | Riverpod providers, AsyncNotifier | Global state, setState everywhere |
| **Errors** | Custom exceptions, logging | Silent failures, bare except |
| **Comments** | Explain why, not what | Over-comment, commented code |
| **Testing** | Unit + widget tests, mocking | No tests, test implementation |
| **Performance** | const, select(), lazy load | Unnecessary rebuilds, no optimization |

---

**Remember**: These conventions make code maintainable, testable, and scalable. Consistency is key!

For more details, check the [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style) and [Flutter Best Practices](https://flutter.dev/docs/testing/best-practices).
