import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/dashboard.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:frontend/applogo.dart';
import 'package:frontend/config.dart';
import 'package:frontend/registration.dart';
import 'package:velocity_x/velocity_x.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState(); // ❗️ Made public
}

class LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isNotValidate = false;
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _initSharedPref();
  }

  void _initSharedPref() async {
    _prefs = await SharedPreferences.getInstance();
  }

  void _loginUser() async {
    if (_emailController.text.isNotEmpty && _passwordController.text.isNotEmpty) {
      var regBody = {
        "email": _emailController.text,
        "password": _passwordController.text
      };

      var response = await http.post(
        Uri.parse(Config.login),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(regBody)
      );

      if (!mounted) return; // ✅ Fix for context usage after async

      var jsonResponse = jsonDecode(response.body);

      if (jsonResponse['status']) {
        var myToken = jsonResponse['token'];
        await _prefs.setString('token', myToken);

        if (!mounted) return; // ✅ Safety after another async call
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Dashboard(token: myToken)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid email or password")),
        );
      }
    } else {
      setState(() {
        _isNotValidate = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
                "Email Sign-In".text.size(22).yellow100.make(),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Email",
                    errorText: _isNotValidate ? "Enter proper info" : null,
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                  ),
                ).p4().px24(),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Password",
                    errorText: _isNotValidate ? "Enter proper info" : null,
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                  ),
                ).p4().px24(),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[600],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  ),
                  onPressed: _loginUser,
                  child: "Login".text.white.make(), // ✅ child is last
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 50,
        color: Colors.lightBlue,
        child: TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const RegistrationPage()),
            );
          },
          child: "Create a new Account...! Sign Up".text.white.make(), // ✅ child last
        ),
      ),
    );
  }
}
