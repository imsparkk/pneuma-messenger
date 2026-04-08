import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pneuma_messenger/features/auth/auth_service.dart';
import 'package:pneuma_messenger/features/home/chats/services/chat_service.dart';
import 'package:pneuma_messenger/features/home/drawer/drawer.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  final ChatService _chatService = ChatService();

  void logout() async {
    try {
      await authService.value.signOut();
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
      }
    } on FirebaseException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? "Произошла ошибка при выходе!")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 18, 19, 22),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 18, 19, 22),
        title: Text("Pneuma", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      drawer: drawer(
        () {
          Navigator.popUntil(context, ModalRoute.withName('/'));
        },
        () {
          Navigator.pop(context);
          Navigator.pushNamed(context, '/search_page');
        },
        () {
          Navigator.pop(context);
          Navigator.pushNamed(context, '/settings_page');
        },
        () {
          Navigator.pop(context);
          Navigator.pushNamed(context, '/profile_page');
        },
        () {
          Navigator.pop(context);
          logout();
        }
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _chatService.getUserChats(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Ошибка загрузки чатов',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }

          final chats = snapshot.data?.docs ?? [];
          chats.sort((a, b) {
            final aData = a.data();
            final bData = b.data();
            final aTime = aData['lastMessageTime'];
            final bTime = bData['lastMessageTime'];

            final aMillis = aTime is Timestamp ? aTime.millisecondsSinceEpoch :
                aTime is DateTime ? aTime.millisecondsSinceEpoch : 0;
            final bMillis = bTime is Timestamp ? bTime.millisecondsSinceEpoch :
                bTime is DateTime ? bTime.millisecondsSinceEpoch : 0;

            return bMillis.compareTo(aMillis);
          });

          if (chats.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.chat_bubble_outline, size: 64, color: Colors.white24),
                  const SizedBox(height: 16),
                  const Text(
                    'У вас пока нет чатов',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () => Navigator.pushNamed(context, '/search_page'),
                    icon: const Icon(Icons.add),
                    label: const Text('Добавить чат'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: chats.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return ListTile(
                  leading: Icon(Icons.add, color: Colors.white),
                  title: Text(
                    'Добавить чат',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () => Navigator.pushNamed(context, '/search_page'),
                );
              }

              final chatIndex = index - 1;
              final chat = chats[chatIndex].data();
              final chatId = chats[chatIndex].id;
              final currentUser = FirebaseAuth.instance.currentUser;
              
              final otherUserId = (chat['participants'] as List<dynamic>?)
                  ?.firstWhere(
                    (id) => id.toString() != currentUser?.uid,
                    orElse: () => '',
                  )
                  .toString() ?? '';

              final participantNamesRaw = chat['participantNames'];
              final participantNames = <String, String>{};
              if (participantNamesRaw is Map) {
                for (final entry in participantNamesRaw.entries) {
                  participantNames[entry.key.toString()] = entry.value?.toString() ?? 'Unknown';
                }
              }

              final otherUserName = participantNames.entries
                  .firstWhere(
                    (entry) => entry.key != currentUser?.uid,
                    orElse: () => const MapEntry('', 'Unknown User'),
                  )
                  .value;

              final firstLetter = otherUserName.isNotEmpty ? otherUserName[0].toUpperCase() : '?';

              return StreamBuilder<DocumentSnapshot>(
                stream: otherUserId.isNotEmpty 
                    ? FirebaseFirestore.instance.collection('users').doc(otherUserId).snapshots()
                    : null,
                builder: (context, userSnapshot) {
                  final userData = userSnapshot.data?.data() as Map<String, dynamic>? ?? {};
                  final isOnlineRaw = userData['isOnline'];
                  final isOnline = isOnlineRaw is bool ? isOnlineRaw : false;

                  return ListTile(
                    leading: Stack(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.blue,
                          child: Text(
                            firstLetter,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: isOnline ? Colors.green : Colors.grey,
                              shape: BoxShape.circle,
                              border: Border.all(color: const Color.fromARGB(255, 18, 19, 22), width: 2),
                            ),
                          ),
                        ),
                      ],
                    ),
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(
                            otherUserName,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        if (isOnline)
                          Container(
                            margin: const EdgeInsets.only(left: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'онлайн',
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                      ],
                    ),
                    subtitle: Text(
                      chat['lastMessage'] ?? 'Нет сообщений',
                      style: TextStyle(color: Colors.white70),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/chat_page',
                        arguments: {
                          'chatId': chatId,
                          'otherUserName': otherUserName,
                          'otherUserId': otherUserId,
                        },
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
