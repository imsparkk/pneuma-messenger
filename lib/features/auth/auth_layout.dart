import 'package:flutter/material.dart';
import 'package:pneuma_messenger/features/auth/auth_service.dart';
import 'package:pneuma_messenger/features/auth/presentation/pages/auth_page.dart';
import 'package:pneuma_messenger/features/home/chats/presentation/pages/chats_page.dart';


class AuthLayout extends StatelessWidget{
  const AuthLayout({
    super.key,
    this.pageIfNotConnected,
  });

  final Widget? pageIfNotConnected;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: authService.value.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final user = snapshot.data;
          if (user == null) {
            return pageIfNotConnected ?? AuthPage();
          } else {
            return ChatsPage();
          }
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                backgroundColor: Color.fromARGB(252, 18, 19, 22),
                ),
            ),
          );
        }
      },
      );
  }
}