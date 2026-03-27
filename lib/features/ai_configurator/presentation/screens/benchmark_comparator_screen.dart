import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../shared/widgets/inputs/custom_dropdown_field.dart';

class BenchmarkComparatorScreen extends ConsumerStatefulWidget {
  const BenchmarkComparatorScreen({super.key});

  @override
  ConsumerState<BenchmarkComparatorScreen> createState() => _BenchmarkComparatorScreenState();
}

class _BenchmarkComparatorScreenState extends ConsumerState<BenchmarkComparatorScreen> {
  // Config State
  String? _useCase = AppStrings.useGaming;
  String? _resolution = AppStrings.res1440;

  // Mock Build Data (In real app, select from saved builds)
  final Map<String, dynamic> _build1 = {
    'name': 'Current Build',
    'cpu': 'i5-13600K',
    'gpu': 'RTX 3070',
    'cost': 120000,
    'fps_cyberpunk': 65,
    'fps_pubg': 140,
    'score': 7.5,
  };

  final Map<String, dynamic> _build2 = {
    'name': 'Upgrade Plan',
    'cpu': 'i7-13700K',
    'gpu': 'RTX 4070 Ti',
    'cost': 185000,
    'fps_cyberpunk': 98, // +50%
    'fps_pubg': 210,     // +50%
    'score': 8.8,
  };

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color(0xFF0EA5E9);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          AppStrings.benchmarkTitle,
          style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // --- Controls ---
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: CustomDropdownField<String>(
                          label: "Use Case",
                          value: _useCase,
                          items: [AppStrings.useGaming, AppStrings.useEditing, AppStrings.useCoding]
                              .map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                          onChanged: (val) => setState(() => _useCase = val),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: CustomDropdownField<String>(
                          label: "Resolution",
                          value: _resolution,
                          items: [AppStrings.res1080, AppStrings.res1440, AppStrings.res4k]
                              .map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                          onChanged: (val) => setState(() => _resolution = val),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // --- Build Headers ---
            Row(
              children: [
                _buildBuildHeader(_build1, Colors.grey.shade700),
                const SizedBox(width: 12),
                _buildBuildHeader(_build2, primaryColor),
              ],
            ),

            const SizedBox(height: 24),

            // --- Performance Comparison ---
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("Gaming Performance", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ),
            const SizedBox(height: 16),

            _buildBenchmarkRow("Cyberpunk 2077", _build1['fps_cyberpunk'], _build2['fps_cyberpunk'], primaryColor),
            const SizedBox(height: 16),
            _buildBenchmarkRow("PUBG: Battlegrounds", _build1['fps_pubg'], _build2['fps_pubg'], primaryColor),

            const SizedBox(height: 32),

            // --- Cost & Value ---
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(AppStrings.costComparison, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("₹${_build1['cost']}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const Icon(Icons.arrow_forward, color: Colors.grey, size: 16),
                      Text("₹${_build2['cost']}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Difference: ", style: TextStyle(color: Colors.grey.shade600)),
                      Text(
                          "+₹${(_build2['cost'] - _build1['cost'])}",
                          style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // --- Recommendation ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.lightbulb, color: Colors.green),
                      SizedBox(width: 8),
                      Text(AppStrings.recommendation, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Build 2 offers 50% better performance for 54% more cost. It's a great future-proof choice for 1440p gaming.",
                    style: TextStyle(height: 1.4),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBuildHeader(Map<String, dynamic> build, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3), width: 2),
        ),
        child: Column(
          children: [
            Text(build['name'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: color)),
            const SizedBox(height: 8),
            Text(build['cpu'], style: const TextStyle(fontSize: 12)),
            Text(build['gpu'], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _buildBenchmarkRow(String title, int val1, int val2, Color color) {
    int maxVal = (val1 > val2 ? val1 : val2) + 50; // Dynamic scale
    double pct1 = val1 / maxVal;
    double pct2 = val2 / maxVal;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("$title ($_resolution)", style: const TextStyle(fontSize: 13, color: Colors.grey)),
        const SizedBox(height: 8),
        Stack(
          children: [
            // Bar 2 (Comparison)
            FractionallySizedBox(
              widthFactor: pct2,
              child: Container(
                height: 24,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 8),
                child: Text("$val2 FPS", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color)),
              ),
            ),
            // Bar 1 (Base)
            FractionallySizedBox(
              widthFactor: pct1,
              child: Container(
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4),
                ),
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 8),
                child: Text("$val1 FPS", style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}