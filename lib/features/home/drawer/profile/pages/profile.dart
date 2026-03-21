import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 18, 19, 22),
      drawer: drawer(
        () {
          Navigator.popUntil(context, ModalRoute.withName('/'));
        },
        () {
          Navigator.pop(context);
        },
        () {
          Navigator.pop(context);
          Navigator.pushNamed(context, '/settings_page');
        },
        () {
          Navigator.pop(context);
          logout();
        },
      ),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 18, 19, 22),
        title: Text("Profile", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),

      body: Column(
        children: [
          SizedBox(height: 50),
          Center(
            child: CircleAvatar(backgroundColor: Colors.white, radius: 60),
          ),
          SizedBox(height: 25),
          Text('John Doe', style: TextStyle(fontSize: 30, color: Colors.white)),
          SizedBox(height: 15),
        ],
      ),
    );
  }
}
