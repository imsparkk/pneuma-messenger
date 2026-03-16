import 'package:flutter/material.dart';

NavigationBar homeNavigatorBar() {
  return NavigationBar(
    labelTextStyle: WidgetStatePropertyAll(TextStyle(color: Colors.white)),
    indicatorColor: Color.fromRGBO(45, 49, 56, 0.984),
    backgroundColor: Color.fromARGB(249, 30, 31, 37),
    height: 60,
    destinations: [
      NavigationDestination(
        icon: Icon(Icons.chat_bubble_outline, color: Colors.white),
        label: "Chats",
        
      ),
      NavigationDestination(
        icon: Icon(Icons.search, color: Colors.white),
        label: "Search",
        
      ),
    ],

  );
}