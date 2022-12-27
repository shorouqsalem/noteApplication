// ignore_for_file: non_constant_identifier_names, depend_on_referenced_packages, unused_field


import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqfDb {
  static Database? _db;
  //هاي الفنكشن عشان ما اعمل انيشيل اكثر من مرة
 Future <Database ?> get db async{
    if (_db==null) {
      _db =await intiDb();
      return _db;
      
    }
    else{
      return _db;
    }
  }
//بدي اعمل قاعدة بيانات محلية يعني
// اوفلاين مش اونلاين
//والمعلومات بتنحذف لما احذف التطبيق مباشرة


  intiDb() async{
    // اول اشي بدي اختار المسار اللي بدي احفظ فيه الداتا بيس
    //هاي فنكشن جاهزة
    String databasePath=await getDatabasesPath();
    //هسة بدي اختار اسم الداتا بيس
    //لازم الاكستنشن تكون .db
    String path=join(databasePath,'shorouq.db');
    //الفيرجن يعني عدد الداتابيس اللي بدي انشئهم
    //ال onUpgrade بستخدمها لما بدي اضيفجدول او اعدل على الداتا بيس
    //طبعا بيتم استدعائها فقط اذا غيرت رقم الفيرجن
    Database myDb=await openDatabase(path,onCreate: _OnCreate,version: 3,onUpgrade: _onUpgrade);
    return myDb;

  }

  _onUpgrade(Database db,int oldversion ,int newversion){


  }
  _OnCreate(Database db,int version)async{

    //وظيفة هاذ الفنكشن انه يعمل الجداول
    //هون بعمل تعليمات ال sql
    await db.execute('''
     CREATE TABLE "notes"(
      "id"  NOT NULL PRIMARY KEY AUTOINCREMENT,
      "note" TEXT NOT NULL 
     )
      

    
    
    ''');
    print("DONE========================");


  }
  //انشاء الفنكشن الخاصة بالسيليكت
  readData(String sql) async{
    Database? mydb=await db ;
    //رح اخذ الاشي اللي رح يرجعلي من الداتا بيس
    List<Map> response =await mydb!.rawQuery(sql);
    return response;

  }

   insertData(String sql) async{
    Database? mydb=await db ;
    //رح اخذ الاشي اللي رح يرجعلي من الداتا بيس
    int response =await mydb!.rawInsert(sql);
    return response;

  }
  updatetData(String sql) async{
    Database? mydb=await db ;
    //رح اخذ الاشي اللي رح يرجعلي من الداتا بيس
    int response =await mydb!.rawUpdate(sql);
    return response;

  }
deleteData(String sql) async{
    Database? mydb=await db ;
    //رح اخذ الاشي اللي رح يرجعلي من الداتا بيس
    int response =await mydb!.rawDelete(sql);
    return response;

  }






}