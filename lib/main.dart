import 'package:flutter/material.dart';
import 'package:pneuma_messenger/features/auth/presentation/pages/login_page.dart';
import 'package:pneuma_messenger/features/auth/presentation/pages/register_page.dart';


void main() => runApp(
  MaterialApp(
    initialRoute: "/",
    routes: {
      "/": (context) => RegisterPage(),
      "/login_page": (context) => LoginPage(),
    },
    )
);

