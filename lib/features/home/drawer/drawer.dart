import 'package:flutter/material.dart';

Drawer drawer(
  VoidCallback onTapHome,
  VoidCallback onTap1,
  VoidCallback onTap2,
  VoidCallback onTap3,
  VoidCallback onTap4,
) {
  return Drawer(
    backgroundColor: Color.fromARGB(255, 18, 19, 22),
    child: ListView(
      children: [
        ListTile(
          title: Text("Home", style: TextStyle(color: Colors.white)),
          onTap: onTapHome,
        ),
        ListTile(
          title: Text("Search", style: TextStyle(color: Colors.white)),
          onTap: onTap1,
        ),
        ListTile(
          title: Text("Settings", style: TextStyle(color: Colors.white)),
          onTap: onTap2,
        ),
        ListTile(
          title: Text("Profile", style: TextStyle(color: Colors.white)),
          onTap: onTap3,
        ),
        ListTile(
          title: Text("Logout", style: TextStyle(color: Colors.red)),
          onTap: onTap4,
        ),
      ],
    ),
  );
}
