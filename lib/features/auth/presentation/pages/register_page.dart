import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pneuma_messenger/features/auth/auth_service.dart';
import 'package:pneuma_messenger/features/auth/presentation/widgets/auth_textfield.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordRepeatController = TextEditingController();
}

class _RegisterPageState extends State<RegisterPage> {
  bool passwordVisible = false;
  String errorMessage = "";
  
  void register() async {
    if (widget.emailController.text.isEmpty || 
        widget.passwordController.text.isEmpty ||
        widget.passwordRepeatController.text.isEmpty) {
      setState(() {
        errorMessage = "Заполните все поля";
      });
      return;
    }

    if (widget.passwordController.text != widget.passwordRepeatController.text) {
      setState(() {
        errorMessage = "Passwords don't match";
      });
      return;
    }

    try {
      await authService.value.signUpWithEmailAndPassword(
        widget.emailController.text,
        widget.passwordController.text,
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Пользователь успешно зарегистрирован!")),
        );
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        setState(() {
          errorMessage = e.message ?? "Произошла ошибка при регистрации!";
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
              child: EmailTextField(widget.emailController),
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

          Center(
            child: SizedBox(
              width: 350,
              child: PasswordTextField(passwordVisible, () {
                setState(() {
                  passwordVisible = !passwordVisible;
                });
              }, widget.passwordRepeatController),
            ),
          ),
          
          SizedBox(height: 15),

          ElevatedButton(
            child: Text(
              "Sign up",
              style: TextStyle(
                backgroundColor: Colors.white,
                color: Colors.black,
              ),
            ),
            onPressed: () {
              register();
            },
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
              "Есть учетная запись? Авторизуйтесь!",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login_page');
            },
          ),
        ],
      ),
    );
  }
}
