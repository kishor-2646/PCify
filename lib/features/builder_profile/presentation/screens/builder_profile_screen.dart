import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../booking/presentation/screens/booking_screen.dart';

// Provider to fetch portfolio for a specific builder UID
final publicPortfolioProvider = StreamProvider.family<List<Map<String, dynamic>>, String>((ref, uid) {
  return FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .collection('portfolio')
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
});

class BuilderProfileScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> builderData;

  const BuilderProfileScreen({
    super.key,
    required this.builderData,
  });

  @override
  ConsumerState<BuilderProfileScreen> createState() => _BuilderProfileScreenState();
}

class _BuilderProfileScreenState extends ConsumerState<BuilderProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color(0xFF0EA5E9);
    final builder = widget.builderData;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                slivers: [
                  _buildSliverAppBar(),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHeaderSection(builder),
                          const SizedBox(height: 24),
                          _buildQuickStats(builder), // Passing builder data
                          const SizedBox(height: 24),
                          const Divider(),
                          const SizedBox(height: 24),
                          _buildAboutSection(builder),
                          const SizedBox(height: 24),
                          _buildSpecializations(builder),
                          const SizedBox(height: 24),
                          _buildServiceDetails(builder),
                          const SizedBox(height: 24),
                          _buildPortfolioSection(builder), // Updated to use provider
                          const SizedBox(height: 24),
                          _buildReviewsSection(),
                          const SizedBox(height: 80),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            _buildBottomBar(primaryColor),
          ],
        ),
      ),
    );
  }

  // --- Widgets ---

  SliverAppBar _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 0,
      floating: true,
      pinned: true,
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(icon: const Icon(Icons.share_outlined, color: Colors.black87), onPressed: () {}),
        IconButton(icon: const Icon(Icons.flag_outlined, color: Colors.black87), onPressed: () {}),
      ],
    );
  }

  Widget _buildHeaderSection(Map<String, dynamic> builder) {
    return Column(
      children: [
        Center(
          child: CircleAvatar(
            radius: 60,
            backgroundColor: Colors.grey.shade100,
            backgroundImage: NetworkImage(builder['image'] ?? 'https://i.pravatar.cc/300'),
            onBackgroundImageError: (_,__) => const Icon(Icons.person, size: 60),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              builder['name'] ?? "Builder Name",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            if (builder['expert'] == true || builder['isVerified'] == true) ...[
              const SizedBox(width: 8),
              const Icon(Icons.verified, color: Colors.blue, size: 24),
            ]
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (builder['isVerified'] == true)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(4)),
                child: Text("Verified ID ✓", style: TextStyle(color: Colors.green.shade700, fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: Colors.amber.shade50, borderRadius: BorderRadius.circular(4)),
              child: Text("${builder['total_builds'] ?? '0'}+ Builds ⭐", style: TextStyle(color: Colors.amber.shade800, fontSize: 12, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.star_rounded, color: Colors.amber, size: 20),
            Text(" ${builder['rating'] ?? 0.0} (245 reviews)", style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }

  // Updated to accept builder data
  Widget _buildQuickStats(Map<String, dynamic>? builder) {
    return Row(
      children: [
        _buildStatBox("⭐ ${builder?['total_builds'] ?? 0}", AppStrings.buildsCompleted),
        const SizedBox(width: 12),
        _buildStatBox("📅 98%", AppStrings.onTimeDelivery),
        const SizedBox(width: 12),
        _buildStatBox("😊 96%", AppStrings.customerSatisfaction),
      ],
    );
  }

  Widget _buildStatBox(String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutSection(Map<String, dynamic> builder) {
    final bio = builder['bio'] ?? "No bio available.";
    final socials = builder['socialLinks'] as Map<String, dynamic>?;
    final youtube = socials?['youtube'] ?? '';
    final insta = socials?['instagram'] ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppStrings.aboutBuilder, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(
          bio,
          style: TextStyle(color: Colors.grey.shade700, height: 1.5),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            if (youtube.isNotEmpty) _buildSocialIcon(Icons.video_library, "YouTube", "Channel"),
            if (youtube.isNotEmpty && insta.isNotEmpty) const SizedBox(width: 16),
            if (insta.isNotEmpty) _buildSocialIcon(Icons.camera_alt, "Instagram", "Profile"),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialIcon(IconData icon, String platform, String label) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey.shade600),
        const SizedBox(width: 4),
        Text("$platform ($label)", style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
      ],
    );
  }

  Widget _buildSpecializations(Map<String, dynamic> builder) {
    List<String> tags = [];
    if (builder['specialization'] is String) {
      tags = [builder['specialization']];
    } else if (builder['specialization'] is List) {
      tags = List<String>.from(builder['specialization']);
    } else {
      tags = ["Custom PC"];
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Specializations", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: tags.map((tag) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.blue.shade100),
            ),
            child: Text(tag, style: TextStyle(color: Colors.blue.shade800, fontSize: 12, fontWeight: FontWeight.w600)),
          )).toList(),
        ),
      ],
    );
  }

  Widget _buildServiceDetails(Map<String, dynamic> builder) {
    final pricing = builder['pricing'] as Map<String, dynamic>?;
    final rate = pricing?['consultationRate'] ?? 'N/A';
    final area = builder['serviceArea'] ?? 'Not specified';
    final response = builder['availability']?['responseTime'] ?? 'Usually responds in < 2 hours';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppStrings.serviceDetails, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        _buildDetailRow(Icons.currency_rupee, "Consultation Rate", "₹$rate/hour"),
        const SizedBox(height: 12),
        _buildDetailRow(Icons.timer_outlined, AppStrings.responseTimeLabel, response),
        const SizedBox(height: 12),
        _buildDetailRow(Icons.map_outlined, AppStrings.serviceAreasLabel, area),
      ],
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, size: 20, color: Colors.black87),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
              Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ],
    );
  }

  // Updated to use the provider for real data
  Widget _buildPortfolioSection(Map<String, dynamic> builder) {
    final uid = builder['uid'];

    if (uid == null) {
      return const SizedBox(); // Should not happen if data is correct
    }

    // Watch the portfolio for this specific builder
    final portfolioAsync = ref.watch(publicPortfolioProvider(uid));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppStrings.portfolioRecentBuilds, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        SizedBox(
          height: 120,
          child: portfolioAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Text("Error: $err"),
            data: (portfolio) {
              if (portfolio.isEmpty) {
                return const Center(child: Text("No builds added yet.", style: TextStyle(color: Colors.grey)));
              }
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: portfolio.length,
                itemBuilder: (context, index) {
                  final item = portfolio[index];
                  return Container(
                    width: 120,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: NetworkImage(item['image'] ?? 'https://images.unsplash.com/photo-1587202372775-e229f172b9d7?auto=format&fit=crop&q=80'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                          ),
                          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
                        ),
                        child: Text(
                          item['name'] ?? "Build",
                          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildReviewsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(AppStrings.customerReviews, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextButton(onPressed: () {}, child: const Text("View All")),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const CircleAvatar(radius: 16, backgroundColor: Colors.grey, child: Icon(Icons.person, size: 20, color: Colors.white)),
                  const SizedBox(width: 8),
                  const Text("User Review", style: TextStyle(fontWeight: FontWeight.bold)),
                  const Spacer(),
                  const Icon(Icons.star, size: 16, color: Colors.amber),
                  const Text(" 5.0", style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 8),
              const Text("Great Builder!", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 4),
              Text(
                "This is a placeholder for real reviews.",
                style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar(Color primaryColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.favorite_border),
              onPressed: () {},
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                side: BorderSide(color: primaryColor),
              ),
              child: Text(AppStrings.messageBuilder, style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BookingScreen(builderData: widget.builderData),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(AppStrings.bookConsultation, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}