import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreenWIdget extends StatefulWidget {
  const ProfileScreenWIdget({super.key});

  @override
  State<ProfileScreenWIdget> createState() => _ProfileScreenWIdgetState();
}

enum PickImageOptions { gallery, camera }

class _ProfileScreenWIdgetState extends State<ProfileScreenWIdget> {
  TextEditingController nameController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController dobController = TextEditingController();

  static final firebaseFireStore = FirebaseFirestore.instance;

  @override
  void initState() {
    nameController = TextEditingController(
        text: FirebaseAuth.instance.currentUser?.displayName);

    mobileNumberController = TextEditingController(
        text: FirebaseAuth.instance.currentUser?.phoneNumber);

    emailController =
        TextEditingController(text: FirebaseAuth.instance.currentUser?.email);

    super.initState();
  }

  final ImagePicker _imagePicker = ImagePicker();

  File? image;
  PickImageOptions pickImageOptions = PickImageOptions.gallery;

  pickImageFrom() async {
    XFile? pickImage = await _imagePicker.pickImage(
        source: pickImageOptions == PickImageOptions.gallery
            ? ImageSource.gallery
            : ImageSource.camera);
    if (pickImage != null) {
      image = File(pickImage.path);
      setState(() {});
    }
  }

  CollectionReference users = firebaseFireStore.collection('users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 210,
            child: Stack(
              children: [
                Container(
                  height: 160,
                  width: double.infinity,
                  color: Colors.black,
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                              // color: Colors.black,
                              image:
                                  FirebaseAuth.instance.currentUser?.photoURL !=
                                          null
                                      ? DecorationImage(
                                          image: NetworkImage(FirebaseAuth
                                              .instance.currentUser!.photoURL!),
                                          fit: BoxFit.cover)
                                      : null,
                              shape: BoxShape.circle,
                              border:
                                  Border.all(color: Colors.white, width: 5)),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: IconButton(
                          onPressed: () {
                            showModalBottomSheet(
                              backgroundColor: Colors.white,
                              context: context,
                              builder: (context) {
                                return Container(
                                  height: 100,
                                  width: double.infinity,
                                  child: Column(children: [
                                    TextButton(
                                        onPressed: () {
                                          setState(() {
                                            pickImageOptions =
                                                PickImageOptions.gallery;
                                          });
                                          pickImageFrom();
                                        },
                                        child: Text("Gallary Image Picker")),
                                    TextButton(
                                        onPressed: () {
                                          setState(() {
                                            pickImageOptions =
                                                PickImageOptions.camera;
                                          });
                                          pickImageFrom();
                                        },
                                        child: Text("Camera Image Picker"))
                                  ]),
                                );
                              },
                            );
                          },
                          icon: const Icon(Icons.add_a_photo_rounded,
                              color: Colors.red),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Expanded(
              child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.0),
                      child: TextField(
                        controller: nameController,
                        decoration: const InputDecoration(
                            labelText: "Enter Full Name",
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)))),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.0),
                      child: TextField(
                        controller: mobileNumberController,
                        decoration: InputDecoration(
                            labelText: "Enter Mobile Number",
                            enabled: false,
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)))),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.0),
                      child: TextField(
                        controller: emailController,
                        decoration: const InputDecoration(
                            labelText: "Enter Email Id",
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)))),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: TextField(
                        controller: dobController,
                        decoration: const InputDecoration(
                            labelText: "Enter DOB",
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)))),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ))
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: InkWell(
          onTap: () async {
            DocumentSnapshot? user =
                await users.doc(FirebaseAuth.instance.currentUser?.uid).get();

            if (user.exists) {
              users
                  .doc(FirebaseAuth.instance.currentUser?.uid)
                  .update({
                    'full_name': nameController.text,
                    'mobile_no': mobileNumberController.text,
                    'email_id': emailController.text,
                    'dob': dobController.text
                  })
                  .then((value) => print("User Added"))
                  .catchError((error) => print("Failed to add user: $error"));
            } else {
              users
                  .doc(FirebaseAuth.instance.currentUser?.uid)
                  .set({
                    'full_name': nameController.text,
                    'mobile_no': mobileNumberController.text,
                    'email_id': emailController.text,
                    'dob': dobController.text
                  })
                  .then((value) => print("User Added"))
                  .catchError((error) => print("Failed to add user: $error"));
            }

            FirebaseAuth.instance.currentUser
                ?.updateDisplayName(nameController.text);

            FirebaseAuth.instance.currentUser?.updatePhotoURL(
                "https://images.unsplash.com/photo-1511367461989-f85a21fda167?q=80&w=1031&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D");
          },
          child: Container(
            height: 60,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.blue, borderRadius: BorderRadius.circular(12)),
            child: const Center(
              child: Text(
                "Save Profile",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
