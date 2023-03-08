// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../services/auth.dart';

class DriverLogin extends StatefulWidget {
  const DriverLogin({super.key});

  @override
  State<DriverLogin> createState() => _DriverLoginState();
}

class _DriverLoginState extends State<DriverLogin> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xff24688e)),
        toolbarHeight: 75,
        leadingWidth: 75,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text(
                'Login',
                style: TextStyle(
                  fontSize: 45,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Gabriela-Regular',
                ),
              ),
              SizedBox(height: size.height * 0.05),
              buildEmail(),
              SizedBox(height: size.height * 0.03),
              buildPassword(),
              SizedBox(height: size.height * 0.04),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 15),
                width: double.infinity,
                height: 75,
                child: ElevatedButton(
                  onPressed: () => _logInDriver(context),
                  child: const Text(
                    'LOGIN',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    "Don't have an account? ",
                    style: TextStyle(fontSize: 15),
                  ),
                  GestureDetector(
                    onTap: () => GoRouter.of(context).go('/driverSignup'),
                    child: const Text(
                      'Signup',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
              Image(
                image: const AssetImage('assets/images/login.png'),
                height: size.height * 0.4,
                fit: BoxFit.cover,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildEmail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 6,
              ),
            ],
          ),
          height: 60,
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            controller: emailController,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 20,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              icon: Icon(
                Icons.email,
                color: Color(0xff5ac18e),
                size: 30,
              ),
              hintText: 'Email',
            ),
          ),
        ),
      ],
    );
  }

  Widget buildPassword() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 6,
              ),
            ],
          ),
          height: 60,
          child: TextField(
            obscureText: true,
            controller: passwordController,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 20,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              icon: Icon(
                Icons.lock,
                color: Color(0xff5ac18e),
                size: 30,
              ),
              hintText: 'Password',
            ),
          ),
        ),
      ],
    );
  }

//-------------------------------------------------

  void _logInDriver(BuildContext context) async {
    if (emailController.text.isEmpty) {
      print('email empty');
    } else if (passwordController.text.isEmpty) {
      //show error
    }
    String result = await AuthMethods().logInDriver(
      email: emailController.text,
      password: passwordController.text,
    );
    if (result == 'success') {
      print(result);
      GoRouter.of(context).go('/driver');
    } else {
      print(result);
      //showSnackBar(result, context);
    }
  }
}
