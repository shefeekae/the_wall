import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_wall/components/my_button.dart';
import 'package:the_wall/components/my_textfield.dart';
import 'package:the_wall/provider/toggle_pages.dart';

class LoginPage extends StatelessWidget {
  LoginPage({
    super.key,
  });

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  //Sign in user
  void signIn(BuildContext context) async {
    //show loading circle
    showDialog(
      context: context,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    //try loging in user
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      //pop the loading circle
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      //pop the loading circle
      Navigator.pop(context);
      //display error message
      showDialogueMessage(e.code, context);
    }
  }

  //display a dialogue message
  void showDialogueMessage(String message, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
          child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //logo
              const Icon(
                Icons.lock,
                size: 50,
              ),

              const SizedBox(
                height: 50,
              ),
              //Welcome back message
              const Text(
                'Welcome back',
                style: TextStyle(
                  fontSize: 30,
                ),
              ),

              const SizedBox(
                height: 25,
              ),
              //email text field
              MyTextField(
                  controller: emailController,
                  obscureText: false,
                  hintText: "Email"),

              const SizedBox(
                height: 10,
              ),

              //password text field
              MyTextField(
                  controller: passwordController,
                  obscureText: true,
                  hintText: "Password"),

              const SizedBox(
                height: 10,
              ),

              //sign in  button
              MyButton(onTap: () => signIn(context), label: "Sign In"),
              const SizedBox(
                height: 25,
              ),

              //go to register page
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Not a member ?",
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  TextButton(
                      onPressed: () =>
                          Provider.of<TogglePages>(context, listen: false)
                              .togglePages(),
                      child: const Text('Register now')),
                ],
              )
            ],
          ),
        ),
      )),
    );
  }
}
