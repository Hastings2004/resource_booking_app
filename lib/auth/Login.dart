import 'package:flutter/material.dart';
import 'package:resource_booking_app/auth/ForgetPassword.dart';
import 'package:resource_booking_app/components/Button.dart';
import 'package:resource_booking_app/components/TextField.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:resource_booking_app/users/Home.dart';

class LoginScreen extends StatefulWidget {

  final VoidCallback showRegisterPage;

  const LoginScreen ({super.key, 
  required this.showRegisterPage
  });

  @override
  State<LoginScreen> createState() => __LoginScreenState();
}

class __LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController(); 
  final TextEditingController _passwordController = TextEditingController();
  
  Future loginUser() async {
    // Implement login functionality here

    if(_emailController.text.isEmpty || _passwordController.text.isEmpty){
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

    try{
      showDialog(
        context: context, 
        barrierDismissible: false,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      );      

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(), 
        password: _passwordController.text.trim()
      );

      Navigator.pop(context);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Home()), // Replace HomeScreen() with your actual home screen widget
      );

    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      
      if (e.code == 'user-not-found') {
        wrongEmailMessage();
      } else if (e.code == 'wrong-password') {
        wrongPasswordMessage();
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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

   void emptyFieldMessage(){
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
   }

  void wrongEmailMessage(){
    showDialog(
        context: context, 
        builder: (context) {
          return AlertDialog(
            content: const Text("Wrong Email"),
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

   void wrongPasswordMessage(){
    showDialog(
        context: context, 
        builder: (context) {
          return AlertDialog(
            content: const Text("Password is incorrect"),
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Image.asset(
                "images/logo.png",
                height: 100
              ),
              const SizedBox(height: 20),
              const Text(
                "Resource Booking App",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 17, 105, 20)
                ),
              ),
              const SizedBox(height: 20),
              Text('Login', style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 17, 105, 20)
              ),),     
              const SizedBox(height: 20),
              MyTextField(
                hintText: "Email", 
                controller: _emailController, 
                obscureText: false
              ),     

              const SizedBox(height: 10),  


               MyTextField(
                hintText: "Password",
                controller: _passwordController, 
                obscureText: true
              ), 

              const SizedBox(height: 10), 

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child:  Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: (){
                        Navigator.push(
                          context, 
                          MaterialPageRoute(
                            builder: (context) => Forgetpassword()),);
                      } ,
                      child:  Text(
                      "Forget password?",
                      style: TextStyle(
                        color: const Color.fromARGB(255, 17, 90, 20),
                        fontSize: 16
                      ),
                    ),
                    ),
                      
                  ],
                ),
                ),

              const SizedBox(height: 10),

              MyButton(onTap: loginUser)  ,

              const SizedBox(height: 10),

              GestureDetector(
                  onTap: widget.showRegisterPage,
                  child: Text(
                    "Don't have an account? Register now",
                    style: TextStyle(
                      color: Colors.green[700],
                      fontSize: 16
                  
                    )),
                )
  
            ],
          ),
        )),
    );
  }

 
}