import 'package:flutter/material.dart';

NavigationBar homeNavigatorBar() {
  return NavigationBar(
    backgroundColor: Color.fromARGB(251, 43, 46, 53),
    height: 60,
    destinations: [
      NavigationDestination(
        icon: Icon(Icons.chat_bubble_outline, color: Colors.white),
        label: "Chats",
      ),
      NavigationDestination(
        icon: Icon(Icons.settings_outlined, color: Colors.white),
        label: "Settings",
      ),
    ],

  );
}