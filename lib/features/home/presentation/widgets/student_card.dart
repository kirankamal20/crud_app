import 'dart:io';

import 'package:crud_app/data/model/student_details_model.dart';
import 'package:flutter/material.dart';

class StudnetCardWidget extends StatelessWidget {
  final StudentDetailsModel studentdetails;
  final Function() deleteStudent;
  final Function() addStudent;
  const StudnetCardWidget(
      {super.key,
      required this.studentdetails,
      required this.deleteStudent,
      required this.addStudent});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: Card(
        elevation: 3,
        surfaceTintColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            children: [
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: SizedBox(
                        height: 150,
                        width: 180,
                        child: Image.file(
                          fit: BoxFit.cover,
                          File(studentdetails.imagepath),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Name : ${studentdetails.name}",
                      style: const TextStyle(fontSize: 13),
                    ),
                    Text("Age : ${studentdetails.age}",
                        style: const TextStyle(fontSize: 13)),
                    Text("gender : ${studentdetails.gender}",
                        style: const TextStyle(fontSize: 13)),
                    Text("Dob : ${studentdetails.dob}",
                        style: const TextStyle(fontSize: 13)),
                    Text("Country : ${studentdetails.country}",
                        style: const TextStyle(fontSize: 13))
                  ],
                ),
              ),
              Positioned(
                right: 0,
                child: IconButton(
                  onPressed: deleteStudent,
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                ),
              ),
              Positioned(
                bottom: -8,
                right: -8,
                child: IconButton(
                  onPressed: addStudent,
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.blue,
                    size: 17,
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
