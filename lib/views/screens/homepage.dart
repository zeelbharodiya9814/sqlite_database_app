import 'dart:io';
import 'dart:typed_data';

import 'package:database_app/helper/db_student.dart';
import 'package:database_app/modal/student_class.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../modal/global_class.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? names;
  int? ages;
  String? courses;
  Uint8List? image;

  TextEditingController namecontroller = TextEditingController();
  TextEditingController agecontroller = TextEditingController();
  TextEditingController coursecontroller = TextEditingController();

  GlobalKey<FormState> imsertformKey = GlobalKey<FormState>();
  GlobalKey<FormState> updateformKey = GlobalKey<FormState>();

  final ImagePicker pick = ImagePicker();

  late Future<List<Student>> getAllStudent;

  void initState() {
    super.initState();
    getAllStudent = DBHelper.dbHelper.fetchAllStudents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Database",
          style: TextStyle(
              color: Colors.white, fontSize: 22, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [

          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 10, right: 10),
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Container(
                height: 60,
                alignment: Alignment.center,
                child: TextFormField(
                  controller: namecontroller,
                  textInputAction: TextInputAction.next,
                  onChanged: (val) {
                    setState(() {
                      getAllStudent =
                          DBHelper.dbHelper.fetchSearchStudents(data: val!);
                    });
                  },
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.grey,
                        size: 30,
                      ),
                      hintText: "Search here...",
                      hintStyle:
                          TextStyle(color: Colors.grey[400], fontSize: 20),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      )),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 12,
            child: FutureBuilder(
              future: getAllStudent,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text("ERROR: ${snapshot.error}"),
                  );
                } else if (snapshot.hasData) {
                  List<Student>? data = snapshot.data;

                  return (data != null)
                      ? ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (context, i) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                  top: 8.0, left: 8, right: 8),
                              child: Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                child: ListTile(
                                  isThreeLine: true,
                                  leading: CircleAvatar(
                                    radius: 30,
                                    backgroundImage: (data[i].image != null)
                                        ? MemoryImage(
                                            data[i].image as Uint8List)
                                        : null,
                                    backgroundColor: Colors.grey[300],
                                  ),
                                  title: Text("${data[i].name}"),
                                  subtitle:
                                      Text("${data[i].age}\n${data[i].course}"),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            namecontroller.text = data[i].name;
                                            agecontroller.text =
                                                data[i].age.toString();
                                            coursecontroller.text =
                                                data[i].course;
                                            image = data[i].image;
                                            showDialog(
                                              barrierDismissible: false,
                                              context: context,
                                              builder: (all) => AlertDialog(
                                                backgroundColor: Colors.white,
                                                content: Form(
                                                  key: updateformKey,
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Stack(
                                                        alignment:
                                                            Alignment.center,
                                                        children: [
                                                          StatefulBuilder(
                                                            builder: (context, setState) {
                                                              return InkWell(
                                                                onTap: () async {
                                                                  XFile? xfile = await pick.pickImage(
                                                                      source: ImageSource.camera,
                                                                      imageQuality: 50);
                                                                  image = await xfile!.readAsBytes();
                                                                  setState((){

                                                                  });
                                                                },
                                                                child: CircleAvatar(
                                                                  radius: 40,
                                                                  backgroundImage: (image != null)
                                                                      ? MemoryImage(image as Uint8List)
                                                                      : null,
                                                                  backgroundColor: Colors.grey[300],
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 15,
                                                      ),
                                                      Card(
                                                        elevation: 5,
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20)),
                                                        child: TextFormField(
                                                          controller:
                                                              namecontroller,
                                                          textInputAction:
                                                              TextInputAction
                                                                  .next,
                                                          validator: (val) {
                                                            if (val!.isEmpty) {
                                                              return "Enter name...";
                                                            }
                                                          },
                                                          onSaved: (val) {
                                                            setState(() {
                                                              names = val;
                                                            });
                                                          },
                                                          decoration:
                                                              InputDecoration(
                                                                  prefixIcon:
                                                                      Icon(
                                                                    Icons
                                                                        .person,
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                  hintText:
                                                                      "Name",
                                                                  hintStyle: TextStyle(
                                                                      color: Colors
                                                                              .grey[
                                                                          400]),
                                                                  filled: true,
                                                                  fillColor:
                                                                      Colors
                                                                          .white,
                                                                  border:
                                                                      OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            20),
                                                                    borderSide:
                                                                        BorderSide
                                                                            .none,
                                                                  )),
                                                        ),
                                                      ),
                                                      Card(
                                                        elevation: 5,
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20)),
                                                        child: TextFormField(
                                                          controller:
                                                              agecontroller,
                                                          textInputAction:
                                                              TextInputAction
                                                                  .next,
                                                          validator: (val) {
                                                            if (val!.isEmpty) {
                                                              return "Enter age...";
                                                            }
                                                          },
                                                          onSaved: (val) {
                                                            setState(() {
                                                              ages = int.parse(
                                                                  val!);
                                                            });
                                                            print(ages);
                                                          },
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          decoration:
                                                              InputDecoration(
                                                                  prefixIcon:
                                                                      Icon(
                                                                    Icons
                                                                        .real_estate_agent_rounded,
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                  hintText:
                                                                      "Age",
                                                                  hintStyle: TextStyle(
                                                                      color: Colors
                                                                              .grey[
                                                                          400]),
                                                                  filled: true,
                                                                  fillColor:
                                                                      Colors
                                                                          .white,
                                                                  border:
                                                                      OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            20),
                                                                    borderSide:
                                                                        BorderSide
                                                                            .none,
                                                                  )),
                                                        ),
                                                      ),
                                                      Card(
                                                        elevation: 5,
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20)),
                                                        child: TextFormField(
                                                          controller:
                                                              coursecontroller,
                                                          textInputAction:
                                                              TextInputAction
                                                                  .next,
                                                          validator: (val) {
                                                            if (val!.isEmpty) {
                                                              return "Enter course...";
                                                            }
                                                          },
                                                          onSaved: (val) {
                                                            setState(() {
                                                              courses = val;
                                                            });
                                                            print(courses);
                                                          },
                                                          decoration:
                                                              InputDecoration(
                                                                  prefixIcon:
                                                                      Icon(
                                                                    Icons
                                                                        .subject,
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                  hintText:
                                                                      "Course",
                                                                  hintStyle: TextStyle(
                                                                      color: Colors
                                                                              .grey[
                                                                          400]),
                                                                  filled: true,
                                                                  fillColor:
                                                                      Colors
                                                                          .white,
                                                                  border:
                                                                      OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            20),
                                                                    borderSide:
                                                                        BorderSide
                                                                            .none,
                                                                  )),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                actions: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      OutlinedButton(
                                                          onPressed: () {
                                                            namecontroller
                                                                .clear();
                                                            agecontroller
                                                                .clear();
                                                            coursecontroller
                                                                .clear();

                                                            setState(() {
                                                              names = null;
                                                              ages = null;
                                                              courses = null;
                                                              image = null;
                                                            });

                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child:
                                                              Text("Cancel")),
                                                      SizedBox(
                                                        width: 20,
                                                      ),
                                                      ElevatedButton(
                                                          onPressed: () async {
                                                            if (updateformKey
                                                                .currentState!
                                                                .validate()) {
                                                              updateformKey
                                                                  .currentState!
                                                                  .save();

                                                              Student s1 =
                                                                  Student(
                                                                name: names!,
                                                                age: ages!,
                                                                course:
                                                                    courses!,
                                                                image: image,
                                                              );

                                                              int res = await DBHelper
                                                                  .dbHelper
                                                                  .update(
                                                                      data: s1,
                                                                      id: data[
                                                                              i]
                                                                          .id!);

                                                              if (res == 1) {
                                                                setState(() {
                                                                  getAllStudent =
                                                                      DBHelper
                                                                          .dbHelper
                                                                          .fetchAllStudents();
                                                                });

                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(
                                                                  SnackBar(
                                                                    content: Text(
                                                                        "Record update successfully"),
                                                                    backgroundColor:
                                                                        Colors
                                                                            .green,
                                                                    behavior:
                                                                        SnackBarBehavior
                                                                            .floating,
                                                                  ),
                                                                );
                                                              } else {
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(
                                                                  SnackBar(
                                                                    content: Text(
                                                                        "Record updation failed"),
                                                                    backgroundColor:
                                                                        Colors
                                                                            .red,
                                                                    behavior:
                                                                        SnackBarBehavior
                                                                            .floating,
                                                                  ),
                                                                );
                                                              }
                                                              Navigator.pop(
                                                                  context);
                                                            }
                                                            namecontroller
                                                                .clear();
                                                            agecontroller
                                                                .clear();
                                                            coursecontroller
                                                                .clear();

                                                            setState(() {
                                                              names = null;
                                                              ages = null;
                                                              courses = null;
                                                              image = null;
                                                            });
                                                          },
                                                          child:
                                                              Text("Update")),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            );
                                          },
                                          icon: Icon(
                                            Icons.edit,
                                            color: Colors.blue,
                                          )),
                                      IconButton(
                                          onPressed: () async {
                                            int res = await DBHelper.dbHelper
                                                .delete(id: data[i].id!);

                                            if (res == 1) {
                                              setState(() {
                                                getAllStudent = DBHelper
                                                    .dbHelper
                                                    .fetchAllStudents();
                                              });

                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                      "Record deleted successfully "),
                                                  backgroundColor: Colors.green,
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                ),
                                              );
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                      "Record delation failed"),
                                                  backgroundColor: Colors.red,
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                ),
                                              );
                                            }
                                          },
                                          icon: Icon(
                                            Icons.delete,
                                            color: Colors.blue,
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          })
                      : Center(
                          child: Text("No data available..."),
                        );
                }
                return Center(
                  child: CircularProgressIndicator(
                    value: 0.8,
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue[900],
          child: Icon(
            Icons.add,
            size: 30,
          ),
          onPressed: () {
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (all) => AlertDialog(
                backgroundColor: Colors.white,
                content: Form(
                  key: imsertformKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          StatefulBuilder(
                            builder: (context, setState) {
                              return InkWell(
                                onTap: () async {
                                  XFile? xfile = await pick.pickImage(
                                      source: ImageSource.camera,
                                      imageQuality: 50);
                                  image = await xfile!.readAsBytes();
                                  setState((){

                                  });
                                },
                                child: CircleAvatar(
                                  radius: 40,
                                  backgroundImage: (image != null)
                                      ? MemoryImage(image as Uint8List)
                                      : null,
                                  backgroundColor: Colors.grey[300],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: TextFormField(
                          controller: namecontroller,
                          textInputAction: TextInputAction.next,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "Enter name...";
                            }
                          },
                          onSaved: (val) {
                            setState(() {
                              names = val;
                            });
                          },
                          decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.person,
                                color: Colors.black,
                              ),
                              hintText: "Name",
                              hintStyle: TextStyle(color: Colors.grey[400]),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide.none,
                              )),
                        ),
                      ),
                      Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: TextFormField(
                          controller: agecontroller,
                          textInputAction: TextInputAction.next,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "Enter age...";
                            }
                          },
                          onSaved: (val) {
                            setState(() {
                              ages = int.parse(val!);
                            });
                            print(ages);
                          },
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.real_estate_agent_rounded,
                                color: Colors.black,
                              ),
                              hintText: "Age",
                              hintStyle: TextStyle(color: Colors.grey[400]),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide.none,
                              )),
                        ),
                      ),
                      Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: TextFormField(
                          controller: coursecontroller,
                          textInputAction: TextInputAction.next,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "Enter course...";
                            }
                          },
                          onSaved: (val) {
                            setState(() {
                              courses = val;
                            });
                            print(courses);
                          },
                          decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.subject,
                                color: Colors.black,
                              ),
                              hintText: "Course",
                              hintStyle: TextStyle(color: Colors.grey[400]),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide.none,
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton(
                          onPressed: () {
                            namecontroller.clear();
                            agecontroller.clear();
                            coursecontroller.clear();

                            setState(() {
                              names = null;
                              ages = null;
                              courses = null;
                              image = null;
                            });

                            Navigator.pop(context);
                          },
                          child: Text("Cancel")),
                      SizedBox(
                        width: 20,
                      ),
                      ElevatedButton(
                          onPressed: () async {
                            if (imsertformKey.currentState!.validate()) {
                              imsertformKey.currentState!.save();

                              Student s1 = Student(
                                name: names!,
                                age: ages!,
                                course: courses!,
                                image: image,
                              );

                              int res =
                                  await DBHelper.dbHelper.insert(data: s1);

                              if (res > 0) {
                                setState(() {
                                  getAllStudent =
                                      DBHelper.dbHelper.fetchAllStudents();
                                });

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        "Record inserted successfully with id: $res..."),
                                    backgroundColor: Colors.green,
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                                print("validate successfully...");
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Record insertion failed"),
                                    backgroundColor: Colors.red,
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              }
                              Navigator.pop(context);
                            }
                            namecontroller.clear();
                            agecontroller.clear();
                            coursecontroller.clear();

                            setState(() {
                              names = null;
                              ages = null;
                              courses = null;
                              // image = null;
                            });
                          },
                          child: Text("Insert")),
                    ],
                  )
                ],
              ),
            );
          }),
    );
  }
}
