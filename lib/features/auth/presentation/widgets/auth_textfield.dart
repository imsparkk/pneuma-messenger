import 'package:flutter/material.dart';

class LoginTextField extends StatelessWidget {
  const LoginTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: TextStyle(color: Colors.white),
      cursorColor: Colors.white,
      cursorOpacityAnimates: true,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white.withAlpha(25),
        prefixIcon: Icon(Icons.person, color: Colors.white, size: 30),
        prefixIconConstraints: BoxConstraints(minWidth: 60),
        hintText: "Login",
        hintStyle: TextStyle(
          color: Colors.white70
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          borderSide: BorderSide(color: Colors.white, width: 1)
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          borderSide: BorderSide(color: Colors.white, width: 1)
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

TextField PasswordTextField(bool passwordVisible, VoidCallback onPressed) {
    return TextField(
                style: TextStyle(color: Colors.white),
                cursorColor: Colors.white,
                cursorOpacityAnimates: true,
                maxLength: 25,
                obscureText: passwordVisible,
                enableSuggestions: false,
                autocorrect: false,
                decoration: InputDecoration(
                  counterText: "",
                  filled: true,
                  fillColor: Colors.white.withAlpha(25),
                  prefixIcon: Icon(
                    Icons.lock, 
                    color: Colors.white,
                    size: 30,
                    ),
                  prefixIconConstraints: BoxConstraints(minWidth: 60),
                  hintText: "Password",
                  hintStyle: TextStyle(color: Colors.white70),
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
                      borderSide: BorderSide(color: Colors.white, width: 1)
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    borderSide: BorderSide(color: Colors.white, width: 1)
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