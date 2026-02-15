import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/auth_provider.dart';

class EmailLoginForm extends ConsumerStatefulWidget {
  final VoidCallback onCancel;
  final Function(String) onError;
  final VoidCallback onSuccess;
  final bool isSignUp;

  const EmailLoginForm({
    super.key,
    required this.onCancel,
    required this.onError,
    required this.onSuccess,
    this.isSignUp = false,
  });

  @override
  ConsumerState<EmailLoginForm> createState() => _EmailLoginFormState();
}

class _EmailLoginFormState extends ConsumerState<EmailLoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _displayNameController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _displayNameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _isLoading = true);

    try {
      if (widget.isSignUp) {
        await ref
            .read(authProvider.notifier)
            .signUpWithEmail(
              email: _emailController.text.trim(),
              password: _passwordController.text,
              displayName: _displayNameController.text.trim(),
            );
      } else {
        await ref
            .read(authProvider.notifier)
            .loginWithEmail(
              email: _emailController.text.trim(),
              password: _passwordController.text,
            );
      }

      widget.onSuccess();
    } catch (e) {
      widget.onError(e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ===========================
  // INPUT STYLE (REUSABLE)
  // ===========================
  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      labelStyle: const TextStyle(color: Colors.black87),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: Colors.black54, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: Colors.black, width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ===========================
            // HEADER
            // ===========================
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: widget.onCancel,
                ),
                const SizedBox(width: 8),
                Text(
                  widget.isSignUp ? 'Create Account' : 'Sign In',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ===========================
            // DISPLAY NAME (SIGN UP)
            // ===========================
            if (widget.isSignUp) ...[
              TextField(
                controller: _displayNameController,
                decoration: _inputDecoration('Full Name'),
              ),
              const SizedBox(height: 16),
            ],

            // ===========================
            // EMAIL
            // ===========================
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: _inputDecoration('Email Address'),
            ),

            const SizedBox(height: 16),

            // ===========================
            // PASSWORD
            // ===========================
            TextField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              decoration: _inputDecoration('Password').copyWith(
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    color: Colors.black54,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ===========================
            // PRIMARY BUTTON
            // ===========================
            ElevatedButton(
              onPressed: _isLoading ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      widget.isSignUp ? 'Create Account' : 'Sign In',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),

            const SizedBox(height: 16),

            // ===========================
            // FOOTER ACTION
            // ===========================
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (_) => EmailLoginForm(
                    isSignUp: !widget.isSignUp,
                    onCancel: widget.onCancel,
                    onError: widget.onError,
                    onSuccess: widget.onSuccess,
                  ),
                );
              },
              child: Text(
                widget.isSignUp
                    ? 'Already have an account? Sign In'
                    : 'Don’t have an account? Sign Up',
                style: const TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
