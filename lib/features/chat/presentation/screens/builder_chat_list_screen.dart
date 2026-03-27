import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_strings.dart';
import 'chat_screen.dart'; // Reuse the Chat Screen

class BuilderChatListScreen extends ConsumerStatefulWidget {
  const BuilderChatListScreen({super.key});

  @override
  ConsumerState<BuilderChatListScreen> createState() => _BuilderChatListScreenState();
}

class _BuilderChatListScreenState extends ConsumerState<BuilderChatListScreen> {
  final TextEditingController _searchController = TextEditingController();

  // Mock Conversations
  final List<Map<String, dynamic>> _conversations = [
    {
      'name': 'Amit Singh',
      'image': 'https://i.pravatar.cc/150?img=68',
      'message': 'Thanks for the quick response! When can we start?',
      'time': '10:05 AM',
      'unread': 2,
    },
    {
      'name': 'Sneha R.',
      'image': 'https://i.pravatar.cc/150?img=44',
      'message': 'I have a budget of around 1.5L. Is that enough for...',
      'time': 'Yesterday',
      'unread': 0,
    },
    {
      'name': 'Arjun K.',
      'image': 'https://i.pravatar.cc/150?img=12',
      'message': 'Sent the advance payment.',
      'time': 'Oct 12',
      'unread': 0,
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openChat(String name, String image) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(
          builderName: name, // In this context, it's the customer name
          builderImage: image,
          isOnline: false, // Don't show online status for customers typically
        ),
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
        title: Text(
          AppStrings.conversations,
          style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.more_vert, color: Colors.black87), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: AppStrings.searchCustomers,
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),

          // Conversation List
          Expanded(
            child: ListView.builder(
              itemCount: _conversations.length,
              itemBuilder: (context, index) {
                final chat = _conversations[index];
                return ListTile(
                  onTap: () => _openChat(chat['name'], chat['image']),
                  leading: Stack(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundImage: NetworkImage(chat['image']),
                      ),
                      if (chat['unread'] > 0)
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                          ),
                        ),
                    ],
                  ),
                  title: Text(
                    chat['name'],
                    style: TextStyle(
                      fontWeight: chat['unread'] > 0 ? FontWeight.bold : FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    chat['message'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: chat['unread'] > 0 ? Colors.black87 : Colors.grey.shade600,
                      fontWeight: chat['unread'] > 0 ? FontWeight.w500 : FontWeight.normal,
                    ),
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        chat['time'],
                        style: TextStyle(
                          fontSize: 12,
                          color: chat['unread'] > 0 ? builderColor : Colors.grey,
                          fontWeight: chat['unread'] > 0 ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      const SizedBox(height: 6),
                      if (chat['unread'] > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: builderColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            chat['unread'].toString(),
                            style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                    ],
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