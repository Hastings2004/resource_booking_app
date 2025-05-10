import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:resource_booking_app/components/TextField.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  Future signUpUser() async{

    if(emailController.text.isEmpty || 
    passwordController.text.isEmpty || 
    confirmPasswordController.text.isEmpty ||
    firstNameController.text.isEmpty ||
    lastNameController.text.isEmpty ||
    phoneNumberController.text.isEmpty ||
    regNumberController.text.isEmpty
    ){
      showDialog(
        context: context, 
        builder: (context) {
          return AlertDialog(
            content: const Text("Please fill in all fields"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                }, 
                child: const Text("OK")
              )
            ],
          );
        }
      );
      return;
    }
    

    if(passwordConfirm()){

      showDialog(
        context: context, 
        barrierDismissible: false,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      ); 

      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(), 
          password: passwordController.text.trim()
        );
         // ignore: use_build_context_synchronously
         Navigator.pop(context);
        // Add user details to the database
         await addUserDetails(
          firstNameController.text.trim(), 
          lastNameController.text.trim(), 
          regNumberController.text.trim(), 
          int.parse(phoneNumberController.text.trim()), 
          emailController.text.trim()
        );

        Navigator.pop(context);
      } on FirebaseAuthException catch (e) {

        Navigator.pop(context);

        if(e.code == 'weak-password') {
          showDialog(
            context: context, 
            builder: (context) {
              return AlertDialog(
                content: const Text("Password is too weak"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    }, 
                    child: const Text("OK")
                  )
                ],
              );
            }
          );
        } else if (e.code == 'email-already-in-use') {
          showDialog(
            context: context, 
            builder: (context) {
              return AlertDialog(
                content: const Text("Email already in use"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    }, 
                    child: const Text("OK")
                  )
                ],
              );
            }
          );

        } else if (e.code == 'invalid-email') {
          showDialog(
            context: context, 
            builder: (context) {
              return AlertDialog(
                content: const Text("Invalid email"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    }, 
                    child: const Text("OK")
                  )
                ],
              );
            }
          );
        } else {
          showDialog(
            context: context, 
            builder: (context) {
              return AlertDialog(
                content: const Text("An error occurred"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    }, 
                    child: const Text("OK")
                  )
                ],
              );
            }
          );
        }        
      }
    }
  }

  Future addUserDetails(
    String firstname, 
    String lastname, 
    String regnumber, 
    int phonenumber, 
    String email) async {
    // Add user details to the database
    // You can use Firebase Firestore or any other database
    // For example:
     await FirebaseFirestore.instance.collection('users').add({
      'first name': firstname,
       'last name': lastname,
       'reg number': regnumber,
       'phone number': phonenumber,
       'email': email,
     });
    }

   bool passwordConfirm() {
    if(passwordController.text.trim() == confirmPasswordController.text.trim()){
      return true;
    }else{
      showDialog(
        context: context, 
        builder: (context) {
          return AlertDialog(
            content: const Text("Password do not match"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                }, 
                child: const Text("OK")
              )
            ],
          );
        }
      );
      return false;
    }
   }
  
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