import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:the_wall/auth/login_or_register.dart';
import 'package:the_wall/pages/home_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          //user is logged in
          return HomePage();
        } else {
          //user is not logged in
          return const LoginOrRegister();
        }
      },
    );
  }
}
