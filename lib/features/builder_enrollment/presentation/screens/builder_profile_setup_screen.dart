import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pcify/features/dashboard_builder/presentation/screens/builder_dashboard_screen.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../shared/widgets/inputs/custom_text_field.dart';
import '../../../../shared/widgets/inputs/custom_dropdown_field.dart';

class BuilderProfileSetupScreen extends ConsumerStatefulWidget {
  const BuilderProfileSetupScreen({super.key});

  @override
  ConsumerState<BuilderProfileSetupScreen> createState() => _BuilderProfileSetupScreenState();
}

class _BuilderProfileSetupScreenState extends ConsumerState<BuilderProfileSetupScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  final int _totalSteps = 3;

  // --- Step 1 Controllers ---
  final _bioController = TextEditingController();
  final _websiteController = TextEditingController();
  final _youtubeController = TextEditingController();
  final _instaController = TextEditingController();
  bool _hasPhoto = false; // Mock check for photo

  // --- Step 2 State ---
  final Map<String, bool> _specializations = {
    'Gaming PCs': false,
    'Editing Workstations': false,
    'Coding Machines': false,
    'Budget Builds': false,
    'Custom Modifications': false,
    'Overclocking': false,
    'Silent PCs': false,
    'RGB Builds': false,
  };
  final _awardsController = TextEditingController();
  // Mock list of uploaded files
  final List<String> _uploadedCertificates = [];

  // --- Step 3 Controllers ---
  final _consultationRateController = TextEditingController();
  final _budgetBuildCostController = TextEditingController();
  final _midBuildCostController = TextEditingController();
  final _highBuildCostController = TextEditingController();
  String? _selectedResponseTime;
  final List<String> _responseTimes = ['< 1 Hour', '1-4 Hours', '4-8 Hours', '1-2 Days'];

  @override
  void dispose() {
    _bioController.dispose();
    _websiteController.dispose();
    _youtubeController.dispose();
    _instaController.dispose();
    _awardsController.dispose();
    _consultationRateController.dispose();
    _budgetBuildCostController.dispose();
    _midBuildCostController.dispose();
    _highBuildCostController.dispose();
    super.dispose();
  }

  // --- Navigation Logic ---
  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      // Validate current step before moving
      if (_currentStep == 0 && !_hasPhoto) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please upload a profile photo")));
        return;
      }
      _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
      setState(() => _currentStep++);
    } else {
      _completeSetup();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
      setState(() => _currentStep--);
    }
  }

  void _completeSetup() {
    // Navigate to Builder Dashboard
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Profile Setup Complete!")));
    // NAVIGATE TO BUILDER DASHBOARD
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const BuilderDashboardScreen()),
            (route) => false // Remove back stack
    );
  }

  @override
  Widget build(BuildContext context) {
    final builderColor = const Color(0xFF1E293B);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          AppStrings.builderProfileSetup,
          style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        leading: _currentStep > 0
            ? IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: _previousStep,
        )
            : null,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // --- Custom Stepper Indicator ---
            _buildStepper(builderColor),

            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(), // Disable swipe
                children: [
                  _buildStep1BasicInfo(builderColor),
                  _buildStep2Specs(builderColor),
                  _buildStep3Pricing(builderColor),
                ],
              ),
            ),

            // --- Navigation Buttons ---
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _nextStep,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: builderColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(
                    _currentStep == _totalSteps - 1 ? AppStrings.completeSetup : "Next",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Widgets: Stepper ---
  Widget _buildStepper(Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          _buildStepDot(0, "Basic", color),
          _buildStepLine(0, color),
          _buildStepDot(1, "Skills", color),
          _buildStepLine(1, color),
          _buildStepDot(2, "Pricing", color),
        ],
      ),
    );
  }

  Widget _buildStepDot(int index, String label, Color color) {
    bool isActive = _currentStep >= index;
    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: 32,
          width: 32,
          decoration: BoxDecoration(
            color: isActive ? color : Colors.grey.shade200,
            shape: BoxShape.circle,
            border: Border.all(color: isActive ? color : Colors.grey.shade300),
          ),
          child: Center(
            child: Text(
              "${index + 1}",
              style: TextStyle(
                color: isActive ? Colors.white : Colors.grey.shade600,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: isActive ? color : Colors.grey.shade500,
            fontWeight: FontWeight.w600,
          ),
        )
      ],
    );
  }

  Widget _buildStepLine(int index, Color color) {
    bool isActive = _currentStep > index;
    return Expanded(
      child: Container(
        height: 2,
        color: isActive ? color : Colors.grey.shade200,
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 14), // Align with dot center
      ),
    );
  }

  // --- Widgets: Steps ---

  Widget _buildStep1BasicInfo(Color color) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Center(
            child: GestureDetector(
              onTap: () {
                // Mock Image Picker
                setState(() => _hasPhoto = true);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Photo Selected (Mock)")));
              },
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey.shade100,
                    backgroundImage: _hasPhoto ? const NetworkImage('https://i.pravatar.cc/300') : null, // Mock URL
                    child: !_hasPhoto
                        ? Icon(Icons.person, size: 60, color: Colors.grey.shade300)
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                      child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                    ),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Center(child: Text("Tap to upload photo", style: TextStyle(fontSize: 12, color: Colors.grey))),

          const SizedBox(height: 30),

          // Bio Field (Customizing CustomTextField for multiline)
          TextFormField(
            controller: _bioController,
            maxLines: 4,
            maxLength: 200,
            decoration: InputDecoration(
              labelText: AppStrings.bio,
              hintText: AppStrings.bioHint,
              alignLabelWithHint: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),

          const SizedBox(height: 20),

          CustomTextField(label: AppStrings.websiteLink, controller: _websiteController, prefixIcon: Icons.language),
          const SizedBox(height: 16),
          CustomTextField(label: AppStrings.youtubeLink, controller: _youtubeController, prefixIcon: Icons.video_library_outlined),
          const SizedBox(height: 16),
          CustomTextField(label: AppStrings.instagramLink, controller: _instaController, prefixIcon: Icons.camera_alt_outlined),
        ],
      ),
    );
  }

  Widget _buildStep2Specs(Color color) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const Text(AppStrings.selectSpecializations, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 10),

          ..._specializations.keys.map((key) {
            return CheckboxListTile(
              title: Text(key, style: const TextStyle(fontSize: 14)),
              value: _specializations[key],
              activeColor: color,
              dense: true,
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              onChanged: (val) => setState(() => _specializations[key] = val!),
            );
          }),

          const SizedBox(height: 24),
          const Text(AppStrings.certifications, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),

          // Upload Box
          GestureDetector(
            onTap: () {
              setState(() => _uploadedCertificates.add("NVIDIA_Cert_2024.pdf"));
            },
            child: Container(
              height: 100,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400, style: BorderStyle.none),
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: CustomPaint(
                painter: _DottedBorderPainter(),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.cloud_upload_outlined, color: color, size: 30),
                      const SizedBox(height: 8),
                      Text(AppStrings.uploadCert, style: TextStyle(color: color, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Uploaded List
          if (_uploadedCertificates.isNotEmpty) ...[
            const SizedBox(height: 12),
            ..._uploadedCertificates.map((cert) => ListTile(
              leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
              title: Text(cert, style: const TextStyle(fontSize: 13)),
              trailing: IconButton(
                icon: const Icon(Icons.close, size: 18),
                onPressed: () => setState(() => _uploadedCertificates.remove(cert)),
              ),
              dense: true,
              contentPadding: EdgeInsets.zero,
            )),
          ],

          const SizedBox(height: 24),
          CustomTextField(label: AppStrings.awards, controller: _awardsController, prefixIcon: Icons.emoji_events_outlined),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildStep3Pricing(Color color) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const Text("Set Your Rates", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const Text("Be competitive to attract more customers.", style: TextStyle(color: Colors.grey, fontSize: 13)),
          const SizedBox(height: 24),

          CustomTextField(
            label: AppStrings.consultationRate,
            controller: _consultationRateController,
            keyboardType: TextInputType.number,
            prefixIcon: Icons.currency_rupee,
          ),
          const SizedBox(height: 20),

          CustomTextField(
            label: AppStrings.assemblyCostBudget,
            controller: _budgetBuildCostController,
            keyboardType: TextInputType.number,
            prefixIcon: Icons.build_circle_outlined,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: AppStrings.assemblyCostMid,
            controller: _midBuildCostController,
            keyboardType: TextInputType.number,
            prefixIcon: Icons.build_circle_outlined,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: AppStrings.assemblyCostHigh,
            controller: _highBuildCostController,
            keyboardType: TextInputType.number,
            prefixIcon: Icons.build_circle_outlined,
          ),

          const SizedBox(height: 20),

          CustomDropdownField<String>(
            label: AppStrings.responseTime,
            value: _selectedResponseTime,
            items: _responseTimes.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            onChanged: (val) => setState(() => _selectedResponseTime = val),
            prefixIcon: Icons.timer_outlined,
          ),

          const SizedBox(height: 24),
          const Text("Service Areas", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            width: double.infinity,
            decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(8)),
            child: const Text("Bangalore, Mysore (Confirmed from Sign Up)", style: TextStyle(color: Colors.grey)),
          ),
        ],
      ),
    );
  }
}

// Simple Painter for Dotted Border
class _DottedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade400
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final path = Path();
    const dashWidth = 5.0;
    const dashSpace = 5.0;

    // Draw Top
    double startX = 0;
    while (startX < size.width) {
      path.moveTo(startX, 0);
      path.lineTo(startX + dashWidth, 0);
      startX += dashWidth + dashSpace;
    }
    // (Similar logic for other sides omitted for brevity, simplified to a Rect for MVP)
    // Actually, let's just draw a rounded rect with dashes
    var rrect = RRect.fromRectAndRadius(Rect.fromLTWH(0,0,size.width,size.height), const Radius.circular(12));
    // Since implementing full dashed path for RRect manually is complex in raw Paint,
    // for MVP we usually use a library, but here I'll just draw a solid light border to avoid errors
    // or just leave it blank as the Container color serves the purpose.
    canvas.drawRRect(rrect, paint..style = PaintingStyle.stroke);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}