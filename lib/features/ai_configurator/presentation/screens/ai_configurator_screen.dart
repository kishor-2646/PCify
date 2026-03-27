import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_strings.dart';

class AiConfiguratorScreen extends ConsumerStatefulWidget {
  const AiConfiguratorScreen({super.key});

  @override
  ConsumerState<AiConfiguratorScreen> createState() => _AiConfiguratorScreenState();
}

class _AiConfiguratorScreenState extends ConsumerState<AiConfiguratorScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  final int _totalSteps = 5; // Use, Performance, Display, Budget, Result

  // --- Step 1: Use Case ---
  String? _selectedUse;

  // --- Step 2: Performance ---
  double _fpsTarget = 60; // Gaming
  String _scrubbingQuality = "Smooth"; // Editing
  String _compileTime = "< 10s"; // Coding

  // --- Step 3: Display ---
  String _resolution = "1440p";
  bool _ultrawide = false;

  // --- Step 4: Budget ---
  double _budget = 100000;

  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      if (_currentStep == 0 && _selectedUse == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please select a primary use")));
        return;
      }
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _currentStep++);
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _currentStep--);
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color(0xFF0EA5E9);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _currentStep < 4 ? AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: _prevStep,
        ),
        title: Text(
          AppStrings.aiConfigTitle,
          style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ) : null, // Hide AppBar on Result
      body: SafeArea(
        child: Column(
          children: [
            if (_currentStep < 4) _buildStepper(primaryColor),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildStep1Use(primaryColor),
                  _buildStep2Performance(primaryColor),
                  _buildStep3Display(primaryColor),
                  _buildStep4Budget(primaryColor),
                  _buildStep5Result(primaryColor),
                ],
              ),
            ),
            if (_currentStep < 4)
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _nextStep,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(
                      _currentStep == 3 ? "Generate Build" : "Next",
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

  // --- UI Components ---

  Widget _buildStepper(Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      child: Row(
        children: List.generate(4, (index) {
          bool isActive = index <= _currentStep;
          return Expanded(
            child: Container(
              height: 4,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: isActive ? color : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }

  // STEP 1: Use Case
  Widget _buildStep1Use(Color color) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(AppStrings.stepUse, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text("What will be the primary use of this PC?", style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 32),

          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.1,
            children: [
              _buildUseCard(AppStrings.useGaming, Icons.sports_esports, color),
              _buildUseCard(AppStrings.useEditing, Icons.movie_creation_outlined, color),
              _buildUseCard(AppStrings.useCoding, Icons.code, color),
              _buildUseCard(AppStrings.useContent, Icons.camera_alt_outlined, color),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUseCard(String title, IconData icon, Color color) {
    bool isSelected = _selectedUse == title;
    return GestureDetector(
      onTap: () => setState(() => _selectedUse = title),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? color : Colors.grey.shade200, width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: isSelected ? color : Colors.grey),
            const SizedBox(height: 12),
            Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: isSelected ? color : Colors.black87)),
          ],
        ),
      ),
    );
  }

  // STEP 2: Performance
  Widget _buildStep2Performance(Color color) {
    String title = AppStrings.perfFps;
    Widget content;

    if (_selectedUse == AppStrings.useGaming) {
      title = "Target FPS (Gaming)";
      content = Column(
        children: [
          Text("${_fpsTarget.round()} FPS", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: color)),
          Slider(
            value: _fpsTarget,
            min: 60, max: 240,
            divisions: 6,
            activeColor: color,
            label: "${_fpsTarget.round()} FPS",
            onChanged: (val) => setState(() => _fpsTarget = val),
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text("60 FPS"), Text("240+ FPS")],
          )
        ],
      );
    } else if (_selectedUse == AppStrings.useEditing) {
      title = AppStrings.perfScrubbing;
      content = Column(
        children: ["Smooth (1080p)", "Very Smooth (4K)", "Real-time (8K)"].map((e) {
          return RadioListTile(
            title: Text(e),
            value: e,
            groupValue: _scrubbingQuality,
            onChanged: (val) => setState(() => _scrubbingQuality = val as String),
            activeColor: color,
          );
        }).toList(),
      );
    } else {
      title = "General Speed";
      content = const Center(child: Text("We'll optimize for multitasking & speed."));
    }

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppStrings.stepPerf, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text("Define your performance expectations for $_selectedUse.", style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 40),
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 20),
          content,
        ],
      ),
    );
  }

  // STEP 3: Display
  Widget _buildStep3Display(Color color) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppStrings.stepDisplay, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 32),
          const Text("Monitor Resolution", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            children: [AppStrings.res1080, AppStrings.res1440, AppStrings.res4k].map((res) {
              return ChoiceChip(
                label: Text(res),
                selected: _resolution == res,
                onSelected: (val) => setState(() => _resolution = res),
                selectedColor: color,
                labelStyle: TextStyle(color: _resolution == res ? Colors.white : Colors.black87),
              );
            }).toList(),
          ),
          const SizedBox(height: 32),
          SwitchListTile(
            title: const Text(AppStrings.ultrawide, style: TextStyle(fontWeight: FontWeight.w600)),
            value: _ultrawide,
            activeColor: color,
            onChanged: (val) => setState(() => _ultrawide = val),
            contentPadding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  // STEP 4: Budget
  Widget _buildStep4Budget(Color color) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppStrings.stepBudget, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 40),
          Center(
            child: Text("₹${_budget.round()}", style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: color)),
          ),
          const SizedBox(height: 20),
          Slider(
            value: _budget,
            min: 30000, max: 500000,
            divisions: 47,
            activeColor: color,
            onChanged: (val) => setState(() => _budget = val),
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text("₹30k"), Text("₹5L+")],
          ),
        ],
      ),
    );
  }

  // STEP 5: Result
  Widget _buildStep5Result(Color color) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
              const Spacer(),
              const Icon(Icons.auto_awesome, color: Colors.amber),
              const SizedBox(width: 8),
              const Text("AI Recommendation", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const Spacer(),
              const SizedBox(width: 48), // Balance
            ],
          ),
          const SizedBox(height: 20),

          // Spec Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Ultimate 1440p Gaming Rig", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 24),
                _buildSpecRow("CPU", "Intel Core i7-13700K"),
                _buildSpecRow("GPU", "NVIDIA RTX 4070 Ti"),
                _buildSpecRow("RAM", "32GB DDR5-6000MHz"),
                _buildSpecRow("Storage", "1TB Gen4 NVMe SSD"),
                _buildSpecRow("PSU", "850W 80+ Gold"),
                const Divider(color: Colors.grey, height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Est. Cost", style: TextStyle(color: Colors.grey, fontSize: 14)),
                    Text("~ ₹1,85,000", style: TextStyle(color: color, fontSize: 24, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Performance Est
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(12)),
            child: Row(
              children: [
                const Icon(Icons.speed, color: Colors.green),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppStrings.estPerformance, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                      Text("165+ FPS @ 1440p High Settings", style: TextStyle(fontSize: 13)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Actions
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(backgroundColor: color, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              child: Text(AppStrings.findBuilderForBuild, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(side: BorderSide(color: color), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              child: Text(AppStrings.customizeBuild, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          SizedBox(width: 60, child: Text(label, style: TextStyle(color: Colors.grey.shade500, fontSize: 13))),
          Expanded(child: Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15))),
          const Icon(Icons.info_outline, color: Colors.grey, size: 16),
        ],
      ),
    );
  }
}