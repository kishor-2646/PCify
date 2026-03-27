import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_strings.dart';

class BookingManagementScreen extends ConsumerStatefulWidget {
  const BookingManagementScreen({super.key});

  @override
  ConsumerState<BookingManagementScreen> createState() => _BookingManagementScreenState();
}

class _BookingManagementScreenState extends ConsumerState<BookingManagementScreen> with SingleTickerProviderStateMixin {
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

  @override
  Widget build(BuildContext context) {
    final builderColor = const Color(0xFF1E293B);

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
          AppStrings.manageBookings,
          style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: builderColor,
          unselectedLabelColor: Colors.grey,
          indicatorColor: builderColor,
          isScrollable: true, // Allow scrolling if tabs are wide
          tabAlignment: TabAlignment.start, // Align to left
          padding: EdgeInsets.zero,
          indicatorWeight: 3,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          tabs: [
            // Using Row to add Badge
            Tab(child: Row(
              children: [
                Text(AppStrings.tabNew),
                const SizedBox(width: 4),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                  child: const Text('2', style: TextStyle(color: Colors.white, fontSize: 10)),
                )
              ],
            )),
            Tab(text: AppStrings.tabConfirmed),
            Tab(text: AppStrings.tabCompleted),
            Tab(text: AppStrings.tabCancelled),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildNewInquiriesTab(builderColor),
          _buildConfirmedBookingsTab(builderColor),
          _buildCompletedBookingsTab(builderColor),
          _buildCancelledBookingsTab(builderColor),
        ],
      ),
    );
  }

  // --- TAB 1: New Inquiries ---
  Widget _buildNewInquiriesTab(Color color) {
    // Mock Data
    final inquiries = [
      {
        'name': 'Sneha R.',
        'image': 'https://i.pravatar.cc/150?img=44',
        'type': 'Video Editing Workstation',
        'budget': 'Budget: ₹1.5L',
        'message': 'I need a PC for 4K editing in Premiere Pro...',
        'time': '2 hours ago',
      },
      {
        'name': 'Arjun K.',
        'image': 'https://i.pravatar.cc/150?img=12',
        'type': 'Gaming PC',
        'budget': 'Budget: ₹80k',
        'message': 'Looking for a decent gaming rig for Valorant...',
        'time': '5 hours ago',
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: inquiries.length,
      itemBuilder: (context, index) {
        final item = inquiries[index];
        return _InquiryCard(
          name: item['name']!,
          image: item['image']!,
          type: item['type']!,
          budget: item['budget']!,
          message: item['message']!,
          time: item['time']!,
          primaryColor: color,
        );
      },
    );
  }

  // --- TAB 2: Confirmed Bookings ---
  Widget _buildConfirmedBookingsTab(Color color) {
    // Mock Data
    final bookings = [
      {
        'name': 'Amit Singh',
        'image': 'https://i.pravatar.cc/150?img=68',
        'id': 'PCB-20251114-00245',
        'type': 'Gaming Build',
        'date': 'Today, 3:00 PM',
        'countdown': 'In 4 hours',
        'requirements': 'RTX 4070, i5-13600K, 32GB RAM...',
        'payment': 'Paid',
        'paymentColor': Colors.green,
      },
      {
        'name': 'Priya M.',
        'image': 'https://i.pravatar.cc/150?img=9',
        'id': 'PCB-20251118-00992',
        'type': 'Full Assembly',
        'date': 'Nov 18, 10:00 AM',
        'countdown': '4 days left',
        'requirements': 'Custom Water Loop, Lian Li Case...',
        'payment': 'Pending',
        'paymentColor': Colors.orange,
      }
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final item = bookings[index];
        return _ConfirmedBookingCard(
          name: item['name'] as String,
          image: item['image'] as String,
          id: item['id'] as String,
          type: item['type'] as String,
          date: item['date'] as String,
          countdown: item['countdown'] as String,
          requirements: item['requirements'] as String,
          payment: item['payment'] as String,
          paymentColor: item['paymentColor'] as Color,
          primaryColor: color,
        );
      },
    );
  }

  // --- TAB 3: Completed Bookings ---
  Widget _buildCompletedBookingsTab(Color color) {
    return Center(child: Text("No completed bookings yet", style: TextStyle(color: Colors.grey.shade600)));
  }

  // --- TAB 4: Cancelled Bookings ---
  Widget _buildCancelledBookingsTab(Color color) {
    return Center(child: Text("No cancelled bookings", style: TextStyle(color: Colors.grey.shade600)));
  }
}

// --- Helper Widgets ---

class _InquiryCard extends StatelessWidget {
  final String name;
  final String image;
  final String type;
  final String budget;
  final String message;
  final String time;
  final Color primaryColor;

  const _InquiryCard({
    required this.name,
    required this.image,
    required this.type,
    required this.budget,
    required this.message,
    required this.time,
    required this.primaryColor,
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
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(radius: 16, backgroundImage: NetworkImage(image)),
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
}

class _ConfirmedBookingCard extends StatelessWidget {
  final String name;
  final String image;
  final String id;
  final String type;
  final String date;
  final String countdown;
  final String requirements;
  final String payment;
  final Color paymentColor;
  final Color primaryColor;

  const _ConfirmedBookingCard({
    required this.name,
    required this.image,
    required this.id,
    required this.type,
    required this.date,
    required this.countdown,
    required this.requirements,
    required this.payment,
    required this.paymentColor,
    required this.primaryColor,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(radius: 20, backgroundImage: NetworkImage(image)),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text(id, style: TextStyle(color: Colors.grey.shade500, fontSize: 11)),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: paymentColor.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                child: Text(payment, style: TextStyle(color: paymentColor, fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 12),

          // Date & Type
          Row(
            children: [
              _buildInfoBadge(Icons.calendar_today, date, primaryColor),
              const SizedBox(width: 12),
              _buildInfoBadge(Icons.build, type, Colors.grey.shade700),
            ],
          ),
          const SizedBox(height: 8),
          Text(countdown, style: TextStyle(color: Colors.orange.shade800, fontSize: 12, fontWeight: FontWeight.bold)),

          const SizedBox(height: 12),
          // Requirements Expandable (Simplified for now)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(8)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Requirements:", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(requirements, style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
              ],
            ),
          ),

          const SizedBox(height: 16),
          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.chat_bubble_outline, size: 16),
                  label: const Text("Message", style: TextStyle(fontSize: 12)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black87,
                    padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.video_call, size: 16),
                  label: const Text("Start Call", style: TextStyle(fontSize: 12)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () {},
              child: Text("More Actions (Upload Spec, Mark Complete)", style: TextStyle(color: primaryColor, fontSize: 12)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBadge(IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(text, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: color)),
      ],
    );
  }
}