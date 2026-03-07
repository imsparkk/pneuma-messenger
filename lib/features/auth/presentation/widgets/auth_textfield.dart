import 'package:flutter/material.dart';

class LoginTextField extends StatelessWidget {
  const LoginTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Icon(Icons.person, color: Colors.black, size: 30),
        prefixIconConstraints: BoxConstraints(minWidth: 60),
        hintText: "Login",
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          borderSide: BorderSide(style: BorderStyle.none),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          borderSide: BorderSide(
            width: 1,
            color: Colors.red,
            style: BorderStyle.solid,
          ),
        ),
      ),
    );
  }
}

TextField RegisterTextField(bool passwordVisible, VoidCallback onPressed) {
    return TextField(
                  maxLength: 25,
                obscureText: passwordVisible,
                decoration: InputDecoration(
                  counterText: "",
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.1),
                  prefixIcon: Icon(
                    Icons.lock, 
                    color: Colors.white,
                    size: 30,
                    ),
                  prefixIconConstraints: BoxConstraints(minWidth: 60),
                  hintText: "Password",
                  hintStyle: TextStyle(color: Colors.white),
                  suffixIcon: IconButton(
                    padding: EdgeInsets.only(right: 10),
                    iconSize: 30,
                    icon: Icon(
                      color: Colors.white,
                      passwordVisible ? Icons.visibility
                      : Icons.visibility_off,),
                      onPressed: onPressed
                    ),

                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      borderSide: BorderSide(color: Colors.white, width: 1.5)
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    borderSide: BorderSide(color: Colors.white, width: 1)
                  )

                ),
                );
  }