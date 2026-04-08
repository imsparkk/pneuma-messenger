import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pneuma_messenger/features/auth/auth_service.dart';
import 'package:pneuma_messenger/features/home/drawer/drawer.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
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
          SnackBar(content: Text(e.message ?? "Произошла ошибка при выходе!")),
        );
      }
    }
  }

  Future<void> _updateDisplayName() async {
    final newName = _nameController.text.trim();
    if (newName.isEmpty) return;

    try {
      await authService.value.updateUsername(newName);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Имя успешно обновлено")),
        );
        _nameController.clear();
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Ошибка обновления имени: $e")),
        );
      }
    }
  }

  Future<void> _changePassword() async {
    final currentPassword = _currentPasswordController.text.trim();
    final newPassword = _newPasswordController.text.trim();

    if (currentPassword.isEmpty || newPassword.isEmpty) return;

    try {
      await authService.value.resetPasswordFromCurrentPassword(currentPassword, newPassword);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Пароль успешно изменен")),
        );
        _currentPasswordController.clear();
        _newPasswordController.clear();
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Ошибка изменения пароля: $e")),
        );
      }
    }
  }

  Future<void> _deleteAccount() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color.fromARGB(255, 18, 19, 22),
        title: const Text("Удаление аккаунта", style: TextStyle(color: Colors.white)),
        content: const Text(
          "Вы уверены, что хотите удалить свой аккаунт? Это действие нельзя отменить.",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("Отмена", style: TextStyle(color: Colors.white70)),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text("Удалить"),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await authService.value.deleteAccount();
        if (mounted) {
          Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Ошибка удаления аккаунта: $e")),
          );
        }
      }
    }
  }

  Future<void> _sendPasswordResetEmail() async {
    final user = authService.value.currentUser;
    if (user?.email == null) return;

    try {
      await authService.value.sendPasswordResetEmail(user!.email!);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Письмо для сброса пароля отправлено на вашу почту")),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Ошибка отправки письма: $e")),
        );
      }
    }
  }

  void _showUpdateNameDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color.fromARGB(255, 18, 19, 22),
        title: const Text("Изменить имя", style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: _nameController,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: "Введите новое имя",
            hintStyle: TextStyle(color: Colors.white70),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white70),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blue),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Отмена", style: TextStyle(color: Colors.white70)),
          ),
          TextButton(
            onPressed: _updateDisplayName,
            child: const Text("Сохранить", style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color.fromARGB(255, 18, 19, 22),
        title: const Text("Изменить пароль", style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _currentPasswordController,
              obscureText: true,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: "Текущий пароль",
                hintStyle: TextStyle(color: Colors.white70),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _newPasswordController,
              obscureText: true,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: "Новый пароль",
                hintStyle: TextStyle(color: Colors.white70),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Отмена", style: TextStyle(color: Colors.white70)),
          ),
          TextButton(
            onPressed: _changePassword,
            child: const Text("Изменить", style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
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
        }
      ),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 18, 19, 22),
        title: const Text("Настройки", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            "Профиль",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.person, color: Colors.white),
            title: const Text("Изменить имя", style: TextStyle(color: Colors.white)),
            subtitle: const Text("Изменить отображаемое имя", style: TextStyle(color: Colors.white70)),
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 16),
            onTap: _showUpdateNameDialog,
          ),
          const Divider(color: Colors.white24),
          ListTile(
            leading: const Icon(Icons.lock, color: Colors.white),
            title: const Text("Изменить пароль", style: TextStyle(color: Colors.white)),
            subtitle: const Text("Изменить пароль аккаунта", style: TextStyle(color: Colors.white70)),
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 16),
            onTap: _showChangePasswordDialog,
          ),
          const Divider(color: Colors.white24),
          ListTile(
            leading: const Icon(Icons.email, color: Colors.white),
            title: const Text("Сбросить пароль", style: TextStyle(color: Colors.white)),
            subtitle: const Text("Отправить письмо для сброса пароля", style: TextStyle(color: Colors.white70)),
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 16),
            onTap: _sendPasswordResetEmail,
          ),
          const SizedBox(height: 32),
          const Text(
            "Удаление аккаунта",
            style: TextStyle(
              color: Colors.red,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.delete_forever, color: Colors.red),
            title: const Text("Удалить аккаунт", style: TextStyle(color: Colors.red)),
            subtitle: const Text("Удалить аккаунт навсегда", style: TextStyle(color: Colors.white70)),
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.red, size: 16),
            onTap: _deleteAccount,
          ),
        ],
      ),
    );
  }
}
