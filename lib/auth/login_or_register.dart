import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_wall/pages/login_page.dart';
import 'package:the_wall/pages/register_page.dart';
import 'package:the_wall/provider/toggle_pages.dart';

class LoginOrRegister extends StatelessWidget {
  const LoginOrRegister({super.key});

  @override
  Widget build(BuildContext context) {
    if (Provider.of<TogglePages>(context).showLogin) {
      return LoginPage();
    } else {
      return RegisterPage();
    }
  }
}
