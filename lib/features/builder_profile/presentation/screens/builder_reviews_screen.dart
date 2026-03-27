import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_strings.dart';

class BuilderReviewsScreen extends ConsumerStatefulWidget {
  const BuilderReviewsScreen({super.key});

  @override
  ConsumerState<BuilderReviewsScreen> createState() => _BuilderReviewsScreenState();
}

class _BuilderReviewsScreenState extends ConsumerState<BuilderReviewsScreen> {
  // Mock Reviews
  final List<Map<String, dynamic>> _reviews = [
    {
      'name': 'Rohan M.',
      'image': 'https://i.pravatar.cc/150?img=12',
      'rating': 5.0,
      'title': 'Excellent Gaming Build!',
      'text': 'Raj did an amazing job with my new RTX 4090 build. Cable management is super clean. Highly recommended!',
      'date': '2 days ago',
      'reply': null,
    },
    {
      'name': 'Priya S.',
      'image': 'https://i.pravatar.cc/150?img=9',
      'rating': 4.0,
      'title': 'Good service but slight delay',
      'text': 'The build quality is top notch, but the delivery was delayed by a day due to parts unavailability.',
      'date': '1 week ago',
      'reply': 'Sorry for the delay, Priya! Glad you liked the build.',
    },
  ];

  void _showReplyDialog(int index) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Reply to Review"),
        content: TextField(
          controller: controller,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: "Type your response...",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _reviews[index]['reply'] = controller.text;
              });
              Navigator.pop(context);
            },
            child: const Text("Post"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final builderColor = const Color(0xFF1E293B);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          AppStrings.reviewsAndRatings,
          style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // --- Summary Section ---
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  const Text("4.8", style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
                  Row(
                    children: List.generate(5, (index) => const Icon(Icons.star, color: Colors.amber, size: 20)),
                  ),
                  const SizedBox(height: 4),
                  Text(AppStrings.basedOnReviews, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                ],
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  children: [
                    _buildRatingBar(5, 0.8),
                    _buildRatingBar(4, 0.15),
                    _buildRatingBar(3, 0.05),
                    _buildRatingBar(2, 0.0),
                    _buildRatingBar(1, 0.0),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // --- Category Breakdown ---
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 2.5,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            children: [
              _buildCategoryBox(AppStrings.catExpertise, "4.8", Icons.psychology),
              _buildCategoryBox(AppStrings.catCommunication, "4.7", Icons.chat),
              _buildCategoryBox(AppStrings.catPunctuality, "4.9", Icons.access_time),
              _buildCategoryBox(AppStrings.catValue, "4.6", Icons.attach_money),
            ],
          ),

          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 16),

          // --- Reviews List ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("User Reviews", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              DropdownButton<String>(
                value: "Recent",
                underline: const SizedBox(),
                style: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.w600),
                items: ["Recent", "Highest", "Lowest"].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (val) {},
              ),
            ],
          ),
          const SizedBox(height: 16),

          ..._reviews.asMap().entries.map((entry) {
            final index = entry.key;
            final review = entry.value;
            return _buildReviewCard(review, builderColor, () => _showReplyDialog(index));
          }),
        ],
      ),
    );
  }

  Widget _buildRatingBar(int star, double percent) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Text("$star", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          const SizedBox(width: 8),
          Expanded(
            child: LinearProgressIndicator(
              value: percent,
              backgroundColor: Colors.grey.shade100,
              color: Colors.amber,
              minHeight: 6,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryBox(String title, String rating, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, size: 16, color: Colors.black54),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(rating, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text(title, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(Map<String, dynamic> review, Color color, VoidCallback onReply) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(backgroundImage: NetworkImage(review['image'])),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(review['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(review['date'], style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                ],
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(4)),
                child: Row(
                  children: [
                    Text("${review['rating']}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.green)),
                    const Icon(Icons.star, size: 12, color: Colors.green),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(review['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(review['text'], style: TextStyle(color: Colors.grey.shade700, height: 1.4)),

          if (review['reply'] != null)
            Container(
              margin: const EdgeInsets.only(top: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.05),
                border: Border(left: BorderSide(color: color, width: 3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Your Reply", style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 12)),
                  const SizedBox(height: 4),
                  Text(review['reply'], style: const TextStyle(fontSize: 13)),
                ],
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: TextButton.icon(
                onPressed: onReply,
                icon: const Icon(Icons.reply, size: 16),
                label: Text(AppStrings.replyToReview),
                style: TextButton.styleFrom(foregroundColor: color),
              ),
            ),
        ],
      ),
    );
  }
}