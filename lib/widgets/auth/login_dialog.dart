import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/auth_provider.dart';
import 'email_login_form.dart';

class LoginDialog extends ConsumerStatefulWidget {
  const LoginDialog({super.key});

  @override
  ConsumerState<LoginDialog> createState() => _LoginDialogState();
}

class _LoginDialogState extends ConsumerState<LoginDialog> {
  bool _isLoading = false;
  String? _error;

  Future<void> _runAuth(
    Future<dynamic> Function() action,
    String successMessage,
  ) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final result = await action();
      if (result != null && mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(successMessage),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ===========================
                // HEADER
                // ===========================
                const Text(
                  'Welcome to QuoteMyTrade',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Sign in to your account',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),

                const SizedBox(height: 28),

                if (_error != null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      border: Border.all(color: Colors.red.shade200),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      _error!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),

                if (_error != null) const SizedBox(height: 16),

                // ===========================
                // PRIMARY: EMAIL
                // ===========================
                ElevatedButton.icon(
                  onPressed: _isLoading
                      ? null
                      : () {
                          Navigator.pop(context);
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) => EmailLoginForm(
                              onCancel: () => Navigator.pop(context),
                              onError: (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(e),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              },
                              onSuccess: () {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Logged in successfully'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              },
                            ),
                          );
                        },
                  icon: const Icon(Icons.email_outlined),
                  label: const Text('Continue with Email'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // ===========================
                // DIVIDER
                // ===========================
                Row(
                  children: const [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'or continue with',
                        style: TextStyle(fontSize: 12, color: Colors.black45),
                      ),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),

                const SizedBox(height: 20),

                // ===========================
                // GOOGLE
                // ===========================
                OutlinedButton.icon(
                  onPressed: _isLoading
                      ? null
                      : () => _runAuth(
                          () =>
                              ref.read(authProvider.notifier).loginWithGoogle(),
                          'Logged in with Google',
                        ),
                  icon: const Icon(Icons.g_mobiledata),
                  label: const Text('Continue with Google'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black87,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: Colors.black54),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // ===========================
                // APPLE
                // ===========================
                OutlinedButton.icon(
                  onPressed: _isLoading
                      ? null
                      : () => _runAuth(
                          () =>
                              ref.read(authProvider.notifier).loginWithApple(),
                          'Logged in with Apple',
                        ),
                  icon: const Icon(Icons.apple),
                  label: const Text('Continue with Apple'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black87,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: Colors.black54),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),

                if (_isLoading) ...[
                  const SizedBox(height: 24),
                  const Center(
                    child: SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
