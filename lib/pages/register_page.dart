import 'package:flutter/material.dart';


class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
   bool passwordVisible=false;
    
   @override
    void initState(){
      super.initState();
      passwordVisible=true;
    }   

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0x00022866),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Pneuma",
              style: TextStyle(
                color: Colors.white,
                fontSize: 50,
              ),
              ),

              SizedBox(height: 15,),

              Center(
                child: SizedBox(
                  width: 400,
                  child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: Icon(
                      Icons.person, 
                      color: Colors.black,
                      size: 30,
                      ),
                    prefixIconConstraints: BoxConstraints(minWidth: 60),
                    hintText: "Login",
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      borderSide: BorderSide(style: BorderStyle.none)
                    ),
                  
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      borderSide: BorderSide(width: 1, color: Colors.red, style: BorderStyle.solid)
                    )
                  ),  
                  ),
                ),
              ),

              SizedBox(height: 15,),

              Center(
                child: SizedBox(
                  width: 400,
                  child: TextField(
                    maxLength: 25,
                  obscureText: passwordVisible,
                  decoration: InputDecoration(
                    counterText: "",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: Icon(
                      Icons.lock, 
                      color: Colors.black,
                      size: 30,
                      ),
                    prefixIconConstraints: BoxConstraints(minWidth: 60),
                    hintText: "Password",
                    suffixIcon: IconButton(
                      padding: EdgeInsets.only(right: 10),
                      iconSize: 30,
                      icon: Icon(
                        color: Colors.black,
                        passwordVisible ? Icons.visibility
                        : Icons.visibility_off,),
                        onPressed: () {
                          setState(() {
                            passwordVisible = !passwordVisible;
                          });
                        },
                        
                      ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      borderSide: BorderSide(style: BorderStyle.none)
                    ),
                  
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      borderSide: BorderSide(width: 1, color: Colors.red, style: BorderStyle.solid)
                    )
                  ),  
                  ),
                ),
              ),

              SizedBox(height: 15,),

              Center(
                child: SizedBox(
                  width: 400,
                  child: TextField(
                    maxLength: 25,
                    
                  obscureText: passwordVisible,
                  decoration: InputDecoration(
                    counterText: "",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: Icon(
                      Icons.lock, 
                      color: Colors.black,
                      size: 30,
                      ),
                    prefixIconConstraints: BoxConstraints(minWidth: 60),
                    hintText: "Password",
                    suffixIcon: IconButton(
                      padding: EdgeInsets.only(right: 10),
                      iconSize: 30,
                      icon: Icon(
                        color: Colors.black,
                        passwordVisible ? Icons.visibility
                        : Icons.visibility_off,),
                        onPressed: () {
                          setState(() {
                            passwordVisible = !passwordVisible;
                          });
                        },
                        
                      ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      borderSide: BorderSide(style: BorderStyle.none)
                    ),
                  
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      borderSide: BorderSide(width: 1, color: Colors.red, style: BorderStyle.solid)
                    )
                  ),  
                  ),
                ),
              ),

              SizedBox(height: 15,),

              ElevatedButton(
                child: Text(
                  "Sign in",
                  style: TextStyle(
                  backgroundColor: Colors.white,
                  color: Colors.black
                  ),
                ),
                onPressed: () {},
                ),
                TextButton(
                  child: Text(
                    "Есть учетная запись? Авторизуйтесь!",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {},
                  )
          ],
      ),
    );
  }
}
