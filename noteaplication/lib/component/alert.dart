// ignore_for_file: sized_box_for_whitespace, prefer_const_constructors

import 'package:flutter/material.dart';

showLoding(context) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Please wait"),
          content: Container(
              height: 50, child: Center(child: CircularProgressIndicator())),
        );
      });
}
