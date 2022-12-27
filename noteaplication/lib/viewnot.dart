

// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, prefer_typing_uninitialized_variables


import 'package:flutter/material.dart';

class ViewNotes extends StatefulWidget {
  //هذا المتغير لعرض تفاصيل الملاحظة
 final notes;
  const ViewNotes({Key? key,this.notes}) : super(key: key);

  @override
  State<ViewNotes> createState() => _ViewNotesState();
}

class _ViewNotesState extends State<ViewNotes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Note"),

      ),
      body: Container(
        child: Column(
          children: [
            Container(
                child: Image.network(
              "${widget.notes['imageurl']}",
              width: double.infinity,
              height: 300,
              fit: BoxFit.fill,
            )
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 15),
              child: Text('${widget.notes['title']}',style: TextStyle(fontSize: 15,fontWeight: FontWeight.w100,fontStyle: FontStyle.normal,color: Colors.blueGrey),)),
              Container(
              margin: EdgeInsets.symmetric(vertical: 15),
              child: Text('${widget.notes['note']}',style: TextStyle(fontSize: 10,fontWeight: FontWeight.w100,fontStyle: FontStyle.normal,color: Colors.black),))
          ],
        ),
      ),
    );
  }
}