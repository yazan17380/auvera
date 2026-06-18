import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/auth_text_field.dart';
import 'login_screen.dart';

/// Step 3 (final) of the Forgot Password flow.
///
/// Backend contract: POST /api/reset-password requires Authorization:
/// Bearer {resetToken} (the temporary token returned by verify-reset-otp).
/// Body only needs { "password": "...", "password_confirmation": "..." }
/// - no email or otp field here.
class SetNewPasswordScreen extends StatefulWidget {
  final String resetToken;

  const SetNewPasswordScreen({super.key, required this.resetToken});

  @override
  State<SetNewPasswordScreen> createState() => _SetNewPasswordScreenState();
}

class _SetNewPasswordScreenState extends State<SetNewPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _newPasswordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  void _handleResetPassword() {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Backend integration note:
    // POST /api/reset-password with header Authorization: Bearer widget.resetToken
    // Body: { "password": ..., "password_confirmation": ... }
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() => _isLoading = false);

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password reset successfully')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                    color: AppColors.textPrimary,
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 8),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 12),
                      Text(
                        'Set New Password',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Your new password must be different from previously used passwords',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),

                      const SizedBox(height: 36),

                      AuthTextField(
                        label: 'New Password',
                        hintText: 'Create a new password',
                        controller: _newPasswordController,
                        isPassword: true,
                        validator: _validatePassword,
                      ),
                      const SizedBox(height: 20),

                      AuthTextField(
                        label: 'Confirm New Password',
                        hintText: 'Re-enter your new password',
                        controller: _confirmPasswordController,
                        isPassword: true,
                        textInputAction: TextInputAction.done,
                        validator: _validateConfirmPassword,
                      ),

                      const SizedBox(height: 32),

                      ElevatedButton(
                        onPressed: _isLoading ? null : _handleResetPassword,
                        child: _isLoading
                            ? const SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.4,
                                  color: Colors.white,
                                ),
                              )
                            : const Text('Reset Password'),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
