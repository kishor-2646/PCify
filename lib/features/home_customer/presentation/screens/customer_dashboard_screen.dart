import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pcify/features/auth/presentation/screens/landing_screen.dart';
import '../../../../core/constants/app_strings.dart';
import '../widgets/builder_card.dart'; // Reuse Builder Card for Saved tab
import 'package:pcify/features/auth/presentation/controllers/auth_controller.dart';


class CustomerDashboardScreen extends ConsumerStatefulWidget {
  const CustomerDashboardScreen({super.key});

  @override
  ConsumerState<CustomerDashboardScreen> createState() => _CustomerDashboardScreenState();
}

class _CustomerDashboardScreenState extends ConsumerState<CustomerDashboardScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _handleLogout() async {
    // Call signOut from the AuthController
    await ref.read(authControllerProvider.notifier).signOut();

    // Check if widget is still mounted before using context
    if (mounted) {
      // Navigate to Landing Screen and clear the stack
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LandingScreen()),
            (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color(0xFF0EA5E9);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(AppStrings.dashboardTitle, style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        centerTitle: false,
        bottom: TabBar(
          controller: _tabController,
          labelColor: primaryColor,
          unselectedLabelColor: Colors.grey,
          indicatorColor: primaryColor,
          indicatorWeight: 3,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          tabs: [
            Tab(text: AppStrings.tabActive),
            Tab(text: AppStrings.tabHistory),
            Tab(text: AppStrings.tabSaved),
            Tab(text: AppStrings.tabAccount),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildActiveBookingsTab(primaryColor),
          _buildCompletedBookingsTab(primaryColor),
          _buildSavedBuildersTab(),
          _buildAccountSettingsTab(primaryColor),
        ],
      ),
    );
  }

  // --- TAB 1: Active Bookings ---
  Widget _buildActiveBookingsTab(Color color) {
    // Mock Data
    final bookings = [
      {
        'builder': 'Rahul Sharma',
        'image': 'https://i.pravatar.cc/150?img=11',
        'type': 'Consultation',
        'date': 'Nov 14, 2025 • 3:00 PM',
        'status': 'Confirmed',
        'statusColor': Colors.green,
      },
      {
        'builder': 'TechMods Studio',
        'image': 'https://i.pravatar.cc/150?img=5',
        'type': 'Full Assembly',
        'date': 'Nov 18, 2025 • 10:00 AM',
        'status': 'Awaiting Payment',
        'statusColor': Colors.orange,
      }
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final item = bookings[index];
        return _BookingCard(
          builderName: item['builder'].toString(),
          builderImage: item['image'].toString(),
          type: item['type'].toString(),
          date: item['date'].toString(),
          status: item['status'].toString(),
          statusColor: item['statusColor'] as Color,
          primaryColor: color,
          isActive: true,
        );
      },
    );
  }

  // --- TAB 2: Completed Bookings ---
  Widget _buildCompletedBookingsTab(Color color) {
    // Mock Data
    final bookings = [
      {
        'builder': 'Ankit Verma',
        'image': 'https://i.pravatar.cc/150?img=3',
        'type': 'Consultation',
        'date': 'Oct 20, 2025',
        'status': 'Completed',
        'statusColor': Colors.grey,
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final item = bookings[index];
        return _BookingCard(
          builderName: item['builder'].toString(),
          builderImage: item['image'].toString(),
          type: item['type'].toString(),
          date: item['date'].toString(),
          status: item['status'].toString(),
          statusColor: item['statusColor'] as Color,
          primaryColor: color,
          isActive: false,
        );
      },
    );
  }

  // --- TAB 3: Saved Builders ---
  Widget _buildSavedBuildersTab() {
    // Mock Data (Reusing structure suitable for BuilderCard)
    final savedBuilders = [
      {
        'name': 'Extreme Rigs',
        'image': 'https://i.pravatar.cc/150?img=8',
        'rating': 5.0,
        'builds': 12,
        'location': 'Koramangala',
        'distance': '1.2 km',
        'price': '₹5000+',
        'expert': true,
        'tags': ['Overclocking', 'Custom Loop'],
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: savedBuilders.length,
      itemBuilder: (context, index) {
        final builder = savedBuilders[index];
        return Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: SizedBox(
                width: double.infinity,
                child: BuilderCard(
                  name: builder['name'].toString(),
                  imageUrl: builder['image'].toString(),
                  rating: (builder['rating'] as num).toDouble(),
                  buildCount: builder['builds'] as int,
                  location: builder['location'].toString(),
                  distance: builder['distance'].toString(),
                  priceRange: builder['price'].toString(),
                  specializations: List<String>.from(builder['tags'] as List),
                  isExpert: builder['expert'] as bool,
                ),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.grey),
                onPressed: () {
                  // Remove logic
                },
              ),
            ),
          ],
        );
      },
    );
  }

  // --- TAB 4: Account Settings ---
  Widget _buildAccountSettingsTab(Color color) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Profile Header
        Row(
          children: [
            const CircleAvatar(radius: 30, backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=60')),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Alex Johnson", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text("alex.j@example.com", style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
              ],
            ),
            const Spacer(),
            TextButton(onPressed: () {}, child: Text("Edit", style: TextStyle(color: color))),
          ],
        ),
        const SizedBox(height: 24),

        _buildSettingsTile(Icons.person_outline, AppStrings.editProfile, onTap: () {}),
        _buildSettingsTile(Icons.credit_card, AppStrings.paymentMethods, onTap: () {}),
        _buildSettingsTile(Icons.notifications_outlined, AppStrings.notifications, hasSwitch: true),
        const Divider(height: 32),
        _buildSettingsTile(Icons.help_outline, AppStrings.support, onTap: () {}),
        _buildSettingsTile(Icons.privacy_tip_outlined, "Privacy & Terms", onTap: () {}),
        const Divider(height: 32),
        // Logout Button
        _buildSettingsTile(
          Icons.logout,
          AppStrings.logout,
          color: Colors.red,
          onTap: _handleLogout, // Connect Logout Logic
        ),
      ],
    );
  }

  Widget _buildSettingsTile(
      IconData icon,
      String title, {
        bool hasSwitch = false,
        Color? color,
        VoidCallback? onTap, // Added onTap callback
      }) {
    return ListTile(
      leading: Icon(icon, color: color ?? Colors.black87),
      title: Text(title, style: TextStyle(color: color ?? Colors.black87, fontWeight: FontWeight.w500)),
      trailing: hasSwitch
          ? Switch(value: true, activeColor: const Color(0xFF0EA5E9), onChanged: (val) {})
          : const Icon(Icons.chevron_right, color: Colors.grey),
      contentPadding: EdgeInsets.zero,
      onTap: onTap, // Use the callback
    );
  }
}

// Helper Widget for Booking Cards
class _BookingCard extends StatelessWidget {
  final String builderName;
  final String builderImage;
  final String type;
  final String date;
  final String status;
  final Color statusColor;
  final Color primaryColor;
  final bool isActive;

  const _BookingCard({
    required this.builderName,
    required this.builderImage,
    required this.type,
    required this.date,
    required this.status,
    required this.statusColor,
    required this.primaryColor,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(backgroundImage: NetworkImage(builderImage)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(builderName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(type, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(status, style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.calendar_today, size: 14, color: Colors.grey.shade600),
              const SizedBox(width: 6),
              Text(date, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: isActive
                ? [
              Expanded(child: OutlinedButton(onPressed: () {}, child: Text(AppStrings.message))),
              const SizedBox(width: 12),
              Expanded(child: OutlinedButton(onPressed: () {}, child: Text(AppStrings.reschedule))),
            ]
                : [
              Expanded(child: OutlinedButton(onPressed: () {}, child: Text(AppStrings.bookAgain))),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
                  child: Text(AppStrings.leaveReview, style: const TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}