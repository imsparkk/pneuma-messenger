import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pneuma_messenger/features/auth/auth_service.dart';
import 'package:pneuma_messenger/features/home/drawer/drawer.dart';
import '../services/search_service.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  final SearchService _searchService = SearchService();
  List<Map<String, dynamic>> _searchResults = [];
  bool _isSearching = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void logout() async {
    try {
      await authService.value.signOut();
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
      }
    } on FirebaseException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'Произошла ошибка при выходе!')),
        );
      }
    }
  }

  Future<void> _performSearch(String query) async {
    final trimmedQuery = query.trim();
    if (trimmedQuery.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    final results = await _searchService.searchUsers(trimmedQuery);
    if (!mounted) return;

    setState(() {
      _searchResults = results;
      _isSearching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
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
        },
      ),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 18, 19, 22),
        title: const Text('Search', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Center(
            child: SizedBox(
              width: 350,
              child: TextField(
                controller: _controller,
                style: const TextStyle(color: Colors.white),
                cursorColor: Colors.white,
                cursorOpacityAnimates: true,
                onChanged: _performSearch,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white.withAlpha(25),
                  prefixIcon: const Icon(Icons.search, color: Colors.white, size: 30),
                  prefixIconConstraints: const BoxConstraints(minWidth: 60),
                  hintText: 'Search',
                  hintStyle: const TextStyle(color: Colors.white70),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    borderSide: BorderSide(color: Colors.white, width: 1),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    borderSide: BorderSide(color: Colors.white, width: 1),
                  ),
                  errorBorder: const OutlineInputBorder(
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
          Expanded(
            child: _isSearching
                ? const Center(child: CircularProgressIndicator(color: Colors.white))
                : _searchResults.isEmpty
                    ? Center(
                        child: Text(
                          _controller.text.trim().isEmpty
                              ? 'Введите имя для поиска'
                              : 'Ничего не найдено',
                          style: const TextStyle(color: Colors.white70),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _searchResults.length,
                        itemBuilder: (context, index) {
                          final user = _searchResults[index];
                          return ListTile(
                            title: Text(
                              user['name']?.toString() ?? 'Без имени',
                              style: const TextStyle(color: Colors.white),
                            ),
                            subtitle: Text(
                              user['email']?.toString() ?? '',
                              style: const TextStyle(color: Colors.white70),
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
