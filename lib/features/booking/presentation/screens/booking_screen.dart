import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../shared/widgets/inputs/custom_text_field.dart';
import '../../../../shared/widgets/inputs/custom_dropdown_field.dart';
import '../../../home_customer/presentation/screens/customer_home_screen.dart';

class BookingScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> builderData; // To show builder info in summary

  const BookingScreen({super.key, required this.builderData});

  @override
  ConsumerState<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends ConsumerState<BookingScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  final int _totalSteps = 5; // 4 Steps + Success

  // --- Step 1: Service Type ---
  String _serviceType = "Consultation Only";

  // --- Step 2: Date & Time ---
  DateTime _selectedDate = DateTime.now();
  String _selectedTimeSlot = "10:00 AM";
  final List<String> _timeSlots = [
    "10:00 AM", "10:30 AM", "11:00 AM", "11:30 AM",
    "02:00 PM", "02:30 PM", "03:00 PM", "04:00 PM"
  ];

  // --- Step 3: Details ---
  String? _primaryUse;
  final _budgetController = TextEditingController();
  final _requirementsController = TextEditingController();

  // --- Step 4: Payment ---
  String _paymentMethod = "UPI";
  bool _agreeTerms = false;

  @override
  void dispose() {
    _budgetController.dispose();
    _requirementsController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      // Basic validation can go here
      if (_currentStep == 3 && !_agreeTerms) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please agree to terms")));
        return;
      }

      _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut
      );
      setState(() => _currentStep++);
    } else {
      // Navigate Home
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const CustomerHomeScreen()),
            (route) => false,
      );
    }
  }

  void _prevStep() {
    if (_currentStep > 0 && _currentStep < 4) { // Don't allow back from Success
      _pageController.previousPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut
      );
      setState(() => _currentStep--);
    } else if (_currentStep == 0) {
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
            AppStrings.bookingTitle,
            style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)
        ),
        centerTitle: true,
      ) : null, // Hide AppBar on Success Screen
      body: SafeArea(
        child: Column(
          children: [
            if (_currentStep < 4) _buildStepper(primaryColor),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildStep1Service(primaryColor),
                  _buildStep2DateTime(primaryColor),
                  _buildStep3Details(primaryColor),
                  _buildStep4Payment(primaryColor),
                  _buildStep5Success(primaryColor),
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
                      _currentStep == 3 ? AppStrings.payAndBook : "Next",
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

  // --- Widget Components ---

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

  // STEP 1: Service Selection
  Widget _buildStep1Service(Color color) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppStrings.selectServiceType, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          _buildServiceOption(AppStrings.consultationOnly, "Expert advice on parts & build plan", color),
          const SizedBox(height: 16),
          _buildServiceOption(AppStrings.fullAssembly, "Complete PC assembly & setup", color),
          const SizedBox(height: 16),
          _buildServiceOption(AppStrings.hybridService, "Consultation + Full Assembly deal", color),
        ],
      ),
    );
  }

  Widget _buildServiceOption(String title, String subtitle, Color color) {
    bool isSelected = _serviceType == title;
    return InkWell(
      onTap: () => setState(() => _serviceType = title),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: isSelected ? color : Colors.grey.shade300, width: isSelected ? 2 : 1),
          borderRadius: BorderRadius.circular(12),
          color: isSelected ? color.withOpacity(0.05) : Colors.white,
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? color : Colors.grey,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isSelected ? color : Colors.black87)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // STEP 2: Date & Time
  Widget _buildStep2DateTime(Color color) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppStrings.selectDateTime, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          // Mock Calendar
          Container(
            height: 300,
            decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(12)),
            child: CalendarDatePicker(
              initialDate: _selectedDate,
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 30)),
              onDateChanged: (date) => setState(() => _selectedDate = date),
            ),
          ),
          const SizedBox(height: 24),
          const Text("Available Slots", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: _timeSlots.map((slot) {
              bool isSelected = _selectedTimeSlot == slot;
              return ChoiceChip(
                label: Text(slot),
                selected: isSelected,
                onSelected: (val) => setState(() => _selectedTimeSlot = slot),
                selectedColor: color,
                labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black87),
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(color: Colors.grey.shade300)),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // STEP 3: Details
  Widget _buildStep3Details(Color color) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppStrings.addDetails, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          CustomDropdownField<String>(
            label: AppStrings.primaryUse,
            value: _primaryUse,
            items: ["Gaming", "Editing", "Coding", "Mixed"].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            onChanged: (val) => setState(() => _primaryUse = val),
            prefixIcon: Icons.computer,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: AppStrings.estimatedBudget,
            controller: _budgetController,
            prefixIcon: Icons.currency_rupee,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _requirementsController,
            maxLines: 4,
            decoration: InputDecoration(
              labelText: AppStrings.buildRequirements,
              hintText: "e.g., RTX 4090, i9-13900K...",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              alignLabelWithHint: true,
            ),
          ),
        ],
      ),
    );
  }

  // STEP 4: Payment
  Widget _buildStep4Payment(Color color) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppStrings.confirmPay, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),

          // Order Summary Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppStrings.orderSummary, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const Divider(height: 24),
                _buildSummaryRow("Service", _serviceType),
                _buildSummaryRow("Date", "${_selectedDate.day}/${_selectedDate.month} - $_selectedTimeSlot"),
                _buildSummaryRow("Builder", widget.builderData['name'] ?? 'Expert Builder'),
                const Divider(height: 24),
                _buildSummaryRow("Consultation Fee", "₹1500"),
                _buildSummaryRow("Tax (18% GST)", "₹270"),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Total", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text("₹1770", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: color)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          Text(AppStrings.paymentMethod, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          _buildPaymentOption("UPI (Google Pay/PhonePe)", "UPI", color),
          _buildPaymentOption("Credit / Debit Card", "Card", color),

          const SizedBox(height: 24),
          Row(
            children: [
              Checkbox(
                value: _agreeTerms,
                onChanged: (val) => setState(() => _agreeTerms = val!),
                activeColor: color,
              ),
              const Expanded(child: Text("I agree to booking terms & conditions", style: TextStyle(fontSize: 13))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(String label, String value, Color color) {
    return RadioListTile<String>(
      title: Text(label, style: const TextStyle(fontSize: 14)),
      value: value,
      groupValue: _paymentMethod,
      onChanged: (val) => setState(() => _paymentMethod = val!),
      activeColor: color,
      contentPadding: EdgeInsets.zero,
      dense: true,
    );
  }

  // STEP 5: Success
  Widget _buildStep5Success(Color color) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: Colors.green.shade50, shape: BoxShape.circle),
            child: const Icon(Icons.check_circle, size: 64, color: Colors.green),
          ),
          const SizedBox(height: 24),
          Text(AppStrings.bookingConfirmed, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          const Text(
            AppStrings.bookingSuccessMsg,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: OutlinedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const CustomerHomeScreen()),
                      (route) => false,
                );
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: color),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(AppStrings.goToHome, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
            ),
          ),
        ],
      ),
    );
  }
}