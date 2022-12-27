// ignore_for_file: prefer_const_constructors, body_might_complete_normally_nullable, unnecessary_new, avoid_print, prefer_typing_uninitialized_variables, avoid_single_cascade_in_expression_statements, unnecessary_null_comparison, import_of_legacy_library_into_null_safe, use_build_context_synchronously

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:noteaplication/component/alert.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  var myusername, mypassword, myemail;
  GlobalKey<FormState> formState = new GlobalKey<FormState>();
  signup() async {
    var formdata = formState.currentState;
    if (formdata!.validate()) {
      formdata.save();

      try {
        showLoding(context);
        UserCredential credential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: myemail, password: mypassword);
        return credential;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          Navigator.of(context).pop();
          AwesomeDialog(
              context: context, title: "Error", body: Text("Password is weak"))
            ..show();
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          Navigator.of(context).pop();
          AwesomeDialog(
              context: context,
              title: "Error",
              body: Text("The account already exists for that email"))
            ..show();
          print('The account already exists for that email.');
        }
      } catch (e) {
        print(e);
      }
    } else {
      print("Not valid");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          SizedBox(
            height: 100,
          ),
          Center(
            child: Image.asset("images/OIP.jpg"),
          ),
          Container(
            padding: EdgeInsets.all(20),
            child: Form(
              key: formState,
              child: Column(children: [
                TextFormField(
                  onSaved: (val) {
                    myusername = val;
                  },
                  validator: (val) {
                    if (val!.length > 100) {
                      return " Your UserName it is larger than 100 latter";
                    }

                    if (val.length < 2) {
                      return " Your UserName it is less than two latter";
                    }
                  },
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      prefixIcon: Icon(Icons.person),
                      hintText: "UserName",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 1),
                      )),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  onSaved: (val) {
                    myemail = val;
                  },
                  validator: (val) {
                    if (val!.length > 100) {
                      return " Your Email it is larger than 100 latter";
                    }

                    if (val.length < 2) {
                      return " Your Email it is less than two latter";
                    }
                  },
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      prefixIcon: Icon(Icons.person),
                      hintText: "Email",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 1),
                      )),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  onSaved: (val) {
                    mypassword = val;
                  },
                  validator: (val) {
                    if (val!.length < 8) {
                      return " Your Password it is less than 8 latter";
                    }

                    if (val.length > 8) {
                      return " Your Password it is Larger than 8 latter";
                    }
                  },
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      prefixIcon: Icon(Icons.person),
                      hintText: "Password",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 1),
                      )),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Text(
                      "if you have account",
                      style: TextStyle(fontSize: 10),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed("login");
                        },
                        child: Text(
                          "Click here",
                          style: TextStyle(color: Colors.blue),
                        )),
                  ],
                ),
                Center(
                    child: ElevatedButton(
                        onPressed: () async {
                          UserCredential response = await signup();
                          print("========================");
                          if (response != null) {
                            await FirebaseFirestore.instance.collection("users").add({
                              "username":myusername,
                              "email":myemail,

                            });
                            Navigator.of(context)
                                .pushReplacementNamed("homepage");
                          } else {
                            print("NO NO NO");
                          }
                          print("========================");
                        },
                        child: Text(" Sign Up")))
              ]),
            ),
          )
        ],
      ),
    );
  }
}
