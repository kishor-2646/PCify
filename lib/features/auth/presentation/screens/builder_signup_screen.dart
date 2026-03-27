import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../shared/widgets/inputs/custom_text_field.dart';
import '../../../../shared/widgets/inputs/custom_dropdown_field.dart';
import '../controllers/auth_controller.dart'; // Import Controller
import 'otp_verification_screen.dart';

class BuilderSignUpScreen extends ConsumerStatefulWidget {
  const BuilderSignUpScreen({super.key});

  @override
  ConsumerState<BuilderSignUpScreen> createState() => _BuilderSignUpScreenState();
}

class _BuilderSignUpScreenState extends ConsumerState<BuilderSignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  // --- Controllers (Basic) ---
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // --- Controllers (Professional) ---
  final _businessNameController = TextEditingController();
  final _gstController = TextEditingController();
  final _aadhaarController = TextEditingController();

  // --- Dropdown State ---
  String? _selectedExperience;
  String? _selectedSpecialization;
  final _serviceAreaController = TextEditingController();

  // --- Checkbox State ---
  bool _acceptAgreement = false;
  bool _hasInsurance = false;
  double _passwordStrength = 0.0;

  // --- Options ---
  final List<String> _experienceOptions = ['0-2 Years', '2-5 Years', '5-10 Years', '10+ Years'];
  final List<String> _specializationOptions = ['Gaming', 'Editing', 'Coding', 'Workstations', 'Budget', 'Custom'];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _businessNameController.dispose();
    _gstController.dispose();
    _aadhaarController.dispose();
    _serviceAreaController.dispose();
    super.dispose();
  }

  void _updatePasswordStrength(String password) {
    double strength = 0;
    if (password.length >= 8) strength += 0.25;
    if (password.contains(RegExp(r'[A-Z]'))) strength += 0.25;
    if (password.contains(RegExp(r'[0-9]'))) strength += 0.25;
    if (password.contains(RegExp(r'[!@#\$&*~]'))) strength += 0.25;
    setState(() => _passwordStrength = strength);
  }

  // --- UPDATED SUBMIT LOGIC ---
  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      if (!_acceptAgreement) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please accept builder agreement')),
        );
        return;
      }

      // Collect Builder Specific Data
      final builderData = {
        'businessName': _businessNameController.text.trim(),
        'gstNumber': _gstController.text.trim(),
        'aadhaarNumber': _aadhaarController.text.trim(), // In real app, consider security/masking before saving
        'yearsExperience': _selectedExperience,
        'specialization': _selectedSpecialization,
        'serviceArea': _serviceAreaController.text.trim(),
        'hasInsurance': _hasInsurance,
        'isVerified': false, // Default to false until admin approves
      };

      // Call Sign Up
      await ref.read(authControllerProvider.notifier).signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        role: 'builder',
        additionalData: builderData, // Pass the extra map
      );

      // Check result
      final authState = ref.read(authControllerProvider);

      if (authState.hasError) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(authState.error.toString()), backgroundColor: Colors.red),
          );
        }
      } else {
        // Success! Navigate to OTP
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OtpVerificationScreen(
                email: _emailController.text,
                isBuilder: true, // Builder Flow
              ),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final builderColor = const Color(0xFF1E293B);
    final authState = ref.watch(authControllerProvider);
    final isLoading = authState.isLoading;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Text(
                  AppStrings.createAccountBuilder,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Join the network of top PC experts.",
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 32),

                // --- Section 1: Basic Info ---
                const _SectionHeader(title: "Basic Information"),
                CustomTextField(
                  label: AppStrings.fullName,
                  controller: _nameController,
                  prefixIcon: Icons.person_outline,
                  validator: (val) => val?.isEmpty == true ? AppStrings.errRequired : null,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: AppStrings.emailAddress,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.email_outlined,
                  validator: (val) => !val!.contains('@') ? AppStrings.errEmail : null,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: AppStrings.phoneNumber,
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  prefixIcon: Icons.phone_android_outlined,
                  validator: (val) => val!.length != 10 ? AppStrings.errPhone : null,
                ),

                const SizedBox(height: 32),

                // --- Section 2: Professional Details ---
                const _SectionHeader(title: "Professional Details"),

                CustomTextField(
                  label: AppStrings.businessName,
                  controller: _businessNameController,
                  prefixIcon: Icons.business_outlined,
                  validator: (val) => val?.isEmpty == true ? AppStrings.errRequired : null,
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        label: "GST Number",
                        controller: _gstController,
                        validator: (val) {
                          if (val == null || val.isEmpty) return AppStrings.errRequired;
                          if (val.length < 11) return "Invalid GST";
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomTextField(
                        label: "Aadhaar (12)",
                        controller: _aadhaarController,
                        keyboardType: TextInputType.number,
                        isPassword: true,
                        validator: (val) => val?.length != 12 ? AppStrings.errAadhaar : null,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: CustomDropdownField<String>(
                        label: "Experience",
                        value: _selectedExperience,
                        items: _experienceOptions.map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 12)))).toList(),
                        onChanged: (val) => setState(() => _selectedExperience = val),
                        validator: (val) => val == null ? "Required" : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomDropdownField<String>(
                        label: "Specialization",
                        value: _selectedSpecialization,
                        items: _specializationOptions.map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 12)))).toList(),
                        onChanged: (val) => setState(() => _selectedSpecialization = val),
                        validator: (val) => val == null ? "Required" : null,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                CustomTextField(
                  label: AppStrings.serviceArea,
                  controller: _serviceAreaController,
                  prefixIcon: Icons.map_outlined,
                  validator: (val) => val?.isEmpty == true ? AppStrings.errRequired : null,
                ),

                const SizedBox(height: 32),

                // --- Section 3: Security ---
                const _SectionHeader(title: "Security"),
                CustomTextField(
                  label: AppStrings.password,
                  controller: _passwordController,
                  isPassword: true,
                  prefixIcon: Icons.lock_outline,
                  onChanged: (val) {
                    _updatePasswordStrength(val);
                    setState(() {});
                  },
                  validator: (val) {
                    if (val == null || val.isEmpty) return AppStrings.errRequired;
                    if (val.length < 8) return "Min 8 characters";
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: AppStrings.confirmPassword,
                  controller: _confirmPasswordController,
                  isPassword: true,
                  prefixIcon: Icons.lock_reset_outlined,
                  validator: (val) => val != _passwordController.text ? AppStrings.errPasswordMatch : null,
                ),

                const SizedBox(height: 24),

                // --- Agreements ---
                _CheckboxRow(
                  value: _acceptAgreement,
                  label: AppStrings.acceptBuilderAgreement,
                  onChanged: (v) => setState(() => _acceptAgreement = v ?? false),
                ),
                _CheckboxRow(
                  value: _hasInsurance,
                  label: AppStrings.hasLiabilityInsurance,
                  onChanged: (v) => setState(() => _hasInsurance = v ?? false),
                ),

                const SizedBox(height: 32),

                // --- Register Button ---
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: (_formKey.currentState?.validate() == true && _acceptAgreement && !isLoading)
                        ? _submit
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: builderColor,
                      disabledBackgroundColor: Colors.grey.shade300,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 2,
                      shadowColor: builderColor.withOpacity(0.3),
                    ),
                    child: isLoading
                        ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Text(
                      AppStrings.registerAsBuilder,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),
                Center(
                  child: GestureDetector(
                    onTap: () {},
                    child: RichText(
                      text: TextSpan(
                        text: AppStrings.alreadyRegistered,
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                        children: [
                          TextSpan(
                            text: AppStrings.signIn,
                            style: TextStyle(color: builderColor, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Text(title.toUpperCase(), style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.grey.shade500, letterSpacing: 1.0)),
          const SizedBox(width: 8),
          Expanded(child: Divider(color: Colors.grey.shade200)),
        ],
      ),
    );
  }
}

class _CheckboxRow extends StatelessWidget {
  final bool value;
  final String label;
  final ValueChanged<bool?> onChanged;
  const _CheckboxRow({required this.value, required this.label, required this.onChanged});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 24, width: 24, child: Checkbox(value: value, onChanged: onChanged, activeColor: const Color(0xFF1E293B), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)))),
          const SizedBox(width: 8),
          Expanded(child: Text(label, style: const TextStyle(fontSize: 13, color: Colors.black87, height: 1.4))),
        ],
      ),
    );
  }
}