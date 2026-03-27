import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../home_customer/presentation/widgets/builder_card.dart';
import '../widgets/filter_bottom_sheet.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  // Mock Data (Simulating search results)
  final List<Map<String, dynamic>> _searchResults = [
    {
      'name': 'Rahul Sharma',
      'image': 'https://i.pravatar.cc/150?img=11',
      'rating': 4.8,
      'builds': 245,
      'location': 'Indiranagar',
      'distance': '2.3 km',
      'price': '₹2000 - ₹10000',
      'expert': true,
      'tags': ['Gaming', 'Liquid Cooling', 'RGB'],
    },
    {
      'name': 'PC Wizards',
      'image': 'https://i.pravatar.cc/150?img=12',
      'rating': 4.2,
      'builds': 45,
      'location': 'Jayanagar',
      'distance': '5.1 km',
      'price': '₹1000 - ₹5000',
      'expert': false,
      'tags': ['Budget', 'Office'],
    },
    {
      'name': 'Ankit Verma',
      'image': 'https://i.pravatar.cc/150?img=3',
      'rating': 4.9,
      'builds': 312,
      'location': 'Whitefield',
      'distance': '8.5 km',
      'price': '₹3000 - ₹15000',
      'expert': true,
      'tags': ['Workstation', 'Editing', 'Server'],
    },
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openFilters() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Needed for draggable sheet to work well
      backgroundColor: Colors.transparent,
      builder: (context) => const FilterBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: TextField(
            controller: _searchController,
            autofocus: true, // Focus automatically when opening search
            decoration: InputDecoration(
              hintText: AppStrings.searchBuildersHint,
              hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
              filled: true,
              fillColor: Colors.grey.shade100,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(icon: const Icon(Icons.clear, size: 20), onPressed: () => setState(() => _searchController.clear()))
                  : const Icon(Icons.mic, color: Colors.grey),
            ),
            onChanged: (val) => setState(() {}), // Trigger rebuild for clear icon
          ),
        ),
      ),
      body: Column(
        children: [
          // --- Filter Bar ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                // Filter Button
                OutlinedButton.icon(
                  onPressed: _openFilters,
                  icon: const Icon(Icons.tune, size: 18),
                  label: const Text(AppStrings.filterTitle),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black87,
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                ),
                const SizedBox(width: 12),

                // Sort Dropdown (Simplified as text for MVP)
                const Text("Sort by: ", style: TextStyle(color: Colors.grey)),
                DropdownButton<String>(
                  value: "Best Match",
                  underline: const SizedBox(), // Remove underline
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                  items: ["Best Match", "Highest Rated", "Closest", "Price: Low to High"]
                      .map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                  onChanged: (val) {},
                ),

                const Spacer(),
                Text("${_searchResults.length} ${AppStrings.results}", style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),

          const Divider(height: 1),

          // --- Results List ---
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final builder = _searchResults[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  // Wrapping BuilderCard in a Container to give it full width in Vertical List
                  child: SizedBox(
                    width: double.infinity,
                    child: BuilderCard(
                      name: builder['name'],
                      imageUrl: builder['image'],
                      rating: builder['rating'],
                      buildCount: builder['builds'],
                      location: builder['location'],
                      distance: builder['distance'],
                      priceRange: builder['price'],
                      specializations: List<String>.from(builder['tags']),
                      isExpert: builder['expert'],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}