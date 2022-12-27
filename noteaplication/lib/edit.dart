// ignore_for_file: prefer_const_constructors, curly_braces_in_flow_control_structures, prefer_const_literals_to_create_immutables, import_of_legacy_library_into_null_safe, unnecessary_new, prefer_typing_uninitialized_variables, unnecessary_null_comparison, avoid_print, avoid_unnecessary_containers, deprecated_member_use, unnecessary_string_interpolations, depend_on_referenced_packages, non_constant_identifier_names, use_build_context_synchronously

import 'dart:io';
import 'dart:math';
import 'package:noteaplication/component/alert.dart';
import 'package:path/path.dart';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditNotes extends StatefulWidget {
  final docid;
  final list;
  const EditNotes({Key? key,this.docid,this.list}) : super(key: key);

  @override
  State<EditNotes> createState() => _EditNotesState();
}
// عشان اقدر اعدل عى اي ملاحظة  محتاج اعرف ال ديكومنت id الخاص فيها
//وبحصل عليه من ال get في صفح الهوم
class _EditNotesState extends State<EditNotes> {
 CollectionReference notesref = FirebaseFirestore.instance.collection("notes");

  late Reference ref;

  late File file;

  var title, note, imageurl;

  GlobalKey<FormState> formstate = new GlobalKey<FormState>();

   Future EditNotes(context) async {
    var formdata = formstate.currentState;
    //اذا الشخص  ماعدل الصورة
      if (file == null)
      {
        if (formdata!.validate()) {
      showLoding(context);
     
      formdata.save();
      // هيك بتأكد انة الشخص ما حيرفع الصورة (لانه اذا رفع صورة بدون ما يكب نوت ر يستهلك مساحة التخزين في الفاير بيس وهيك بيصير مدفوع)
      
      await notesref.doc(widget.docid).update({
         "title": title,
        "note": note,
        "imageurl": imageurl,
        "userid": FirebaseAuth.instance.currentUser!.uid
      }).then((value) {
        Navigator.of(context).pushNamed("homepage");

      } ).catchError((e){
        print("$e");
      });
       
      
    } 

      }
      else{
        //اذا الشخص  عدل الصورة
        if (formdata!.validate()) {
      showLoding(context);
     
      formdata.save();
      await ref.putFile(file);
      imageurl = await ref.getDownloadURL();
      // هيك بتأكد انة الشخص ما حيرفع الصورة (لانه اذا رفع صورة بدون ما يكب نوت ر يستهلك مساحة التخزين في الفاير بيس وهيك بيصير مدفوع)
      await ref.putFile(file);
      imageurl = await ref.getDownloadURL();
      await notesref.doc(widget.docid).update({
         "title": title,
        "note": note,
        "imageurl": imageurl,
       
      }).then((value) {
        Navigator.of(context).pushNamed("homepage");
   
      }).catchError((e){
        print("$e");

      });
       
      
    } 

      }
    
    
     
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Note'),
      ),
      body: Container(
          child: Column(
        children: [
          Form(
              key: formstate,
              child: Column(children: [
                TextFormField(
                  initialValue: widget.list['Titel'],
                  validator: (val) {
                    if (val!.length > 30) {
                      return "Title can't to be larger than 30 letter";
                    }
                    if (val.length < 2) {
                      return "Title can't to be less than 2 letter";
                    }
                    return null;
                  },
                  onSaved: (val) {
                    title = val;
                  },
                  maxLength: 30,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: "Title Note",
                      prefixIcon: Icon(Icons.note)),
                ),
                TextFormField(
                  initialValue: widget.list['note'],
                  validator: (val) {
                    if (val!.length > 255) {
                      return "Notes can't to be larger than 255 letter";
                    }
                    if (val.length < 10) {
                      return "Notes can't to be less than 10 letter";
                    }
                    return null;
                  },
                  onSaved: (val) {
                    note = val;
                  },
                  minLines: 1,
                  maxLines: 3,
                  maxLength: 200,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: "Note",
                      prefixIcon: Icon(Icons.note)),
                ),
                ElevatedButton(
                  onPressed: () {
                    showBottomSheet(context);
                  },
                  
                  child: Text("Edit Image For Note"),
                ),



                ElevatedButton(
                  onPressed: () async {
                    await EditNotes(context);
                  },
                 
                  child: Text(
                    "Edit Note",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                )
              ]))
        ],
      )),
    );
  }





  

  showBottomSheet(context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.all(20),
            height: 180,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Edite Image",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                InkWell(
                  onTap: () async {
                    var picked = await ImagePicker()
                        .getImage(source: ImageSource.gallery);
                    if (picked != null) {
                      file = File(picked.path);
                      var rand = Random().nextInt(100000);
                      var imagename = "$rand${basename(picked.path)}" ;
                   ref =  FirebaseStorage.instance
                          .ref("images")
                          .child("$imagename");
                          
                      Navigator.of(context).pop();
                    }
                  },
                  child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Icon(
                            Icons.photo_outlined,
                            size: 30,
                          ),
                          SizedBox(width: 20),
                          Text(
                            "From Gallery",
                            style: TextStyle(fontSize: 20),
                          )
                        ],
                      )
                      ),
                ),
                InkWell(
                  onTap: () async {
                    var picked = await ImagePicker()
                        .getImage(source: ImageSource.camera);
                    if (picked != null) {
                      file = File(picked.path);
                      var rand = Random().nextInt(100000);
                      var imagename = "$rand${basename(picked.path)}";
                     ref = FirebaseStorage.instance
                          .ref("images")
                          .child("$imagename");
                           

                      Navigator.of(context).pop();
                    }
                  },
                  child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Icon(
                            Icons.camera,
                            size: 30,
                          ),
                          SizedBox(width: 20),
                          Text(
                            "From Camera",
                            style: TextStyle(fontSize: 20),
                          )
                        ],
                      )),
                ),
              ],
            ),
          );
        });
  }
}
