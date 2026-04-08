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
          title: Text("Чаты", style: TextStyle(color: Colors.white)),
          onTap: onTapHome,
        ),
        ListTile(
          title: Text("Поиск", style: TextStyle(color: Colors.white)),
          onTap: onTap1,
        ),
        ListTile(
          title: Text("Настройки", style: TextStyle(color: Colors.white)),
          onTap: onTap2,
        ),
        ListTile(
          title: Text("Профиль", style: TextStyle(color: Colors.white)),
          onTap: onTap3,
        ),
        ListTile(
          title: Text("Выход", style: TextStyle(color: Colors.red)),
          onTap: onTap4,
        ),
      ],
    ),
  );
}
