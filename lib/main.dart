import 'dart:io';

import 'package:flutter/material.dart';
import 'package:notes_app/app/auth/login.dart';
import 'package:notes_app/app/auth/signup.dart';
import 'package:notes_app/app/home.dart';
import 'package:notes_app/app/notes/addnote.dart';
import 'package:notes_app/app/notes/editnote.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences sharedpref;
void main() async {
  // Ensure that SharedPreferences is initialized before running the app
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SharedPreferences
  sharedpref = await SharedPreferences
      .getInstance(); //we initialize it here to ensure global access
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner:
          false, //removes the word debug from the top right corner
      title: 'Note App',
      initialRoute: sharedpref.getString("id") == null ? 'login' : 'home',
      routes: {
        'home': (context) => Home(),
        'login': (context) => Login(),
        'sign up': (context) => SignUp(),
        'add note': (context) => AddNote(),
        'edit note': (context) => EditNote(notes: "")
      },
      home: Container(),
    );
  }
}
