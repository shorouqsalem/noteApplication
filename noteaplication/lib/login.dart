// ignore_for_file: avoid_single_cascade_in_expression_statements, prefer_const_constructors, import_of_legacy_library_into_null_safe, prefer_typing_uninitialized_variables, avoid_print, use_build_context_synchronously

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:noteaplication/component/alert.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}



class _LoginPageState extends State<LoginPage> {
  //final _emailControler=TextEditingController();
  //final _passwordControler=TextEditingController();
  var mypassword, myemail;
  GlobalKey<FormState> formState = GlobalKey<FormState>();




  signIN() async {
    var formdata = formState.currentState;
    if (formdata!.validate()) {
      formdata.save();

      try {
        showLoding(context);
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: myemail, password: mypassword);
        return userCredential;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-Not-found') {
          Navigator.of(context).pop();
          AwesomeDialog(
              context: context,
              title: "Error",
              body: Text("No user found for that email"))
            ..show();
        } else if (e.code == 'Wrong-Password') {
          //لما ما كتبت تعليمة البوب  ما رضي يدخلني على صفحة الهوم ضل يعطيني القيمة الراجعة (null)
          Navigator.of(context).pop();
          AwesomeDialog(
              context: context,
              title: "Error",
              body: Text("Wrong password provided for that user"))
            ..show();
        }
      }
    } else {
      print("Not valid");
    }
  }

  // Future signIn() async{

  //   await FirebaseAuth.instance.signInWithEmailAndPassword(
  //     email: _emailControler.text.trim(),
  //     password: _passwordControler.text.trim(),
  //     );
  // }

  // @override
  // void dispose() {
  //   _emailControler.dispose();
  //   _passwordControler.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Center(
            child: Image.asset("images/OIP.jpg"),
          ),
          Container(
            padding: EdgeInsets.all(20),
            child: Form(
              key: formState,
              child: Column(
                children: [
                  TextFormField(
                    onSaved: (val) {
                      myemail = val;
                    },

                    validator: (val) {
                      if (val!.length > 100) {
                        return "Email can't to be larger than 100 letter";
                      }
                      if (val.length < 2) {
                        return "Email can't to be less than 2 letter";
                      }
                      return null;
                    },

                    //controller: _emailControler,

                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      hintText: "Email",
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                    onSaved: (val) {
                      mypassword = val;
                    },
                    validator: (val) {
                      if (val!.length > 100) {
                        return "Password can't to be larger than 100 letter";
                      }
                      if (val.length < 4) {
                        return "Password can't to be less than 4 letter";
                      }
                      return null;
                    },
                    obscureText: true,

                    //controller: _passwordControler,

                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      hintText: "Password",
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Row(
                    children: [
                      Text("if you dont have account"),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pushReplacementNamed("signup");
                          },
                          child: Text("click here"))
                    ],
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        var user = await signIN();
                        if (user != null) {
                          Navigator.of(context)
                              .pushReplacementNamed("homepage");
                        }
                      },
                      child: Text("Sign In"))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
