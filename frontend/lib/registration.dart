import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/applogo.dart';
import 'package:frontend/loginPage.dart'; // ✅ Correct import
import 'package:frontend/config.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  
  bool _isNotValidate = false;
  bool _isLoading = false;
  bool _obscurePassword = true;

  void registerUser() async {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      if (!isEmailValid(emailController.text)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a valid email'))
        );
        return;
      }

      var requestBody = {
        "email": emailController.text,
        "password": passwordController.text
      };

      setState(() {
        _isLoading = true;
      });

      try {
        var response = await http.post(
          Uri.parse(Config.registration),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(requestBody),
        );

        var jsonResponse = jsonDecode(response.body);

        if (jsonResponse['status']) {
          // Navigate to LoginPage instead of SignInPage
          if (!mounted) return;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage())
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registration failed. Please try again.'))
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred: $e'))
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        _isNotValidate = true;
      });
    }
  }

  bool isEmailValid(String email) {
    return RegExp(r"^[a-zA-Z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,4}$").hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0XFFF95A3B), Color(0XFFF96713)],
              begin: Alignment.topLeft,
              end: Alignment.bottomCenter,
              stops: [0.0, 0.8],
              tileMode: TileMode.mirror,
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const CommonLogo(),
                  HeightBox(10),
                  "CREATE YOUR ACCOUNT".text.size(22).yellow100.make(),

                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      errorStyle: const TextStyle(color: Colors.white),
                      errorText: _isNotValidate ? "Enter Proper Info" : null,
                      hintText: "Email",
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0))
                      ),
                    ),
                  ).p4().px24(),

                  TextField(
                    controller: passwordController,
                    obscureText: _obscurePassword,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      errorStyle: const TextStyle(color: Colors.white),
                      errorText: _isNotValidate ? "Enter Proper Info" : null,
                      hintText: "Password",
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0))
                      ),
                      prefixIcon: IconButton(
                        icon: const Icon(Icons.password),
                        onPressed: () {
                          String passGen = generatePassword();
                          passwordController.text = passGen;
                          setState(() {});
                        },
                      ),
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.copy),
                            onPressed: () {
                              final data = ClipboardData(text: passwordController.text);
                              Clipboard.setData(data);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Password copied!'))
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility_off : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ).p4().px24(),

                  HStack([
                    GestureDetector(
                      onTap: registerUser,
                      child: _isLoading 
                        ? const CircularProgressIndicator(color: Colors.white)
                        : VxBox(
                            child: "Register".text.white.makeCentered().p16()
                          ).green600.roundedLg.make().px16().py16(),
                    ),
                  ]),

                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginPage())
                      );
                    },
                    child: HStack([
                      "Already Registered?".text.make(),
                      " Sign In".text.white.make()
                    ]).centered(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

String generatePassword() {
  String upper = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  String lower = 'abcdefghijklmnopqrstuvwxyz';
  String numbers = '1234567890';
  String symbols = '!@#\$%^&*()<>,./';
  String password = '';
  int passLength = 20;
  String seed = upper + lower + numbers + symbols;
  List<String> list = seed.split('').toList();
  Random rand = Random();

  for (int i = 0; i < passLength; i++) {
    int index = rand.nextInt(list.length);
    password += list[index];
  }
  return password;
}
