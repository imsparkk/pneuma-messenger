import 'package:flutter/material.dart';
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formkey = GlobalKey<FormState>();
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _passwordVisible = false;
  
  @override
  void initState(){
    super.initState();
    _passwordVisible = false;
  }


  @override
  void dispose()
  {
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

Future<void> _login() async{
  if (_formkey.currentState!.validate()){
    setState(() {
      _isLoading = true;
    });
    try {
      await Future.delayed(const Duration(seconds: 2));
      String login = _loginController.text;
      String password = _passwordController.text;

      if(login == "admin" && password == 'password')
      {
        if(mounted){
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Вход выполнен успешно!!"),
            backgroundColor: Color(0x00022866),
            ),
          );
        }
      }
      else{
        throw Exception("Неверный Логин или пароль!");
      }
    }
    catch (e){
      if (mounted){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка входа: ${e.toString()}'),
          backgroundColor: Color(0x00022866),
          ),
        );
      }
    }
    finally {
      if (mounted){
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}

String? _validateLogin(String? value){
  if (value == null || value.isEmpty){
    return 'Введите Login';
  }
  if (value.length < 6){
    return 'Логин должен содержать минимум 6 символов';
  }
  if(value.length > 20){
    return 'Логин не может содержать максимум 20 символов';
  }
  final loginRegex = RegExp(r'^[a-zA-Z0-9_]+$');
  if (!loginRegex.hasMatch(value)){
    return 'Логин может содержать только буквы, цифры и _';
  }
  return null;
}

String? _validatePassword(String? value){
  if (value == null || value.isEmpty){
    return 'Введите пароль';
  }
  if (value.length < 6){
    return 'Пароль должен содержать минимум 6 символов';
  }
  if(value.length > 20){
    return 'Пароль должен содержать максимум 20 символов';
  }
  return null;
}

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0x00022866),
      body: Center( 
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Pneuma",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: SizedBox(
                      width: 400, 
                      child: TextFormField(
                        controller: _loginController,
                        maxLength: 25,
                        decoration: InputDecoration(
                          counterText: "", 
                          labelText: 'Логин',
                          labelStyle: const TextStyle(color: Colors.white70),
                          hintText: 'Введите логин',
                          hintStyle: const TextStyle(color: Colors.white54),
                          prefixIcon: const Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 30,
                          ),
                          prefixIconConstraints: const BoxConstraints(minWidth: 60),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30), 
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(color: Colors.white, width: 2),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(color: Colors.white, width: 1),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(color: Colors.white, width: 2),
                          ),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.1), 
                        ),
                        style: const TextStyle(color: Colors.white), 
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        validator: _validateLogin,
                        enabled: !_isLoading,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: SizedBox(
                      width: 400, 
                      child: TextFormField(
                        controller: _passwordController,
                        maxLength: 25, 
                        obscureText: !_passwordVisible, 
                        decoration: InputDecoration(
                          counterText: "", 
                          labelText: 'Пароль',
                          labelStyle: const TextStyle(color: Colors.white),
                          hintText: 'Введите пароль',
                          hintStyle: const TextStyle(color: Colors.white),
                          prefixIcon: const Icon(
                            Icons.lock,
                            color: Colors.white,
                            size: 30,
                          ),
                          prefixIconConstraints: const BoxConstraints(minWidth: 60),
                          suffixIcon: IconButton(
                            padding: const EdgeInsets.only(right: 10),
                            iconSize: 30,
                            icon: Icon(
                              _passwordVisible ? Icons.visibility : Icons.visibility_off,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30), 
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(color: Colors.white, width: 2),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(color: Colors.white, width: 1),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(color: Colors.white, width: 2),
                          ),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.1), 
                        ),
                        style: const TextStyle(color: Colors.white), 
                        textInputAction: TextInputAction.done,
                        validator: _validatePassword,
                        enabled: !_isLoading,
                        onFieldSubmitted: (_) => _login(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: SizedBox(
                      width: 120,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _login,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30), 
                          ),
                          side: const BorderSide(
                            color: Colors.white,
                            width: 1,
                          ),
                          backgroundColor:  Colors.white.withOpacity(0.1),
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: Colors.grey.shade300,
                        ),
                        child: _isLoading
                            ? CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            )
                            : const Text(
                                'Sign in',
                                style: TextStyle(
                                  fontSize: 16,
                                   fontWeight: FontWeight.w600),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                TextButton(
                  child: Text(
                    "Нет учетной записи? Зарегестрируйтесь!",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {},
                  )
         ]
        )
       )
      )
     )
    )
   );
  }
}