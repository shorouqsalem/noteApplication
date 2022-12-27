// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:noteaplication/signup.dart';
import 'package:noteaplication/login.dart';

import 'addnote.dart';
import 'homePage.dart';

bool islogin = false;

Future<void> main() async {
  //هذه الكودات اولا حطيتها بالمين عشان اول ما يبدا التطبيق يبدا من ربط التطبيق بالفير بيس

  WidgetsFlutterBinding.ensureInitialized();
  // هاي التعليمة اللي فوق عشان تتأكد من عملية الربط قبل ما يشتغل الابليكيشن
  await Firebase.initializeApp();
  //ال (currentUser)
  // وظيفتها ترجعلي معلومات اليوزر اللي مسوي تسجيل دخول
  var user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    //يعني ايوزر مش عامل لتسجيل دخول
    islogin = false;
  } else {
    islogin = true;
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //بناءا على قيمة (islogin)
      //اذا كانت قيمتها فولس وديهلصفحة تسجيل الدخول
      // و اذا ترو وديه للصفحة الرئيسية يعني صفحة الهوم

      home: islogin == false ? LoginPage() : HomePage(),
      routes: {
        "login": (context) => LoginPage(),
        "signup": (context) => SignUp(),
        "homepage": (context) => HomePage(),
        "addnote": (context) => AddNotes(),
      },
    );
  }
}
