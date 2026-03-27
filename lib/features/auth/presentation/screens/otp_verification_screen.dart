import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../builder_enrollment/presentation/screens/builder_profile_setup_screen.dart';
import '../../../home_customer/presentation/screens/customer_home_screen.dart';

class OtpVerificationScreen extends ConsumerStatefulWidget {
  final String email;
  final bool isBuilder; // To determine next step navigation

  const OtpVerificationScreen({
    super.key,
    required this.email,
    required this.isBuilder,
  });

  @override
  ConsumerState<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends ConsumerState<OtpVerificationScreen> {
  // 6 Text Controllers for 6 digits
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  // Timer State
  Timer? _timer;
  int _start = 60;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var c in _controllers) { c.dispose(); }
    for (var f in _focusNodes) { f.dispose(); }
    super.dispose();
  }

  void _startTimer() {
    setState(() {
      _start = 60;
      _canResend = false;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() {
          _timer?.cancel();
          _canResend = true;
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  void _onDigitEntered(int index, String value) {
    if (value.isNotEmpty) {
      // Move to next field if available
      if (index < 5) {
        FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
      } else {
        // Last digit entered, hide keyboard
        FocusScope.of(context).unfocus();
      }
    } else {
      // Backspace logic: Move to previous field
      if (index > 0) {
        FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
      }
    }
    setState(() {}); // Rebuild to check button state
  }

  void _verify() {
    String otp = _controllers.map((e) => e.text).join();
    if (otp.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.errOtpIncomplete)),
      );
      return;
    }

    // --- MOCK VERIFICATION LOGIC ---
    debugPrint("Verifying OTP: $otp for ${widget.isBuilder ? 'Builder' : 'Customer'}");

    // Simulate Success & Navigate
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Email Verified Successfully!')),
    );

    if (widget.isBuilder) {
      // Navigate to Builder Profile Setup (Screen 1.4)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const BuilderProfileSetupScreen()), // Import this
      );
    } else {
      // Navigate to Customer Home (Screen 2.1)
      debugPrint("NAVIGATE: Screen 2.1 (Customer Home)");
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const CustomerHomeScreen()), // Import this
              (route) => false // Remove back stack so they can't go back to OTP/Login
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = widget.isBuilder ? const Color(0xFF1E293B) : const Color(0xFF0EA5E9);

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
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                AppStrings.verifyEmail,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),

              // Subheader with dynamic email
              RichText(
                text: TextSpan(
                  text: "${AppStrings.sentCodeTo} ",
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14, height: 1.5),
                  children: [
                    TextSpan(
                      text: widget.email,
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // --- 6 Digit OTP Input Row ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: 44,
                    height: 56,
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        counterText: "", // Hide character counter
                        contentPadding: EdgeInsets.zero,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: themeColor, width: 2),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                      ),
                      onChanged: (value) => _onDigitEntered(index, value),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 32),

              // Verify Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _verify,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 1,
                  ),
                  child: const Text(
                    AppStrings.verify,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Resend Logic
              Center(
                child: _canResend
                    ? TextButton(
                  onPressed: _startTimer,
                  child: Text(
                    AppStrings.resend,
                    style: TextStyle(color: themeColor, fontWeight: FontWeight.bold),
                  ),
                )
                    : RichText(
                  text: TextSpan(
                    text: "${AppStrings.resendIn} ",
                    style: TextStyle(color: Colors.grey.shade600),
                    children: [
                      TextSpan(
                        text: "00:${_start.toString().padLeft(2, '0')}",
                        style: TextStyle(color: themeColor, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(),

              // Alternative Option
              Center(
                child: TextButton(
                  onPressed: () {
                    // Logic to switch to phone verification
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Switching to Phone Verification...")),
                    );
                  },
                  child: const Text(
                    AppStrings.verifyWithPhone,
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}