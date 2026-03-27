import 'package:flutter/material.dart';
import '../../../../core/constants/app_strings.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  // --- Filter States ---
  RangeValues _budgetRange = const RangeValues(500, 5000); // Hourly Rate Default
  bool _isHourly = true;

  final Map<String, bool> _specializations = {
    'Gaming': false,
    'Editing': false,
    'Coding': false,
    'Workstations': false,
    'Budget': false,
    'Custom': false,
  };

  String _experienceLevel = 'All'; // All, Junior, Senior, Expert
  double _rating = 0.0;
  double _distance = 10.0;
  String _availability = 'Available now';
  String _serviceType = 'Both'; // Consultation, Assembly, Both

  // Helper to switch mode safely
  void _toggleBudgetMode(bool isHourly) {
    setState(() {
      _isHourly = isHourly;
      // Reset range to safe defaults for the new mode to avoid assertion error
      if (_isHourly) {
        _budgetRange = const RangeValues(500, 5000);
      } else {
        _budgetRange = const RangeValues(2000, 20000);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color(0xFF0EA5E9);

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (_, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // --- Handle Bar ---
              Container(
                width: 40, height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
              ),

              // --- Header ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(AppStrings.filterTitle, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    TextButton(
                      onPressed: _resetFilters,
                      child: Text(AppStrings.resetFilters, style: TextStyle(color: Colors.red.shade400)),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),

              // --- Scrollable Content ---
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(24),
                  children: [
                    // 1. Budget Range
                    _buildSectionTitle(AppStrings.budgetRange),
                    const SizedBox(height: 8),
                    // Toggle Hourly vs Assembly
                    Row(
                      children: [
                        _buildTypeChip("Hourly", _isHourly, () => _toggleBudgetMode(true)),
                        const SizedBox(width: 12),
                        _buildTypeChip("Assembly", !_isHourly, () => _toggleBudgetMode(false)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    RangeSlider(
                      values: _budgetRange,
                      min: _isHourly ? 500 : 2000,
                      max: _isHourly ? 10000 : 50000,
                      divisions: 20,
                      activeColor: primaryColor,
                      labels: RangeLabels(
                          "₹${_budgetRange.start.round()}",
                          "₹${_budgetRange.end.round()}+"
                      ),
                      onChanged: (values) => setState(() => _budgetRange = values),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("₹${_budgetRange.start.round()}", style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text("₹${_budgetRange.end.round()}+", style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),

                    const SizedBox(height: 24),
                    const Divider(),
                    const SizedBox(height: 16),

                    // 2. Specialization
                    _buildSectionTitle(AppStrings.specializationsLabel),
                    Wrap(
                      spacing: 8,
                      children: _specializations.keys.map((key) {
                        return FilterChip(
                          label: Text(key),
                          selected: _specializations[key]!,
                          onSelected: (val) => setState(() => _specializations[key] = val),
                          selectedColor: primaryColor.withOpacity(0.15),
                          checkmarkColor: primaryColor,
                          labelStyle: TextStyle(
                            color: _specializations[key]! ? primaryColor : Colors.black87,
                            fontWeight: _specializations[key]! ? FontWeight.bold : FontWeight.normal,
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 24),
                    const Divider(),
                    const SizedBox(height: 16),

                    // 3. Experience & Service Type (Row)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSectionTitle(AppStrings.experienceLevel),
                              _buildRadioTile("Junior (0-3y)", "Junior", _experienceLevel, (v) => setState(() => _experienceLevel = v!)),
                              _buildRadioTile("Senior (3-10y)", "Senior", _experienceLevel, (v) => setState(() => _experienceLevel = v!)),
                              _buildRadioTile("Expert (10+y)", "Expert", _experienceLevel, (v) => setState(() => _experienceLevel = v!)),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSectionTitle(AppStrings.serviceType),
                              _buildRadioTile("Consultation", "Consultation", _serviceType, (v) => setState(() => _serviceType = v!)),
                              _buildRadioTile("Assembly", "Assembly", _serviceType, (v) => setState(() => _serviceType = v!)),
                              _buildRadioTile("Both", "Both", _serviceType, (v) => setState(() => _serviceType = v!)),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),
                    const Divider(),
                    const SizedBox(height: 16),

                    // 4. Rating & Distance
                    _buildSectionTitle("${AppStrings.minRating}: ${_rating > 0 ? '$_rating★' : 'Any'}"),
                    Slider(
                      value: _rating,
                      min: 0, max: 5,
                      divisions: 10, // 0.5 steps
                      activeColor: Colors.amber,
                      label: "$_rating★",
                      onChanged: (val) => setState(() => _rating = val),
                    ),

                    const SizedBox(height: 12),

                    _buildSectionTitle("${AppStrings.distanceRadius}: ${_distance.round()} km"),
                    Slider(
                      value: _distance,
                      min: 1, max: 50,
                      activeColor: primaryColor,
                      label: "${_distance.round()} km",
                      onChanged: (val) => setState(() => _distance = val),
                    ),

                    const SizedBox(height: 12),
                    _buildSectionTitle(AppStrings.availability),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _availability,
                      items: ['Available now', 'This week', 'This month', 'Flexible']
                          .map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                      onChanged: (v) => setState(() => _availability = v!),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
                      ),
                    ),
                  ],
                ),
              ),

              // --- Footer Action ---
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: const Offset(0, -5))],
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Close sheet
                      // Pass back filter data in real app
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text("Apply Filters (24)", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _resetFilters() {
    setState(() {
      _budgetRange = const RangeValues(500, 5000);
      _isHourly = true; // IMPORTANT: Reset mode too to match the range
      _specializations.updateAll((key, value) => false);
      _experienceLevel = 'All';
      _rating = 0.0;
      _distance = 10.0;
    });
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87));
  }

  Widget _buildTypeChip(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0EA5E9) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? const Color(0xFF0EA5E9) : Colors.grey.shade300),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildRadioTile(String label, String value, String groupValue, ValueChanged<String?> onChanged) {
    return RadioListTile<String>(
      title: Text(label, style: const TextStyle(fontSize: 13)),
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
      contentPadding: EdgeInsets.zero,
      dense: true,
      visualDensity: VisualDensity.compact,
      activeColor: const Color(0xFF0EA5E9),
    );
  }
}