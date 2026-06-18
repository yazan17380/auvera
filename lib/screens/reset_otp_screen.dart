import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import 'set_new_password_screen.dart';

/// Step 2 of the Forgot Password flow.
///
/// Backend contract: POST /api/verify-reset-otp expects { "otp": "123456" }
/// (no email field needed). On success it returns a temporary reset token:
/// { "message": "...", "token": "..." }.
/// That token must be sent as a Bearer token on the next step
/// (POST /api/reset-password) - it is NOT a normal login session.
class ResetOtpScreen extends StatefulWidget {
  final String email;

  const ResetOtpScreen({super.key, required this.email});

  @override
  State<ResetOtpScreen> createState() => _ResetOtpScreenState();
}

class _ResetOtpScreenState extends State<ResetOtpScreen> {
  static const int _otpLength = 6;
  static const int _resendSeconds = 60;

  final List<TextEditingController> _controllers =
      List.generate(_otpLength, (_) => TextEditingController());
  final List<FocusNode> _focusNodes =
      List.generate(_otpLength, (_) => FocusNode());

  bool _isLoading = false;
  bool _hasError = false;
  int _secondsRemaining = _resendSeconds;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  void _startResendTimer() {
    _secondsRemaining = _resendSeconds;
    _canResend = false;
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;
      setState(() => _secondsRemaining--);
      if (_secondsRemaining <= 0) {
        setState(() => _canResend = true);
        return false;
      }
      return true;
    });
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String get _enteredCode => _controllers.map((c) => c.text).join();

  void _onDigitChanged(int index, String value) {
    if (_hasError) {
      setState(() => _hasError = false);
    }
    if (value.isNotEmpty && index < _otpLength - 1) {
      _focusNodes[index + 1].requestFocus();
    }
    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
    if (_enteredCode.length == _otpLength) {
      _handleVerify();
    }
  }

  void _handleVerify() {
    if (_enteredCode.length < _otpLength) {
      setState(() => _hasError = true);
      return;
    }

    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    // Backend integration note:
    // POST /api/verify-reset-otp with { "otp": _enteredCode }
    // On success: store response.token (temporary reset token) and pass it
    // to SetNewPasswordScreen - it's required as a Bearer token for the
    // final POST /api/reset-password call.
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() => _isLoading = false);

      // Mock validation - replace with real API check later
      const mockValidCode = '123456';
      if (_enteredCode == mockValidCode) {
        const mockResetToken = 'mock-reset-token'; // comes from API response.token
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => SetNewPasswordScreen(resetToken: mockResetToken),
          ),
        );
      } else {
        setState(() => _hasError = true);
        for (final c in _controllers) {
          c.clear();
        }
        _focusNodes[0].requestFocus();
      }
    });
  }

  void _handleResend() {
    if (!_canResend) return;

    for (final c in _controllers) {
      c.clear();
    }
    setState(() => _hasError = false);
    _focusNodes[0].requestFocus();
    _startResendTimer();

    // Backend integration note: re-call POST /api/forgot-password with the
    // same email to receive a new OTP code.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Verification code resent')),
    );
  }

  Widget _buildOtpBox(int index) {
    return SizedBox(
      width: 48,
      height: 56,
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: AppColors.cardWhite,
          contentPadding: EdgeInsets.zero,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
              color: _hasError ? AppColors.error : AppColors.border,
              width: 1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
              color: _hasError ? AppColors.error : AppColors.border,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
              color: _hasError ? AppColors.error : AppColors.primary,
              width: 1.4,
            ),
          ),
        ),
        onChanged: (value) => _onDigitChanged(index, value),
      ),
    );
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 12),
                    Text(
                      'Verify Code',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 10),
                    RichText(
                      text: TextSpan(
                        style: Theme.of(context).textTheme.bodyMedium,
                        children: [
                          const TextSpan(
                            text: 'Enter the 6-digit code sent to\n',
                          ),
                          TextSpan(
                            text: widget.email,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        _otpLength,
                        (index) => _buildOtpBox(index),
                      ),
                    ),

                    if (_hasError) ...[
                      const SizedBox(height: 12),
                      Text(
                        'Invalid or expired code.',
                        style: TextStyle(
                          color: AppColors.error,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],

                    const SizedBox(height: 36),

                    ElevatedButton(
                      onPressed: _isLoading ? null : _handleVerify,
                      child: _isLoading
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.4,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Verify'),
                    ),

                    const SizedBox(height: 28),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Didn't receive the code? ",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        GestureDetector(
                          onTap: _handleResend,
                          child: Text(
                            _canResend
                                ? 'Resend'
                                : 'Resend in ${_secondsRemaining}s',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: _canResend
                                  ? AppColors.primary
                                  : AppColors.textHint,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
