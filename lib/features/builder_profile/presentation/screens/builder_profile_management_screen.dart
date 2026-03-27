import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../shared/widgets/inputs/custom_text_field.dart';
import '../../../../shared/widgets/inputs/custom_dropdown_field.dart';
import '../controllers/builder_controller.dart';

class BuilderProfileManagementScreen extends ConsumerStatefulWidget {
  const BuilderProfileManagementScreen({super.key});

  @override
  ConsumerState<BuilderProfileManagementScreen> createState() => _BuilderProfileManagementScreenState();
}

class _BuilderProfileManagementScreenState extends ConsumerState<BuilderProfileManagementScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // --- Controllers (Basic) ---
  late TextEditingController _bioController;
  late TextEditingController _yearsController;
  late TextEditingController _youtubeController;
  late TextEditingController _instaController;
  late TextEditingController _serviceAreaController;

  // --- Controllers (Pricing) ---
  late TextEditingController _consultationController;
  late TextEditingController _budgetBuildController;
  late TextEditingController _midBuildController;
  late TextEditingController _highBuildController;

  // --- State (Availability) ---
  bool _autoAccept = true;
  String? _responseTime = "< 1 Hour";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);

    // Initialize Basic
    _bioController = TextEditingController();
    _yearsController = TextEditingController();
    _youtubeController = TextEditingController();
    _instaController = TextEditingController();
    _serviceAreaController = TextEditingController();

    // Initialize Pricing
    _consultationController = TextEditingController(text: "1500");
    _budgetBuildController = TextEditingController(text: "3000");
    _midBuildController = TextEditingController(text: "7000");
    _highBuildController = TextEditingController(text: "15000");
  }

  @override
  void dispose() {
    _tabController.dispose();
    _bioController.dispose();
    _yearsController.dispose();
    _youtubeController.dispose();
    _instaController.dispose();
    _serviceAreaController.dispose();
    _consultationController.dispose();
    _budgetBuildController.dispose();
    _midBuildController.dispose();
    _highBuildController.dispose();
    super.dispose();
  }

  // --- SAVE LOGIC ---
  Future<void> _saveChanges() async {
    final pricingData = {
      'consultationRate': _consultationController.text.trim(),
      'assemblyBudget': _budgetBuildController.text.trim(),
      'assemblyMid': _midBuildController.text.trim(),
      'assemblyHigh': _highBuildController.text.trim(),
    };

    final availabilityData = {
      'autoAccept': _autoAccept,
      'responseTime': _responseTime,
    };

    await ref.read(builderControllerProvider.notifier).updateProfile(
      bio: _bioController.text.trim(),
      yearsExperience: _yearsController.text.trim(),
      serviceArea: _serviceAreaController.text.trim(),
      youtube: _youtubeController.text.trim(),
      instagram: _instaController.text.trim(),
      pricing: pricingData,
      availability: availabilityData,
    );

    final state = ref.read(builderControllerProvider);
    if (state.hasError) {
      if(mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${state.error}')));
    } else {
      if(mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Profile Updated Successfully!")));
    }
  }

  // --- ADD PORTFOLIO DIALOG ---
  void _showAddPortfolioDialog() {
    final nameCtrl = TextEditingController();
    final costCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    XFile? selectedImage;
    final ImagePicker picker = ImagePicker();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text("Add New Build"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                        if (image != null) {
                          setDialogState(() {
                            selectedImage = image;
                          });
                        }
                      },
                      child: Container(
                        height: 150,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(12),
                          image: selectedImage != null
                              ? DecorationImage(
                              image: FileImage(File(selectedImage!.path)),
                              fit: BoxFit.cover
                          )
                              : null,
                        ),
                        child: selectedImage == null
                            ? const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_a_photo, size: 40, color: Colors.grey),
                            SizedBox(height: 8),
                            Text("Tap to upload photo", style: TextStyle(color: Colors.grey)),
                          ],
                        )
                            : null,
                      ),
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(label: "Build Name", controller: nameCtrl),
                    const SizedBox(height: 12),
                    CustomTextField(label: "Cost (Approx)", controller: costCtrl),
                    const SizedBox(height: 12),
                    TextField(
                      controller: descCtrl,
                      maxLines: 3,
                      decoration: const InputDecoration(labelText: "Description", border: OutlineInputBorder()),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
                ElevatedButton(
                  onPressed: () async {
                    if (nameCtrl.text.isNotEmpty && costCtrl.text.isNotEmpty) {
                      // Use picked image path or fallback placeholder
                      String imageUrl = selectedImage != null
                          ? selectedImage!.path
                          : 'https://images.unsplash.com/photo-1587202372775-e229f172b9d7?auto=format&fit=crop&q=80';

                      await ref.read(builderControllerProvider.notifier).addPortfolioItem(
                        name: nameCtrl.text,
                        description: descCtrl.text,
                        cost: costCtrl.text,
                        imageUrl: imageUrl,
                      );
                      if(mounted) Navigator.pop(context);
                    }
                  },
                  child: const Text("Add"),
                ),
              ],
            );
          }
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final builderColor = const Color(0xFF1E293B);
    final profileAsync = ref.watch(builderProfileProvider);

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
          AppStrings.editBuilderProfile,
          style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: builderColor,
          unselectedLabelColor: Colors.grey,
          indicatorColor: builderColor,
          indicatorWeight: 3,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          tabs: [
            Tab(text: AppStrings.tabBasic),
            Tab(text: AppStrings.tabPortfolio),
            Tab(text: AppStrings.tabCerts),
            Tab(text: AppStrings.tabPricing),
            Tab(text: AppStrings.tabAvailability),
          ],
        ),
      ),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error loading profile: $err')),
        data: (profileData) {
          if (profileData != null) {
            if (_bioController.text.isEmpty) _bioController.text = profileData['bio'] ?? '';
            if (_yearsController.text.isEmpty) _yearsController.text = profileData['yearsExperience'] ?? '';
            if (_serviceAreaController.text.isEmpty) _serviceAreaController.text = profileData['serviceArea'] ?? '';
            final socials = profileData['socialLinks'] as Map<String, dynamic>?;
            if (_youtubeController.text.isEmpty) _youtubeController.text = socials?['youtube'] ?? '';
            if (_instaController.text.isEmpty) _instaController.text = socials?['instagram'] ?? '';
            final pricing = profileData['pricing'] as Map<String, dynamic>?;
            if (pricing != null) {
              if (_consultationController.text == "1500") _consultationController.text = pricing['consultationRate'] ?? '1500';
              if (_budgetBuildController.text == "3000") _budgetBuildController.text = pricing['assemblyBudget'] ?? '3000';
              if (_midBuildController.text == "7000") _midBuildController.text = pricing['assemblyMid'] ?? '7000';
              if (_highBuildController.text == "15000") _highBuildController.text = pricing['assemblyHigh'] ?? '15000';
            }
          }

          return TabBarView(
            controller: _tabController,
            children: [
              _buildBasicInfoTab(builderColor, profileData),
              _buildPortfolioTab(builderColor), // Updated
              _buildCertificationsTab(builderColor),
              _buildPricingTab(builderColor),
              _buildAvailabilityTab(builderColor),
            ],
          );
        },
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Colors.grey.shade200))),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: _saveChanges,
            style: ElevatedButton.styleFrom(backgroundColor: builderColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            child: Consumer(
              builder: (context, ref, child) {
                final state = ref.watch(builderControllerProvider);
                return state.isLoading
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : Text(AppStrings.saveChanges, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white));
              },
            ),
          ),
        ),
      ),
    );
  }

  // --- TAB 1: Basic Info ---
  Widget _buildBasicInfoTab(Color color, Map<String, dynamic>? data) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            children: [
              const CircleAvatar(radius: 50, backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11')),
              Positioned(
                bottom: 0, right: 0,
                child: CircleAvatar(radius: 16, backgroundColor: color, child: const Icon(Icons.edit, size: 16, color: Colors.white)),
              )
            ],
          ),
          const SizedBox(height: 24),
          TextFormField(
            controller: _bioController,
            maxLines: 3,
            decoration: InputDecoration(
                labelText: AppStrings.bio,
                hintText: "Tell customers about your expertise...",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))
            ),
          ),
          const SizedBox(height: 16),
          CustomTextField(label: AppStrings.yearsExperience, controller: _yearsController, keyboardType: TextInputType.number),
          const SizedBox(height: 16),
          CustomTextField(label: AppStrings.youtubeLink, controller: _youtubeController, prefixIcon: Icons.video_library),
          const SizedBox(height: 16),
          CustomTextField(label: AppStrings.instagramLink, controller: _instaController, prefixIcon: Icons.camera_alt),
          const SizedBox(height: 16),
          CustomTextField(label: AppStrings.serviceArea, controller: _serviceAreaController, prefixIcon: Icons.map),
        ],
      ),
    );
  }

  // --- UPDATED TAB 2: Portfolio ---
  Widget _buildPortfolioTab(Color color) {
    // Watch the portfolio stream
    final portfolioAsync = ref.watch(builderPortfolioProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          OutlinedButton.icon(
            onPressed: _showAddPortfolioDialog, // Open Dialog
            icon: const Icon(Icons.add, color: Colors.black87),
            label: Text(AppStrings.addBuild, style: const TextStyle(color: Colors.black87)),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              side: BorderSide(color: Colors.grey.shade400),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 24),

          portfolioAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Text("Error: $err"),
            data: (portfolio) {
              if (portfolio.isEmpty) return const Text("No builds added yet.");

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.8,
                ),
                itemCount: portfolio.length,
                itemBuilder: (context, index) {
                  final item = portfolio[index];
                  final imagePath = item['image'] ?? '';
                  final isNetwork = imagePath.startsWith('http');

                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                            child: isNetwork
                                ? Image.network(
                              imagePath,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (_,__,___) => Container(color: Colors.grey.shade200, child: const Icon(Icons.image)),
                            )
                                : Image.file(
                              File(imagePath),
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (_,__,___) => Container(color: Colors.grey.shade200, child: const Icon(Icons.image)),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item['name'] ?? 'Untitled', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                              Text(item['cost'] ?? '', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  // Delete Button
                                  GestureDetector(
                                    onTap: () => ref.read(builderControllerProvider.notifier).deletePortfolioItem(item['id']),
                                    child: const Icon(Icons.delete, size: 18, color: Colors.red),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  // --- TAB 3: Certifications ---
  Widget _buildCertificationsTab(Color color) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.upload_file, color: Colors.black87),
            label: Text(AppStrings.uploadCertificate, style: const TextStyle(color: Colors.black87)),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              side: BorderSide(color: Colors.grey.shade400),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 24),
          ListTile(
            leading: const Icon(Icons.verified_user, color: Colors.green),
            title: const Text("NVIDIA Certified Builder"),
            subtitle: const Text("Uploaded: Oct 12, 2024"),
            trailing: IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () {}),
            shape: RoundedRectangleBorder(side: BorderSide(color: Colors.grey.shade200), borderRadius: BorderRadius.circular(8)),
          ),
        ],
      ),
    );
  }

  // --- TAB 4: Pricing ---
  Widget _buildPricingTab(Color color) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          CustomTextField(label: AppStrings.consultationRate, controller: _consultationController, prefixIcon: Icons.currency_rupee, keyboardType: TextInputType.number),
          const SizedBox(height: 16),
          CustomTextField(label: AppStrings.assemblyCostBudget, controller: _budgetBuildController, prefixIcon: Icons.build_circle, keyboardType: TextInputType.number),
          const SizedBox(height: 16),
          CustomTextField(label: AppStrings.assemblyCostMid, controller: _midBuildController, prefixIcon: Icons.build_circle, keyboardType: TextInputType.number),
          const SizedBox(height: 16),
          CustomTextField(label: AppStrings.assemblyCostHigh, controller: _highBuildController, prefixIcon: Icons.build_circle, keyboardType: TextInputType.number),
        ],
      ),
    );
  }

  // --- TAB 5: Availability ---
  Widget _buildAvailabilityTab(Color color) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppStrings.unavailableDays, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          Container(
            height: 300,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
            child: CalendarDatePicker(
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365)),
              onDateChanged: (date) {},
            ),
          ),
          const SizedBox(height: 24),
          SwitchListTile(
            title: Text(AppStrings.autoAccept, style: const TextStyle(fontWeight: FontWeight.w600)),
            value: _autoAccept,
            activeColor: color,
            onChanged: (val) => setState(() => _autoAccept = val),
            contentPadding: EdgeInsets.zero,
          ),
          const SizedBox(height: 16),
          CustomDropdownField<String>(
            label: AppStrings.responseTime,
            value: _responseTime,
            items: ["< 1 Hour", "1-4 Hours", "1 Day"].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            onChanged: (val) => setState(() => _responseTime = val),
          ),
        ],
      ),
    );
  }
}