import 'package:flutter/material.dart';
import 'package:pneuma_messenger/features/auth/presentation/widgets/auth_textfield.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool passwordVisible = false;

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

          Center(child: SizedBox(width: 400, child: LoginTextField())),

          SizedBox(height: 15),

          Center(
            child: SizedBox(
              width: 400,
              child: RegisterTextField(passwordVisible, () {
                setState(() {
                  passwordVisible = !passwordVisible;
                });
              }),
            ),
          ),

          SizedBox(height: 15),

          Center(
            child: SizedBox(
              width: 400,
              child: RegisterTextField(passwordVisible, () {
                setState(() {
                  passwordVisible = !passwordVisible;
                });
              }),
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
            onPressed: () {},
          ),
          TextButton(
            child: Text(
              "Есть учетная запись? Авторизуйтесь!",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
