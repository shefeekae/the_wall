import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_wall/auth/auth.dart';
import 'package:the_wall/firebase_options.dart';
import 'package:the_wall/provider/textfield_provider.dart';
import 'package:the_wall/provider/toggle_like.dart';
import 'package:the_wall/provider/toggle_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => TextFieldProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => TogglePages(),
      ),
      ChangeNotifierProvider(
        create: (context) => ToggleLike(),
      ),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(),
      debugShowCheckedModeBanner: false,
      home: const AuthPage(),
    );
  }
}
