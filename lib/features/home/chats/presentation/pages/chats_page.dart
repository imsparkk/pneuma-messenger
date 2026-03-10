import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pneuma_messenger/features/auth/auth_service.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {


  void logout() async {
    try {
      await authService.value.signOut();
      if (mounted) {
        Navigator.pop(context);
      }
    } on FirebaseException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? "Произошла ошибка при выходе!"))
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
        centerTitle: true
        ),
      drawer: Drawer(
        backgroundColor: Color.fromARGB(255, 18, 19, 22),
        child: ListView(
          children: [
            ListTile(
            title: Text("Profile", style: TextStyle(color: Colors.white)),
            ),
            ListTile(
              title: Text("Settings", style: TextStyle(color: Colors.white)),
            ),
            ListTile(
              title: Text("Logout", style: TextStyle(color: Colors.red)),
              onTap: () {
                logout();
              },
            ),
          ]
        ),
    ),
    body: Column(
      children: [
        
      ],
    ),
    );
  }
}