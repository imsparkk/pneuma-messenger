import 'package:flutter/material.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Color.fromARGB(252, 18, 19, 22),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
            Center(
              child: Text(
                "Welcome to Pneuma",
                style: TextStyle(
                  color: Colors.white,
                   fontSize: 30
                   )
                ),
            ),

            SizedBox(height: 15,),
            
            ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/register_page');
                },
                child: Text(
                  "Create an account",
                  style: TextStyle(
                    backgroundColor: Colors.white,
                    color: Colors.black,
                  ),
                ),
              ),

              SizedBox(height: 5,),

              ElevatedButton(onPressed: () {
                Navigator.pushReplacementNamed(context, '/login_page');
              }, child: Text(
                "Sign in",
                style: TextStyle(
                  backgroundColor: Colors.white,
                  color: Colors.black,
                ),
              )),
        ],
      )
    );
  }
}