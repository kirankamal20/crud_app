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
  List<StudentDetailsModel> studentdetailsList = [];
  bool isLoading = true;

  List<StudentDetailsModel> studentSearchResult = [];
  final searchController = TextEditingController();
  void search(String searchString) {
    setState(
      () {
        if (searchString.isNotEmpty) {
          studentdetailsList = studentdetailsList
              .where((item) =>
                  item.name
                      .toLowerCase()
                      .contains(searchString.toLowerCase()) ||
                  item.gender
                      .toLowerCase()
                      .contains(searchString.toLowerCase()) ||
                  item.country
                      .toLowerCase()
                      .contains(searchString.toLowerCase()) ||
                  item.date.toLowerCase().contains(searchString.toLowerCase()))
              .toList();
        } else {
          fetchStudentDetails();
        }
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

  void deleteStudent({required int index}) async {
    await hiveMethods.deleteStudentDetails(index);
    await fetchStudentDetails();
    const snackBar = SnackBar(
      backgroundColor: Colors.red,
      content: Text("Successfully Deleted"),
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "Students Details",
            style: TextStyle(color: Colors.white),
          ),
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
              ? RefreshIndicator(
                  onRefresh: () async {
                    Future.delayed(const Duration(seconds: 4));
                    return fetchStudentDetails();
                  },
                  child: GridView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(15),
                    itemCount: studentdetailsList.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                      Text(
                                        "Name : ${studentdetails.name}",
                                        style: const TextStyle(fontSize: 13),
                                      ),
                                      Text("Age : ${studentdetails.age}",
                                          style: const TextStyle(fontSize: 13)),
                                      Text("gender : ${studentdetails.gender}",
                                          style: const TextStyle(fontSize: 13)),
                                      Text("Dob : ${studentdetails.date}",
                                          style: const TextStyle(fontSize: 13)),
                                      Text(
                                          "Country : ${studentdetails.country}",
                                          style: const TextStyle(fontSize: 13))
                                    ],
                                  ),
                                ),
                                Positioned(
                                  right: 0,
                                  child: IconButton(
                                    onPressed: () async {
                                      deleteStudent(index: index);
                                    },
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
                                    onPressed: () async {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => AddStudentView(
                                            countryCode:
                                                studentdetails.countryCode,
                                            index: index,
                                            isVisibleAddButton: false,
                                            appBarTittleName: "Update Student",
                                            studentName: studentdetails.name,
                                            studentAge: studentdetails.age,
                                            studentDob: studentdetails.date,
                                            studentCountry:
                                                studentdetails.country,
                                            studentGender:
                                                studentdetails.gender,
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
                                      size: 17,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
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
                studentImage: null,
                countryCode: "+91",
              ),
            ),
          ).then((value) async => await fetchStudentDetails());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
