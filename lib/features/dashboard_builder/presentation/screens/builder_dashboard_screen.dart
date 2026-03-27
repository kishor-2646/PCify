import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pcify/features/auth/presentation/controllers/auth_controller.dart';
import 'package:pcify/features/auth/presentation/screens/landing_screen.dart';
import 'package:pcify/features/booking/presentation/screens/booking_management_screen.dart';
import 'package:pcify/features/builder_profile/presentation/screens/builder_profile_management_screen.dart';
import 'package:pcify/features/builder_profile/presentation/screens/builder_reviews_screen.dart';
import 'package:pcify/features/chat/presentation/screens/builder_chat_list_screen.dart';
import '../../../../core/constants/app_strings.dart';


class BuilderDashboardScreen extends ConsumerStatefulWidget {
  const BuilderDashboardScreen({super.key});

  @override
  ConsumerState<BuilderDashboardScreen> createState() => _BuilderDashboardScreenState();
}

class _BuilderDashboardScreenState extends ConsumerState<BuilderDashboardScreen> {
  int _selectedIndex = 0;

  // Handle Bottom Nav Taps
  void _onBottomNavTapped(int index) {
    if (index == 2) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const BookingManagementScreen()));
    } else if (index == 3) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const BuilderChatListScreen()));
    } else if (index == 4) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const BuilderProfileManagementScreen()));
    } else {
      setState(() => _selectedIndex = index);
    }
  }

  void _navigateToReviews() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const BuilderReviewsScreen()));
  }

  // --- LOGOUT LOGIC ---
  Future<void> _handleLogout() async {
    await ref.read(authControllerProvider.notifier).signOut();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LandingScreen()),
            (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final builderColor = const Color(0xFF1E293B);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,

      // --- Header ---
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 16,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(color: builderColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
              child: Icon(Icons.computer, color: builderColor, size: 20),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(4)),
              child: Text(AppStrings.modeBuilder, style: TextStyle(color: Colors.grey.shade700, fontSize: 12, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.black87),
            onPressed: () {},
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            // Replaced simple CircleAvatar with PopupMenuButton for Logout
            child: PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'logout') {
                  _handleLogout();
                } else if (value == 'profile') {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const BuilderProfileManagementScreen()));
                }
              },
              child: const CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11'),
              ),
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'profile',
                  child: Row(
                    children: [
                      Icon(Icons.person, color: Colors.black87, size: 20),
                      SizedBox(width: 12),
                      Text('Profile'),
                    ],
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'logout',
                  child: Row(
                    children: [
                      Icon(Icons.logout, color: Colors.red, size: 20),
                      SizedBox(width: 12),
                      Text('Logout', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Section 1: KPI Cards ---
            Row(
              children: [
                _buildKpiCard("24", AppStrings.kpiProfileViews, Icons.visibility_outlined, Colors.blue),
                const SizedBox(width: 12),
                _buildKpiCard("3", AppStrings.kpiInquiries, Icons.chat_bubble_outline, Colors.orange),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildKpiCard("7", AppStrings.kpiBookings, Icons.calendar_today_outlined, Colors.purple),
                const SizedBox(width: 12),
                _buildKpiCard(
                  "4.8",
                  AppStrings.kpiRating,
                  Icons.star_outline,
                  Colors.amber,
                  onTap: _navigateToReviews,
                ),
              ],
            ),

            const SizedBox(height: 32),

            // --- Section 2: Active Bookings ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppStrings.upcomingConsultations, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                TextButton(onPressed: () {}, child: Text(AppStrings.viewAllBookings)),
              ],
            ),
            const SizedBox(height: 8),
            _buildActiveBookingCard(
              "Amit Singh",
              "Gaming Build (RTX 4070)",
              "Today, 3:00 PM",
              "Confirmed",
              Colors.green,
              builderColor,
            ),

            const SizedBox(height: 32),

            // --- Section 3: Pending Inquiries ---
            Text(AppStrings.newInquiries, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _buildInquiryCard(
              "Sneha R.",
              "Video Editing Workstation",
              "Budget: ₹1.5L",
              "I need a PC for 4K editing in Premiere Pro...",
              "2 hours ago",
              builderColor,
            ),

            const SizedBox(height: 32),

            // --- Section 4: Earnings (Teaser) ---
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [builderColor, builderColor.withOpacity(0.8)]),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("This Month", style: TextStyle(color: Colors.white70)),
                      Text(AppStrings.viewEarnings, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Row(
                    children: [
                      Text("₹45,000", style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _buildEarningsStat("Total: ₹2.45L"),
                      const SizedBox(width: 16),
                      _buildEarningsStat("Pending: ₹8k"),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),

      // --- Bottom Navigation ---
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onBottomNavTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: builderColor,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        selectedLabelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontSize: 10),
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: AppStrings.navDashboard),
          BottomNavigationBarItem(
            icon: Badge(label: const Text('3'), child: const Icon(Icons.notifications_none)),
            label: AppStrings.navInquiries,
          ),
          const BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: AppStrings.navBookings),
          const BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: AppStrings.navMessages),
          const BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: AppStrings.navProfile),
        ],
      ),
    );
  }

  // --- Widgets ---

  Widget _buildKpiCard(String value, String label, IconData icon, Color color, {VoidCallback? onTap}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Icon(icon, color: color, size: 20),
                ],
              ),
              const SizedBox(height: 4),
              Text(label, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActiveBookingCard(String name, String details, String time, String status, Color statusColor, Color primaryColor) {
    return Container(
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
              const CircleAvatar(backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=68')),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(details, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                child: Text(status, style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.access_time, size: 16, color: primaryColor),
              const SizedBox(width: 4),
              Text(time, style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(side: BorderSide(color: Colors.grey.shade300)),
                  child: const Text("Message", style: TextStyle(color: Colors.black87)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
                  child: Text(AppStrings.startCall, style: const TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInquiryCard(String name, String type, String budget, String message, String time, Color primaryColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const CircleAvatar(radius: 16, backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=44')),
                  const SizedBox(width: 8),
                  Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                ],
              ),
              Text(time, style: TextStyle(color: Colors.grey.shade500, fontSize: 11)),
            ],
          ),
          const SizedBox(height: 8),
          Text("$type • $budget", style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          const SizedBox(height: 4),
          Text(message, style: TextStyle(color: Colors.grey.shade600, fontSize: 13), maxLines: 2, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(side: BorderSide(color: Colors.grey.shade300)),
                  child: Text(AppStrings.declineInquiry, style: const TextStyle(color: Colors.grey)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: Text(AppStrings.acceptInquiry, style: const TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEarningsStat(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(4)),
      child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 12)),
    );
  }
}