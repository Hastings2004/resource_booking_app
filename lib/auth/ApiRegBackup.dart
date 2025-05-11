//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:resource_booking_app/auth/Api.dart';
import 'package:resource_booking_app/auth/login.dart';
import 'package:resource_booking_app/components/TextField.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';

import 'package:resource_booking_app/users/Home.dart';

class Register extends StatefulWidget {
  final VoidCallback showLoginScreen;
  const Register({super.key, required this.showLoginScreen});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final regNumberController = TextEditingController();
  
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    phoneNumberController.dispose();
    regNumberController.dispose();
    super.dispose();
  }

  void signUpUser() async {
    setState(() {
      _errorMessage = null; // Clear any previous error messages
    });

    var data = {
      "name": firstNameController.text,
      "email": emailController.text,
      "password": passwordController.text,
      "password_confirmation": confirmPasswordController.text,
      "phone_number": phoneNumberController.text,
      "reg_number": regNumberController.text,
      "last_name": lastNameController.text,
    };

    var res = await CallApi().postData(data, 'register');
    var body = json.decode(res.body);

    if (body['success'] == true) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Home(),
        ),
      );
    } else {
      // Handle registration error and show all validation messages
      if (body.containsKey('errors')) {
        Map<String, dynamic> errors = body['errors'];
        String errorMessage = "";
        errors.forEach((key, value) {
          errorMessage += "${value.join('\n')}\n";
        });
        setState(() {
          _errorMessage = errorMessage.trim();
        });
      } else if (body.containsKey('message')) {
        setState(() {
          _errorMessage = body['message'];
        });
      } else {
        setState(() {
          _errorMessage = "Registration failed. Please try again.";
        });
      }
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Registration Failed"),
            content: Text(_errorMessage!),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("OK"),
              )
            ],
          );
        },
      );
    }
  }
  String? _errorMessage;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView( // Wrap the Column with SingleChildScrollView
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0), // Add padding for better visual appearance
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Image.asset(
                    "images/logo.png",
                    height: 100,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Resource Booking App",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 17, 105, 20)
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Create Acccount",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 17, 105, 20),
                    ),
                  ),
                  const SizedBox(height: 10),
                  MyTextField(
                    controller: firstNameController,
                    obscureText: false,
                    hintText: "First name",
                  ),
                  const SizedBox(height: 10),
                  MyTextField(
                    controller: lastNameController,
                    obscureText: false,
                    hintText: "Last name",
                  ),
                  const SizedBox(height: 10),
                  MyTextField(
                    controller: regNumberController,
                    obscureText: false,
                    hintText: "Registration number",
                  ),
                  const SizedBox(height: 10),
                  MyTextField(
                    controller: phoneNumberController,
                    obscureText: false,
                    hintText: "Phone number",
                  ),
                  const SizedBox(height: 10),
                  MyTextField(
                    controller: emailController,
                    obscureText: false,
                    hintText: "Email",
                  ),
                  const SizedBox(height: 10),
                  MyTextField(
                    controller: passwordController,
                    obscureText: true,
                    hintText: "Password",
                  ),
                  const SizedBox(height: 10),
                  MyTextField(
                    controller: confirmPasswordController,
                    obscureText: true,
                    hintText: "Confirm password",
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: signUpUser,
                    child: Container(
                      padding: const EdgeInsets.all(25),
                      margin: const EdgeInsets.symmetric(horizontal: 25),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 17, 105, 20),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text(
                          "Register",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: widget.showLoginScreen,
                    child: Text(
                      "Already have an account? Login now",
                      style: TextStyle(color: Colors.green[700], fontSize: 16),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  } 
 
}