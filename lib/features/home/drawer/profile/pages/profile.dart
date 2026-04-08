import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:pneuma_messenger/features/auth/auth_service.dart';
import 'package:pneuma_messenger/features/home/drawer/drawer.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
    final currentUser = FirebaseAuth.instance.currentUser;
    
    if (currentUser == null) {
      return Scaffold(
        backgroundColor: const Color.fromARGB(255, 18, 19, 22),
        body: const Center(
          child: Text(
            'Пользователь не авторизован',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 18, 19, 22),
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
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 18, 19, 22),
        title: const Text("Профиль", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Ошибка загрузки профиля',
                style: const TextStyle(color: Colors.white),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }

          final userData = snapshot.data?.data() as Map<String, dynamic>? ?? {};
          final displayName = currentUser.displayName ?? userData['name'] ?? 'Пользователь';
          final email = currentUser.email ?? userData['email'] ?? 'Не указан';
          final createdAt = userData['createdAt'];
          final isOnlineRaw = userData['isOnline'];
          final isOnline = isOnlineRaw is bool ? isOnlineRaw : false;

          final firstLetter = displayName.isNotEmpty ? displayName[0].toUpperCase() : '?';

          String formatTimestamp(dynamic timestamp) {
            if (timestamp == null) return 'Неизвестно';
            
            DateTime dateTime;
            if (timestamp is Timestamp) {
              dateTime = timestamp.toDate();
            } else {
              return 'Неизвестно';
            }

            return DateFormat('dd.MM.yyyy HH:mm').format(dateTime);
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                
                Stack(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.blue,
                      radius: 60,
                      child: Text(
                        firstLetter,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: isOnline ? Colors.green : Colors.grey,
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color.fromARGB(255, 18, 19, 22), width: 3),
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 25),
                
                Text(
                  displayName,
                  style: const TextStyle(
                    fontSize: 28,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 30),
                
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      _buildProfileInfoRow(
                        icon: Icons.email,
                        label: 'Email',
                        value: email,
                      ),
                      const Divider(color: Colors.white24, height: 24),
                      
                      _buildProfileInfoRow(
                        icon: Icons.calendar_today,
                        label: 'Дата регистрации',
                        value: formatTimestamp(createdAt),
                      ),
                      const Divider(color: Colors.white24, height: 24),
                      
                      _buildProfileInfoRow(
                        icon: isOnline ? Icons.circle : Icons.circle_outlined,
                        label: 'Статус',
                        value: isOnline ? 'Онлайн' : 'Оффлайн',
                        iconColor: isOnline ? Colors.green : Colors.grey,
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 30),
                
                ElevatedButton.icon(
                  onPressed: () => Navigator.pushNamed(context, '/settings_page'),
                  icon: const Icon(Icons.settings),
                  label: const Text('Редактировать профиль'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileInfoRow({
    required IconData icon,
    required String label,
    required String value,
    Color? iconColor,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: iconColor ?? Colors.white70,
          size: 24,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
