// ignore_for_file: file_names, prefer_const_constructors, unused_local_variable, unused_label, use_build_context_synchronously, avoid_unnecessary_containers, prefer_typing_uninitialized_variables, prefer_const_constructors_in_immutables



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:noteaplication/edit.dart';
import 'package:noteaplication/viewnot.dart';
import 'package:sqflite/sqflite.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {
  //لاضافة الداتابيس
  // Sqflite sqlDb=Sqflite();
  // Future<List<Map>> readData()async{
  //   List<Map> response =await sqlDb.readData("SELECT * FROM notes");
  //   return response;


  // }
  CollectionReference noteref=FirebaseFirestore.instance.collection("notes");
  getuser() {
    var user = FirebaseAuth.instance.currentUser;
  }

  @override
  void initState() {
    getuser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          Navigator.of(context).pushNamed("addnote");
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacementNamed("login");
              },
              icon: Icon(Icons.exit_to_app))
        ],
        title: Text("Home page"),
      ),
      body:  Container(
        child: FutureBuilder(
            future: noteref
                .where("userid",
                    isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                .get(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: (snapshot.data! as QuerySnapshot). docs.length,
                    itemBuilder: (context, i) {
                       //فائدة ال (Dismissible)
                       // وبتنحذف انه صار بأمكاني احرك الملاحظة يمين ويسار
                      return Dismissible(
                        onDismissed: (direction)async{
                          //لحذف الملاحظة
                          //لكن الصورة بتضل  موجودة بال (storage)
                           await noteref.doc((snapshot.data!as QuerySnapshot ).docs[i].id).delete();
                           //لحذف الصورة من ال(storage)
                           await FirebaseStorage.instance.refFromURL((snapshot.data! as QuerySnapshot ).docs[i]['imageurl']).delete();
                        },
                        key: UniqueKey() , 
                        child: ListNotes(notes:(snapshot.data! as QuerySnapshot). docs[i],docid:  (snapshot.data! as QuerySnapshot). docs[i].id,)
                        );
                     
                    });
              }
              return Center(child: CircularProgressIndicator());
            }),
      ),
    );
  }
}
// هاذ الكلاس بياخذ بيانات من ال (  list view builder)

class ListNotes extends StatelessWidget {
  final notes;
  final docid;
  ListNotes({Key? key, this.notes, this.docid}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        
      },
      child: InkWell(
        onTap: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (context){
            return ViewNotes(notes:notes);

          }));
        },
        child: Card(
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Image.network(
                  "${notes['imageurl']}",
                  fit: BoxFit.fill,
                  height: 80,
                ),
              ),
              Expanded(
                flex: 3,
                child: ListTile(
                  title: Text("${notes['title']}$docid"),
                  subtitle: Text(
                    "${notes['note']}",
                    style: TextStyle(fontSize: 14),
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context){
                        return EditNotes(docid: docid,list: notes,);
      
                      }));
                     
                    },
                    icon: Icon(Icons.edit),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

