import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/auth_text_field.dart';

/// Backend: PUT /profile/update
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController(text: 'Yazan');
  final _lastNameController = TextEditingController(text: 'Khalifa');
  final _phoneController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  String? _validateName(String? value, String field) {
    if (value != null && value.trim().isNotEmpty && value.trim().length < 2) return '$field is too short';
    return null;
  }

  String? _validatePhone(String? value) {
    if (value != null && value.trim().isNotEmpty) {
      if (!RegExp(r'^\+?[\d\s\-]{7,20}$').hasMatch(value.trim())) return 'Enter a valid phone number';
    }
    return null;
  }

  void _handleSave() {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() => _isLoading = false);
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile updated successfully')));
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
              child: Row(children: [
                IconButton(onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back_ios_new, size: 18), color: AppColors.textPrimary),
                Text('Edit Profile', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 18)),
              ]),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                child: Form(
                  key: _formKey,
                  child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                    const SizedBox(height: 8),
                    Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Expanded(child: AuthTextField(label: 'First Name', hintText: 'John',
                          controller: _firstNameController, validator: (v) => _validateName(v, 'First name'))),
                      const SizedBox(width: 14),
                      Expanded(child: AuthTextField(label: 'Last Name', hintText: 'Doe',
                          controller: _lastNameController, validator: (v) => _validateName(v, 'Last name'))),
                    ]),
                    const SizedBox(height: 20),
                    AuthTextField(label: 'Phone Number (optional)', hintText: '+963 9XX XXX XXXX',
                        controller: _phoneController, keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.done, validator: _validatePhone),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _handleSave,
                      child: _isLoading
                          ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(strokeWidth: 2.4, color: Colors.white))
                          : const Text('Save Changes'),
                    ),
                  ]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
