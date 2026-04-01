import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pneuma_messenger/features/auth/auth_service.dart';
import 'package:pneuma_messenger/features/home/drawer/drawer.dart';

class SearchPage extends StatefulWidget {
  SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
  final TextEditingController searchController = TextEditingController();
}

class _SearchPageState extends State<SearchPage> {

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
        backgroundColor: Color.fromARGB(255, 18, 19, 22),
        title: Text("Search", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(height: 10),
          Center(
            child: SizedBox(
              width: 350,
              child: TextField(
                controller: widget.searchController,
                    style: TextStyle(color: Colors.white),
                    cursorColor: Colors.white,
                    cursorOpacityAnimates: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white.withAlpha(25),
                      prefixIcon: Icon(Icons.search, color: Colors.white, size: 30),
                      prefixIconConstraints: BoxConstraints(minWidth: 60),
                      hintText: "Search",
                      hintStyle: TextStyle(
              color: Colors.white70
                      ),
              
                      border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              borderSide: BorderSide(color: Colors.white, width: 1)
                      ),
              
                      focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              borderSide: BorderSide(color: Colors.white, width: 1)
                      ),
              
                      errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              borderSide: BorderSide(
                width: 1,
                color: Colors.red,
                style: BorderStyle.solid,
              ),
                      ),
                    ),
                  ),
            ),
          ),
        ]
        ),
    );
  }
}