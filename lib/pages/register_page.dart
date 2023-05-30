import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_wall/components/my_button.dart';
import 'package:the_wall/components/my_textfield.dart';
import 'package:the_wall/provider/toggle_pages.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({
    super.key,
  });

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void signUp(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    //make sure passwords match
    if (passwordController.text != confirmPasswordController.text) {
      //pop the loading circle
      Navigator.pop(context);

      showDialogueMessage("Passwords doesn't match", context);
    } else {
      //try creating the user
      try {
        //create the user

        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: emailController.text, password: passwordController.text);

        //after creating the user, create a new document in cloud firestore called 'Users'

        FirebaseFirestore.instance
            .collection('Users')
            .doc(userCredential.user!.email)
            .set({
          'username': emailController.text.split('@')[0], //initial username
          'bio': 'Empty bio' // intially empty bio
        });

        //pop the loading circle
        Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        //pop the loading circle
        Navigator.pop(context);
        //show error message
        showDialogueMessage(e.code, context);
      }
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
                'Lets create an account for you',
                style: TextStyle(
                  fontSize: 20,
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

              //confirmpassword text field
              MyTextField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  hintText: "Confirm Password"),

              const SizedBox(
                height: 10,
              ),

              //sign up  button
              MyButton(onTap: () => signUp(context), label: "Sign Up"),
              const SizedBox(
                height: 25,
              ),

              //go to register page
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account ?",
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  TextButton(
                      onPressed: () =>
                          Provider.of<TogglePages>(context, listen: false)
                              .togglePages(),
                      child: const Text('Login now')),
                ],
              )
            ],
          ),
        ),
      )),
    );
  }
}
