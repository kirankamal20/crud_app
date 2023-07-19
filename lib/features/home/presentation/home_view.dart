import 'dart:developer';
import 'dart:io';

import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:crud_app/data/db/dbservice.dart';
import 'package:crud_app/data/model/student_details_model.dart';
import 'package:crud_app/features/add_student/presentation/add_student_view.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({
    super.key,
  });

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final StudentDb hiveMethods = StudentDb();
  late final List<StudentDetailsModel> studentdetailsList;
  bool isLoading = true;

  List<StudentDetailsModel> studentSearchResult = [];
  final searchController = TextEditingController();
  void search(String searchString) {
    setState(
      () {
        studentSearchResult = studentdetailsList
            .where((item) =>
                item.name.toLowerCase().contains(searchString.toLowerCase()) ||
                item.gender
                    .toLowerCase()
                    .contains(searchString.toLowerCase()) ||
                item.country
                    .toLowerCase()
                    .contains(searchString.toLowerCase()) ||
                item.date.toLowerCase().contains(searchString.toLowerCase()))
            .toList();
      },
    );
  }

  Future<void> fetchStudentDetails() async {
    var usersData = await hiveMethods.getAllStudentDetailsList();
    log(usersData.toString());

    studentdetailsList = usersData;

    setState(() {
      isLoading = false;
    });
    print(studentdetailsList);
  }

  void searchControllerListener() {
    search(searchController.text);
  }

  @override
  void initState() {
    fetchStudentDetails();
    // studentSearchResult = studentdetailsList;
    searchController.addListener(searchControllerListener);
    super.initState();
  }

  @override
  void dispose() {
    searchController.removeListener(searchControllerListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: const Text("Students Details"),
          actions: [
            AnimSearchBar(
              width: MediaQuery.of(context).size.width,
              textController: searchController,
              onSuffixTap: () {
                setState(() {
                  searchController.clear();
                });
              },
              onSubmitted: (s) {},
            ),
          ]),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : studentdetailsList.isNotEmpty
              ? GridView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(15),
                  itemCount: studentdetailsList.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, childAspectRatio: 0.58),
                  itemBuilder: (context, index) {
                    var studentdetails = studentdetailsList[index];
                    return SizedBox(
                      height: 150,
                      child: Card(
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
                                        width: 170,
                                        child: Image.file(
                                          File(studentdetails.imagePath),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text("Name : ${studentdetails.name}"),
                                    Text("Age : ${studentdetails.age}"),
                                    Text("gender : ${studentdetails.gender}"),
                                    Text("Dob : ${studentdetails.date}"),
                                    Text("Country : ${studentdetails.country}")
                                  ],
                                ),
                              ),
                              Positioned(
                                right: 0,
                                child: IconButton(
                                  onPressed: () async {
                                    await hiveMethods
                                        .deleteStudentDetails(index);
                                    await fetchStudentDetails();
                                    // setState(() {});
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: IconButton(
                                  onPressed: () async {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AddStudentView(
                                          index: index,
                                          isVisibleAddButton: false,
                                          appBarTittleName: "Update Student",
                                          studentName: studentdetails.name,
                                          studentAge: studentdetails.age,
                                          studentDob: studentdetails.date,
                                          studentCountry:
                                              studentdetails.country,
                                          studentGender: studentdetails.gender,
                                          studentImage:
                                              studentdetails.imagePath,
                                        ),
                                      ),
                                    ).then((value) async {
                                      await fetchStudentDetails();
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.blue,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                )
              : const Center(child: Text("No Student Data Found")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddStudentView(
                  index: 0,
                  isVisibleAddButton: true,
                  appBarTittleName: "Add student",
                  studentName: "",
                  studentAge: "",
                  studentDob: "",
                  studentCountry: "",
                  studentGender: "Male",
                  studentImage: ""),
            ),
          ).then((value) async => await fetchStudentDetails());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
