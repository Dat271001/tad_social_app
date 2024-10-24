import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tad_social_media_app/components/my_button.dart';
import 'package:tad_social_media_app/components/my_textfield.dart';
import 'package:tad_social_media_app/helper/helper_functions.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;

  LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  void login() async{
    showDialog(context: context, builder:(context) => Center(
      child: CircularProgressIndicator(),
    ));
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: emailController.text, password: passwordController.text);
      if (context.mounted) Navigator.pop(context);
    }
    on FirebaseAuthException catch(e){
      Navigator.pop(context);
      displayMessageToUser(e.code, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
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
                text: "Login",
                onTap: login,
            ),
            const SizedBox(height: 25),
            //don't have an account?
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                    "Don't hava an account?",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
                GestureDetector(
                  onTap: widget.onTap,
                    child: const Text(
                        " Register Here",
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
    );
  }
}
