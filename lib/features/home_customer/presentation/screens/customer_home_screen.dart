import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pcify/features/ai_configurator/presentation/screens/ai_configurator_screen.dart';
import 'package:pcify/features/ai_configurator/presentation/screens/benchmark_comparator_screen.dart';
import 'package:pcify/features/builder_profile/presentation/screens/builder_profile_screen.dart';
import 'package:pcify/features/chat/presentation/screens/chat_screen.dart';
import 'package:pcify/features/search/presentation/screens/search_screen.dart';
import '../../../../core/constants/app_strings.dart';
import '../widgets/builder_card.dart';
import 'customer_dashboard_screen.dart';
import '../../data/customer_repository.dart'; // Import Repository

final buildersStreamProvider = StreamProvider.autoDispose<List<Map<String, dynamic>>>((ref) {
  final repository = ref.watch(customerRepositoryProvider);
  return repository.getBuildersStream();
});

class CustomerHomeScreen extends ConsumerStatefulWidget {
  const CustomerHomeScreen({super.key});

  @override
  ConsumerState<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends ConsumerState<CustomerHomeScreen> {
  int _selectedIndex = 0;
  int _selectedTab = 0;

  final List<String> _tabs = [
    AppStrings.tabForYou,
    AppStrings.tabGaming,
    AppStrings.tabEditing,
    AppStrings.tabCoding,
    AppStrings.tabRecent,
  ];

  void _navigateToSearch() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SearchScreen()),
    );
  }

  void _navigateToAiConfigurator() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AiConfiguratorScreen()),
    );
  }

  void _navigateToBenchmark() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const BenchmarkComparatorScreen()),
    );
  }

  void _navigateToChat(String builderName, String builderImage) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(
          builderName: builderName,
          builderImage: builderImage,
        ),
      ),
    );
  }

  void _navigateToProfile(Map<String, dynamic> builderData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BuilderProfileScreen(builderData: builderData),
      ),
    );
  }

  void _onBottomNavTapped(int index) {
    if (index == 1) {
      _navigateToSearch();
    } else if (index == 2) {
      _navigateToChat("Messages Inbox", "https://i.pravatar.cc/150?img=11");
    } else if (index == 4) {
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CustomerDashboardScreen())
      );
    } else {
      setState(() => _selectedIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color(0xFF0EA5E9);
    final buildersAsync = ref.watch(buildersStreamProvider);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 16,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(color: primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
              child: Icon(Icons.computer, color: primaryColor, size: 20),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Location", style: TextStyle(color: Colors.grey.shade500, fontSize: 10)),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 14, color: Colors.redAccent),
                    const SizedBox(width: 2),
                    const Text(
                      "Bangalore",
                      style: TextStyle(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    const Icon(Icons.keyboard_arrow_down, size: 16, color: Colors.black54),
                  ],
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.compare_arrows, color: Colors.black87),
            tooltip: "Compare Builds",
            onPressed: _navigateToBenchmark,
          ),
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black87),
            onPressed: _navigateToSearch,
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined, color: Colors.black87),
                onPressed: () {},
              ),
              Positioned(
                right: 12,
                top: 12,
                child: Container(
                  height: 8, width: 8,
                  decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                ),
              )
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=60'),
            ),
          )
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Hero Section ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                image: DecorationImage(
                  image: const NetworkImage('https://images.unsplash.com/photo-1587202372775-e229f172b9d7?auto=format&fit=crop&q=80'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.7), BlendMode.darken),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.homeHeroTitle,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white, height: 1.2),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppStrings.homeHeroSubtitle,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade300),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: _navigateToSearch,
                    child: Container(
                      height: 48,
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.search, color: Colors.grey.shade500),
                          const SizedBox(width: 12),
                          Text(
                            AppStrings.searchHint,
                            style: TextStyle(color: Colors.grey.shade500),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(4)),
                            child: const Icon(Icons.tune, size: 16, color: Colors.black87),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _navigateToAiConfigurator,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(AppStrings.startBuilding),
                    ),
                  ),
                ],
              ),
            ),

            // --- Quick Filters / Tabs ---
            Container(
              height: 60,
              padding: const EdgeInsets.symmetric(vertical: 12),
              color: Colors.white,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: _tabs.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final isSelected = _selectedTab == index;
                  return ChoiceChip(
                    label: Text(_tabs[index]),
                    selected: isSelected,
                    onSelected: (bool selected) {
                      setState(() => _selectedTab = index);
                    },
                    selectedColor: primaryColor.withOpacity(0.1),
                    backgroundColor: Colors.white,
                    labelStyle: TextStyle(
                      color: isSelected ? primaryColor : Colors.grey.shade700,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    side: BorderSide(color: isSelected ? primaryColor : Colors.grey.shade300),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    showCheckmark: false,
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // --- Builder Cards Section ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Top Rated Builders", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  TextButton(onPressed: _navigateToSearch, child: const Text("See All")),
                ],
              ),
            ),

            SizedBox(
              height: 260,
              child: buildersAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(child: Text('Error: $err')),
                data: (builders) {
                  if (builders.isEmpty) {
                    return const Center(child: Text("No builders found yet."));
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    scrollDirection: Axis.horizontal,
                    itemCount: builders.length,
                    itemBuilder: (context, index) {
                      final builder = builders[index];
                      final name = builder['name'] ?? 'Unknown Builder';
                      final image = builder['profile_photo'] ?? 'https://i.pravatar.cc/150?img=11';
                      final rating = (builder['rating'] as num?)?.toDouble() ?? 0.0;
                      final builds = (builder['total_builds'] as int?) ?? 0;
                      final location = builder['serviceArea'] ?? 'Unknown Location';

                      final pricing = builder['pricing'] as Map<String, dynamic>?;
                      final priceRange = pricing != null
                          ? "₹${pricing['assemblyBudget'] ?? '2000'} - ₹${pricing['assemblyHigh'] ?? '10000'}"
                          : "Price on Request";

                      final specs = builder['specialization'] != null
                          ? [builder['specialization'] as String]
                          : ['Custom PC'];

                      // Create standardized map
                      final standardizedBuilderData = {
                        'name': name,
                        'image': image,
                        'rating': rating,
                        'total_builds': builds,
                        'serviceArea': location,
                        'pricing': pricing,
                        'specialization': specs,
                        ...builder // Include all other fields from Firestore
                      };

                      return BuilderCard(
                        name: name,
                        imageUrl: image,
                        rating: rating,
                        buildCount: builds,
                        location: location,
                        distance: "Online",
                        priceRange: priceRange,
                        specializations: specs,
                        isExpert: builder['isVerified'] ?? false,
                        onMessageTap: () => _navigateToChat(name, image),
                        onProfileTap: () => _navigateToProfile(standardizedBuilderData), // Pass correct data
                      );
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            // --- Recent Searches ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(AppStrings.sectionRecentSearches, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey)),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildSearchChip("Rtx 4090 Build"),
                  const SizedBox(width: 10),
                  _buildSearchChip("Custom Water Cooling"),
                  const SizedBox(width: 10),
                  _buildSearchChip("Whitefield Builders"),
                ],
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),

      // --- Bottom Navigation Bar ---
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onBottomNavTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        selectedLabelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontSize: 10),
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "Home"),
          const BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          BottomNavigationBarItem(
            icon: Badge(
              label: const Text('2'),
              backgroundColor: Colors.red,
              child: const Icon(Icons.chat_bubble_outline),
            ),
            label: "Messages",
          ),
          const BottomNavigationBarItem(icon: Icon(Icons.bookmark_outline), label: "Saved"),
          const BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Profile"),
        ],
      ),
    );
  }

  Widget _buildSearchChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          const Icon(Icons.history, size: 16, color: Colors.grey),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(color: Colors.black87)),
        ],
      ),
    );
  }
}