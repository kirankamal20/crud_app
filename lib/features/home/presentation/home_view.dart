import 'dart:developer';
import 'dart:io';

import 'package:crud_app/data/db/dbservice.dart';
import 'package:crud_app/data/model/student_details_model.dart';
import 'package:crud_app/features/add_student/presentation/add_student_view.dart';
import 'package:crud_app/features/home/presentation/widgets/student_card.dart';
import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({
    super.key,
  });

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  // final StudentDb hiveMethods = StudentDb();
  final SQLHelper sqlHelper = SQLHelper();
  List<StudentDetailsModel> studentdetailsList = [];
  bool isLoading = true;
  final int itemsPerPage = 4;
  int currentPage = 1;
  int currentIndex = 0;
  @override
  void initState() {
    fetchStudentDetails();

    super.initState();
  }

  Widget buildPagination() {
    final int totalPages = (studentdetailsList.length / itemsPerPage).ceil();

    return Padding(
      padding: const EdgeInsets.only(right: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // Previous button
          if (totalPages > 2)
            GestureDetector(
              onTap: () {
                if (currentPage > 1) {
                  setState(() {
                    currentPage--;
                  });
                }
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ),
            ),

          ...List.generate(
            totalPages > 2 ? 2 : totalPages,
            (index) {
              final pageNumber = index + 1;
              currentIndex = pageNumber + 1;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    currentPage = pageNumber;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    color: pageNumber == currentPage || pageNumber > 3
                        ? Colors.amber
                        : Colors.grey,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    '$pageNumber',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              );
            },
          ),
          if (totalPages > 2)
            GestureDetector(
              onTap: () {
                setState(() {
                  currentPage = currentIndex;
                });
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  color: currentIndex == currentPage || currentPage > 2
                      ? currentPage < 2
                          ? Colors.grey
                          : Colors.amber
                      : Colors.grey,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  "${currentPage < 3 ? 3 : currentPage}",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          if (totalPages > 2)
            GestureDetector(
              onTap: () {
                if (currentPage < totalPages) {
                  setState(() {
                    currentPage++;
                  });
                }
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }

  void showSnackBar({required String message, required Color color}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 2),
      backgroundColor: color,
      content: Text(message),
    ));
  }

  void searchStudent(String searchString) {
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
                  item.dob.toLowerCase().contains(searchString.toLowerCase()))
              .toList();
        } else {
          fetchStudentDetails();
        }
      },
    );
  }

  Future<void> fetchStudentDetails() async {
    final usersData = await sqlHelper.getAllStudentDetailsList();
    // final usersData = await hiveMethods.getAllStudentDetailsList();
    log(usersData.length.toString());
    studentdetailsList = usersData;
    setState(() {
      isLoading = false;
    });
  }

  void deleteStudentDetails({required int id}) async {
    // await hiveMethods.deleteStudentDetails(index);
    await sqlHelper.deleteStudentDetails(
      id: id,
      onError: (errorMessage) {
        var snackBar = SnackBar(
          backgroundColor: Colors.red,
          content: Text(errorMessage),
        );
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
      onSuccess: (successMessage) async {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text(successMessage),
        ));
        await fetchStudentDetails();
      },
    );
  }

  List<StudentDetailsModel> studentListPagination() {
    final int startIndex = (currentPage - 1) * itemsPerPage;
    final int endIndex = startIndex + itemsPerPage;
    if (studentdetailsList.length < endIndex) {
      return studentdetailsList.sublist(startIndex, studentdetailsList.length);
    } else {
      return studentdetailsList.sublist(startIndex, endIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EasySearchBar(
          elevation: 0.5,
          title: const Text(
            "Students Details",
            style: TextStyle(color: Colors.white),
          ),
          onSearch: (value) {
            searchStudent(value);
          }),
      body: Center(
        child: SingleChildScrollView(
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : studentdetailsList.isNotEmpty
                  ? RefreshIndicator(
                      onRefresh: () async {
                        Future.delayed(const Duration(seconds: 4));
                        return fetchStudentDetails();
                      },
                      child: Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.79,
                            child: GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              padding: const EdgeInsets.all(15),
                              itemCount: studentListPagination().length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 0.58),
                              itemBuilder: (context, index) {
                                final studentdetails =
                                    studentListPagination()[index];

                                return StudnetCardWidget(
                                  studentdetails: studentdetails,
                                  deleteStudent: () {
                                    deleteStudentDetails(id: studentdetails.id);
                                  },
                                  addStudent: () {
                                    Navigator.push<bool>(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AddStudentView(
                                          onAddStudentSuccess: (m) {},
                                          countryCode:
                                              studentdetails.countrycode,
                                          id: studentdetails.id,
                                          isVisibleAddButton: false,
                                          appBarTittleName: "Update Student",
                                          studentName: studentdetails.name,
                                          studentAge: studentdetails.age,
                                          studentDob: studentdetails.dob,
                                          studentCountry:
                                              studentdetails.country,
                                          studentGender: studentdetails.gender,
                                          studentImage:
                                              studentdetails.imagepath,
                                          onUpdateStudentSuccess:
                                              (successMessage) async {
                                            FocusScope.of(context).unfocus();
                                            Navigator.pop(context);
                                            showSnackBar(
                                                message: successMessage,
                                                color: Colors.blue);
                                            await fetchStudentDetails();
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          buildPagination(),
                          const SizedBox(
                            height: 15,
                          )
                        ],
                      ),
                    )
                  : const Center(child: Text("No Student Data Found")),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddStudentView(
                onUpdateStudentSuccess: (p0) {},
                id: 0,
                isVisibleAddButton: true,
                appBarTittleName: "Add Student",
                studentName: "",
                studentAge: "",
                studentDob: "",
                studentCountry: "",
                studentImage: null,
                countryCode: "+91",
                onAddStudentSuccess: (successMessage) async {
                  FocusScope.of(context).unfocus();
                  Navigator.pop(context);
                  showSnackBar(message: successMessage, color: Colors.green);
                  await fetchStudentDetails();
                },
              ),
            ),
          );
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
