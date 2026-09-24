import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../view_model/login_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rememberMe = ref.watch(rememberMeProvider);
    final signIn = ref.watch(loginProvider);

    ref.listen(loginProvider, (previous, next) {
      if (next.hasError || (next.hasValue && next.value == false)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sign in failed. Please try again.')),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Sign in')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
              textInputAction: TextInputAction.next,
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
              onSubmitted: (_) => _submit(),
            ),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Remember me'),
              value: rememberMe.value ?? false,
              onChanged: rememberMe.isLoading
                  ? null
                  : (value) {
                      if (value != null) {
                        ref
                            .read(rememberMeProvider.notifier)
                            .setRememberMe(value);
                      }
                    },
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: signIn.isLoading ? null : _submit,
              child: signIn.isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Sign in'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit() {
    return ref
        .read(loginProvider.notifier)
        .signIn(
          username: _usernameController.text.trim(),
          password: _passwordController.text,
        );
  }
}
