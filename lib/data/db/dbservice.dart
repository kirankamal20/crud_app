import 'dart:developer';

import 'package:crud_app/data/model/student_details_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqflite.dart';

late Database database;

class SQLHelper {
  Future<void> initializeDatabase() async {
    database = await sql.openDatabase(
      'student.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE students(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        name TEXT,
        age TEXT,
        dob TEXT,
        country TEXT,
        gender TEXT,
        imagepath TEXT,
        countrycode TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
  }

  Future<void> addStudentDetails(StudentDetailsModel userModel) async {
    await database.rawQuery(
        "INSERT INTO students(name,age,dob,country,gender,imagepath,countrycode) VALUES(?,?,?,?,?,?,?)",
        [
          userModel.name,
          userModel.age,
          userModel.dob,
          userModel.country,
          userModel.gender,
          userModel.imagepath,
          userModel.countrycode,
        ]);
  }

  Future<List<StudentDetailsModel>> getAllStudentDetailsList() async {
    List<StudentDetailsModel> studentDetailsList = [];

    final studentDbResult = await database.rawQuery('SELECT * FROM students');

    for (var studentData in studentDbResult) {
      studentDetailsList.add(StudentDetailsModel.fromMap(studentData));
    }

    return studentDetailsList;
  }

  Future<void> updateStudentDetails(
      {required int id,
      required StudentDetailsModel studentDetailsModel}) async {
    await database.rawUpdate(
        'UPDATE students SET name = ?, age = ?, dob = ?, country = ?, gender = ?, imagepath = ?, countrycode = ? WHERE id = ?',
        [
          studentDetailsModel.name,
          studentDetailsModel.age,
          studentDetailsModel.dob,
          studentDetailsModel.country,
          studentDetailsModel.gender,
          studentDetailsModel.imagepath,
          studentDetailsModel.countrycode,
          id
        ]);

    getAllStudentDetailsList();
  }

  Future<void> deleteStudentDetails(int id) async {
    await database.rawDelete('DELETE FROM students WHERE id = ?', [id]);
    getAllStudentDetailsList();
  }
}

// class StudentDb {
//   String hiveBox = 'student';

//   //Adding user model to hive db
//   Future<void> addStudentDetails(StudentDetailsModel userModel) async {
//     var box = await Hive.openBox(hiveBox); //open the hive box before writing
//     var mapUserData = userModel.toMap();
//     await box.add(mapUserData);
//     Hive.close(); //closing the hive box
//   }

//   //Reading all the users data
//   Future<List<StudentDetailsModel>> getAllStudentDetailsList() async {
//     var box = await Hive.openBox(hiveBox);
//     List<StudentDetailsModel> studentDetailsList = [];

//     for (int i = 0; i < box.length; i++) {
//       var userMap = box.getAt(i);
//       studentDetailsList.add(StudentDetailsModel.fromMap(userMap));
//     }
//     log(studentDetailsList.toString());
//     return studentDetailsList;
//   }

//   Future<void> updateStudentDetails(
//       {required int index,
//       required StudentDetailsModel studentDetailsModel}) async {
//     var studentBox = await Hive.openBox(hiveBox);
//     var studentDetails = studentDetailsModel.toMap();
//     await studentBox.putAt(index, studentDetails);
//     getAllStudentDetailsList();
//   }

//   //Deleting one data from hive DB
//   Future<void> deleteStudentDetails(int id) async {
//     var box = await Hive.openBox(hiveBox);
//     await box.deleteAt(id);
//     getAllStudentDetailsList();
//   }

//   //Deleting whole data from Hive
//   Future<void> deleteAllUsers() async {
//     var box = await Hive.openBox(hiveBox);
//     await box.clear();
//   }
// }
