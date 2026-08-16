# State Management with Riverpod

This guide explains how state management works in this project using **Riverpod**, a reactive state management solution for Flutter.

## Table of Contents

- [Overview](#overview)
- [Core Concepts](#core-concepts)
- [Provider Types](#provider-types)
- [Practical Examples](#practical-examples)
- [Best Practices](#best-practices)
- [Common Patterns](#common-patterns)

## Overview

**Riverpod** is chosen for this project because it:
- ✅ Eliminates the Service Locator pattern pitfalls
- ✅ Provides compile-time safety
- ✅ Makes testing easier with dependency injection
- ✅ Supports async operations elegantly
- ✅ Enables efficient widget rebuilds

### Key Benefits

```
No Global State Issues      →  Type-Safe     →  Easy Testing
        ↓
    Dependency Injection    →  Predictable   →  Debuggable
        ↓
    Reactive Updates        →  Performant    →  Maintainable
```

## Core Concepts

### 1. What is a Provider?

A **Provider** is a container for a piece of state or logic for singleton pattern (replacing **get_it**). It can be:
- Read by widgets
- Watched for changes
- Combined with other providers
- Overridden for testing

```dart
// Simple provider
final myProvider = Provider<String>((ref) => 'Hello');

// Use in widget
final value = ref.read(myProvider);        // Read once
final stream = ref.watch(myProvider);      // Watch for changes
```

### 2. ProviderScope

All Riverpod apps must wrap their root widget with `ProviderScope`:

```dart
void main() {
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}
```

This sets up the state management system.

### 3. WidgetRef

Inside a widget, use `WidgetRef` to access providers:

```dart
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ref.watch()   - React to changes
    // ref.read()    - Read once
    // ref.refresh() - Force refetch
    // ref.listen()  - Subscribe to changes
  }
}
```

## Provider Types

### 1. Provider (Synchronous)

Returns a simple value or computes synchronously:

```dart
// Simple value
final nameProvider = Provider<String>((ref) => 'John');

// Computed value
final ageProvider = Provider<int>((ref) => 25);

final isAdultProvider = Provider<bool>((ref) {
  final age = ref.watch(ageProvider);
  return age >= 18;
});

// Usage
ref.watch(isAdultProvider);  // true or false based on age
```

### 2. FutureProvider (Asynchronous)

Returns a `Future` for async operations:

```dart
final userProvider = FutureProvider<User>((ref) async {
  final userId = ref.watch(userIdProvider);
  return await fetchUser(userId);
});

// Usage in widget
class UserProfile extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider);
    
    return userAsync.when(
      data: (user) => Text(user.name),
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
    );
  }
}
```

### 3. StateProvider (Mutable State)

For simple mutable state without complex logic:

```dart
final counterProvider = StateProvider<int>((ref) => 0);

// Usage
ref.watch(counterProvider);              // Get value
ref.read(counterProvider.notifier).state = 10;  // Set value
```

### 4. StateNotifierProvider (Advanced State)

For complex state with methods:

```dart
class CounterNotifier extends StateNotifier<int> {
  CounterNotifier() : super(0);
  
  void increment() => state++;
  void decrement() => state--;
  void reset() => state = 0;
}

final counterProvider = StateNotifierProvider<CounterNotifier, int>((ref) {
  return CounterNotifier();
});

// Usage
ref.read(counterProvider.notifier).increment();
ref.watch(counterProvider);  // 1
```

### 5. AsyncNotifierProvider (Async State Management)

For managing async operations with state:

```dart
class UserNotifier extends AsyncNotifier<User> {
  @override
  Future<User> build() async {
    return await fetchUser();
  }
  
  Future<void> updateUser(String name) async {
    state = const AsyncValue.loading();
    try {
      final user = await api.updateUser(name);
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final userProvider = AsyncNotifierProvider<UserNotifier, User>(
  UserNotifier.new,
);

// Usage
await ref.read(userProvider.notifier).updateUser('Jane');
ref.watch(userProvider);  // AsyncValue<User>
```

### 6. ChangeNotifierProvider (Legacy, not recommended)

Equivalent to `ChangeNotifier` in Provider package:

```dart
class Counter extends ChangeNotifier {
  int _count = 0;
  int get count => _count;
  
  void increment() {
    _count++;
    notifyListeners();
  }
}

final counterProvider = ChangeNotifierProvider((ref) => Counter());

// Usage (legacy pattern, prefer AsyncNotifier)
ref.read(counterProvider).increment();
```

## Practical Examples

### Example 1: Simple Counter

```dart
// Provider
final counterProvider = StateProvider<int>((ref) => 0);

// Widget
class CounterWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(counterProvider);
    
    return Column(
      children: [
        Text('Count: $count'),
        ElevatedButton(
          onPressed: () => 
            ref.read(counterProvider.notifier).state++,
          child: Text('Increment'),
        ),
      ],
    );
  }
}
```

### Example 2: Fetching Data

```dart
// Provider
final usersProvider = FutureProvider<List<User>>((ref) async {
  final api = ref.watch(apiServiceProvider);
  return api.getUsers();
});

// Widget
class UserList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(usersProvider);
    
    return usersAsync.when(
      data: (users) => ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) => 
          UserTile(user: users[index]),
      ),
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => ErrorWidget(error: error),
    );
  }
}
```

### Example 3: Computed State

```dart
// Basic providers
final firstNameProvider = StateProvider<String>((ref) => 'John');
final lastNameProvider = StateProvider<String>((ref) => 'Doe');

// Computed from others
final fullNameProvider = Provider<String>((ref) {
  final firstName = ref.watch(firstNameProvider);
  final lastName = ref.watch(lastNameProvider);
  return '$firstName $lastName';
});

// Usage
Text(ref.watch(fullNameProvider));  // "John Doe"
```

### Example 4: Theme Provider (From Project)

```dart
// State Notifier
class ThemeNotifier extends AsyncNotifier<ThemeMode> {
  @override
  Future<ThemeMode> build() async {
    return await _loadTheme();
  }
  
  Future<void> changeTheme(ThemeMode newTheme) async {
    state = AsyncValue.data(newTheme);
    await _saveTheme(newTheme);
  }
  
  Future<ThemeMode> _loadTheme() async {
    final cacheService = ref.read(cacheServiceProvider);
    final themeName = cacheService.get<String>(CacheKey.themeMode);
    return themeName != null 
      ? ThemeMode.values.firstWhere((e) => e.name == themeName)
      : ThemeMode.system;
  }
  
  Future<void> _saveTheme(ThemeMode themeMode) async {
    final cacheService = ref.read(cacheServiceProvider);
    await cacheService.save<String>(CacheKey.themeMode, themeMode.name);
  }
}

// Provider
final themeProvider = AsyncNotifierProvider<ThemeNotifier, ThemeMode>(
  ThemeNotifier.new,
);

// Usage in Widget
class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider).value;
    
    return MaterialApp(
      themeMode: themeMode,
      theme: lightTheme,
      darkTheme: darkTheme,
    );
  }
}

// Change theme
ref.read(themeProvider.notifier).changeTheme(ThemeMode.dark);
```

### Example 5: Complex State Management

```dart
// User repository provider
final userRepositoryProvider = Provider<UserRepository>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return UserRepository(apiService);
});

// Fetch user by ID
final userProvider = FutureProvider.family<User, String>((ref, userId) async {
  final repository = ref.watch(userRepositoryProvider);
  return repository.getUser(userId);
});

// Widget to display user
class UserPage extends ConsumerWidget {
  final String userId;
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider(userId));
    
    return userAsync.when(
      data: (user) => UserDetails(user: user),
      loading: () => LoadingWidget(),
      error: (error, stack) => ErrorScreen(error: error),
    );
  }
}
```

## Best Practices

### ✅ DO:

1. **Use AsyncNotifier for complex state**
   ```dart
   // ✅ Good
   class UserNotifier extends AsyncNotifier<User> {
     Future<void> updateUser(String name) async { ... }
   }
   
   // ❌ Avoid (too simple)
   class UserNotifier extends StateNotifier<AsyncValue<User>> { ... }
   ```

2. **Leverage `family` for parameterized providers**
   ```dart
   // ✅ Good
   final userProvider = FutureProvider.family<User, String>((ref, id) {
     return fetchUser(id);
   });
   
   ref.watch(userProvider('123'))  // Separate instance per ID
   ```

3. **Use `.select()` to watch specific properties**
   ```dart
   // ✅ Good - Only rebuilds when name changes
   ref.watch(userProvider.select((user) => user.name));
   
   // ❌ Less efficient - Rebuilds on any user change
   ref.watch(userProvider);
   ```

4. **Provider composition for shared logic**
   ```dart
   // ✅ Good
   final usersProvider = FutureProvider<List<User>>((ref) async {
     return ref.read(userRepositoryProvider).getUsers();
   });
   
   // ❌ Avoid - Duplicated API call logic
   final usersProvider = FutureProvider<List<User>>((ref) async {
     return ref.read(apiServiceProvider).getUsers();
   });
   ```

5. **Test with provider overrides**
   ```dart
   // ✅ Good
   testWidgets('shows user', (WidgetTester tester) async {
     await tester.pumpWidget(
       ProviderContainer(
         overrides: [
           userProvider.overrideWithValue(
             AsyncValue.data(User(id: '1', name: 'Test'))
           ),
         ],
         child: MaterialApp(home: UserPage()),
       ),
     );
   });
   ```

### ❌ DON'T:

1. **Avoid global state in ServiceLocator pattern**
   ```dart
   // ❌ Bad
   final userService = UserService();  // Global
   
   // ✅ Good
   final userServiceProvider = Provider((ref) => UserService());
   ```

2. **Don't mix StateNotifier and Async**
   ```dart
   // ❌ Avoid - Complex nesting
   StateNotifierProvider<StateNotifier<AsyncValue<User>>, AsyncValue<User>>
   
   // ✅ Good - Use AsyncNotifier
   AsyncNotifierProvider<UserNotifier, User>
   ```

3. **Don't watch at root level if not needed**
   ```dart
   // ❌ Bad - Rebuilds entire widget
   final userName = ref.watch(userProvider).when(
     data: (user) => user.name,
     ...
   );
   
   // ✅ Good - Only rebuild relevant part
   final name = ref.watch(userProvider.select((u) => u.name));
   Text(name);
   ```

## Common Patterns

### Pattern 1: Loading State Management

```dart
class FetchDataNotifier extends AsyncNotifier<List<Item>> {
  @override
  Future<List<Item>> build() async {
    return fetchItems();
  }
  
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => fetchItems());
  }
}

final itemsProvider = AsyncNotifierProvider<FetchDataNotifier, List<Item>>(
  FetchDataNotifier.new,
);

// Usage
class ItemList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(itemsProvider);
    
    return itemsAsync.when(
      data: (items) => RefreshIndicator(
        onRefresh: () => ref.refresh(itemsProvider.future),
        child: ListView(
          children: items.map((item) => ListTile(title: Text(item.name))).toList(),
        ),
      ),
      loading: () => SkeletonLoader(),
      error: (error, st) => ErrorRetry(
        error: error,
        onRetry: () => ref.refresh(itemsProvider),
      ),
    );
  }
}
```

### Pattern 2: Form State

```dart
class FormNotifier extends StateNotifier<FormData> {
  FormNotifier() : super(FormData.empty());
  
  void updateName(String name) {
    state = state.copyWith(name: name);
  }
  
  void updateEmail(String email) {
    state = state.copyWith(email: email);
  }
  
  Future<void> submit() async {
    try {
      await api.submitForm(state);
      state = FormData.empty();
    } catch (e) {
      // Handle error
    }
  }
}

final formProvider = StateNotifierProvider<FormNotifier, FormData>((ref) {
  return FormNotifier();
});

// Usage
class MyForm extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(formProvider);
    
    return Column(
      children: [
        TextField(
          onChanged: (value) => 
            ref.read(formProvider.notifier).updateName(value),
        ),
        ElevatedButton(
          onPressed: () => 
            ref.read(formProvider.notifier).submit(),
          child: Text('Submit'),
        ),
      ],
    );
  }
}
```

### Pattern 3: Cache Invalidation

```dart
// Users provider
final usersProvider = FutureProvider<List<User>>((ref) async {
  return fetchUsers();
});

// After user is created/updated/deleted
void invalidateCache(WidgetRef ref) {
  ref.refresh(usersProvider);  // Force refetch
}

// Or with timeout
void invalidateWithDelay(WidgetRef ref) {
  Future.delayed(Duration(seconds: 2), () {
    ref.refresh(usersProvider);
  });
}
```

---

**Key Takeaway**: Riverpod makes state management predictable, testable, and efficient. Always think about dependencies and use the right provider type for your use case.

For more info, visit [Riverpod Documentation](https://riverpod.dev)
