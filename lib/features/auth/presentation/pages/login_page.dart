import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pneuma_messenger/features/auth/auth_service.dart';
import 'package:pneuma_messenger/features/auth/presentation/widgets/auth_textfield.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _RegisterPageState();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
}

class _RegisterPageState extends State<LoginPage> {
  bool passwordVisible = false;
  String errorMessage = "";
  bool isLoading = false;

  void SignIn() async {
    if (widget.emailController.text.isEmpty || widget.passwordController.text.isEmpty) {
      setState(() {
        errorMessage = "Заполните все поля";
      });
      return;
    }
    setState(() {
      isLoading = true;
      errorMessage = "";
    });
    try {
      await authService.value.signInWithEmailAndPassword(
        widget.emailController.text, widget.passwordController.text
        );
        Navigator.of(context).pushReplacementNamed('/');
    } on FirebaseAuthException catch (e) {
        if (mounted) {
          setState(() {
            errorMessage = e.message ?? "Произошла ошибка при входе!";
          });
        }
        }
    catch (e) {
      if (mounted) {
        setState(() {
          errorMessage = "Неизвестная ошибка: $e";
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    passwordVisible = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(252, 18, 19, 22),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Pneuma", style: TextStyle(color: Colors.white, fontSize: 50)),

          SizedBox(height: 15),

          Center(
            child: SizedBox(
              width: 350, 
              child: EmailTextField(widget.emailController)
              )
          ),

          SizedBox(height: 15),

          Center(
            child: SizedBox(
              width: 350,
              child: PasswordTextField(passwordVisible, () {
                setState(() {
                  passwordVisible = !passwordVisible;
                });
              }, widget.passwordController),
            ),
          ),

          SizedBox(height: 15),

          ElevatedButton(
            onPressed: isLoading ? null : () {
              SignIn();
            },
            child: isLoading
              ? CircularProgressIndicator(color: Colors.white)
              : Text(
                  "Sign in",
                  style: TextStyle(
                    color: Colors.black
                  ),
                ),
          ),

          if (errorMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                errorMessage,
                style: TextStyle(color: Colors.red),
              ),
            ),
          TextButton(
            child: Text(
              "Нет учетной записи? Регистрируйся!",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/register_page');
            },
          ),
        ],
      ),
    );
    }
}