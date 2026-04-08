import 'package:flutter/material.dart';
import 'package:pneuma_messenger/features/auth/auth_layout.dart';
import 'package:pneuma_messenger/features/auth/presentation/pages/login_page.dart';
import 'package:pneuma_messenger/features/auth/presentation/pages/register_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pneuma_messenger/features/home/chats/presentation/pages/chat_page.dart';
import 'package:pneuma_messenger/features/home/chats/presentation/pages/chats_page.dart';
import 'package:pneuma_messenger/features/home/drawer/profile/pages/profile.dart';
import 'package:pneuma_messenger/features/home/drawer/search/pages/search_page.dart';
import 'package:pneuma_messenger/features/home/drawer/settings/pages/settings.dart';
import 'package:pneuma_messenger/firebase_options.dart';
import 'package:pneuma_messenger/features/auth/auth_service.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    ChangeNotifierProvider.value(
      value: authService,
      child: App(),
    )
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthLayout(),
        '/register_page': (context) => RegisterPage(),
        '/login_page': (context) => LoginPage(),
        '/chats_page': (context) => ChatsPage(),
        '/profile_page': (context) => ProfilePage(),
        '/settings_page': (context) => SettingsPage(),
        '/search_page': (context) => SearchPage(),
        '/chat_page': (context) => ChatPage(),
      },
    );
  }
}