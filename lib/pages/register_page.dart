import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tad_social_media_app/components/my_button.dart';
import 'package:tad_social_media_app/components/my_textfield.dart';
import 'package:tad_social_media_app/helper/helper_functions.dart';
class RegisterPage extends StatefulWidget {
  final void Function()? onTap;

  RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController usernameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController confirmPasswordController = TextEditingController();

  void register() async {
    showDialog(
        context: context,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
    );

    if (passwordController.text != confirmPasswordController.text){
      Navigator.pop(context);
      displayMessageToUser("Passwords don't match!", context);
    }
    else{
      try{
        UserCredential? userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: emailController.text, password: passwordController.text,);
        createUserDocument(userCredential);
        Navigator.pop(context);
      } on FirebaseAuthException catch(e){
        Navigator.pop(context);
        displayMessageToUser(e.code, context);
      }
    }
  }
  Future<void> createUserDocument(UserCredential? userCredential) async{
    if (userCredential != null &&  userCredential.user != null){
      await FirebaseFirestore.instance.collection("Users").doc(userCredential.user!.email).set({
        'email' : userCredential.user!.email,
        'username': usernameController.text,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //logo
              Icon(
                Icons.person,
                size: 80,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              const SizedBox(height: 25),
              //app name
              Text(
                "T A D",
                style: TextStyle(fontSize: 20),
              ),
              MyTextfield(
                hintText: "Username",
                obscureText:false,
                controller: usernameController,
              ),
              const SizedBox(height: 25),
              //email textfield
              MyTextfield(
                hintText: "Email",
                obscureText:false,
                controller: emailController,
              ),
              const SizedBox(height: 25),
              //password textfield
              MyTextfield(
                hintText: "Password",
                obscureText:true,
                controller: passwordController,
              ),
              const SizedBox(height: 25),
              MyTextfield(
                hintText: "Confirm Password",
                obscureText:true,
                controller: confirmPasswordController,
              ),
              const SizedBox(height: 25),
              //forgot password
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Forgot password",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              //sign in button
              MyButton(
                text: "Register",
                onTap: register,
              ),
              const SizedBox(height: 25),
              //don't have an account?
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account ?",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: const Text(
                      " Login Here",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
