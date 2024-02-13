import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io' as io;

class ProfileScreenWIdget extends StatefulWidget {
  const ProfileScreenWIdget({super.key});

  @override
  State<ProfileScreenWIdget> createState() => _ProfileScreenWIdgetState();
}

enum PickImageOptions { gallery, camera }

class _ProfileScreenWIdgetState extends State<ProfileScreenWIdget> {
  TextEditingController nameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController alternateMobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController dobController = TextEditingController();

  static FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  DocumentSnapshot? user;
  String? profileUrl;
  @override
  void initState() {
    getUserDetails();
    super.initState();
  }

  ImagePicker imagePicker = ImagePicker();
  pickImage() {
    ImagePicker().pickImage(source: ImageSource.gallery).then((value) {
      uploadFile(value);
    });
  }

  List<UploadTask> _uploadTasks = [];

  Future<UploadTask?> uploadFile(XFile? file) async {
    if (file == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No file was selected'),
        ),
      );

      return null;
    }

    UploadTask uploadTask;

    // Create a Reference to the file
    Reference ref = FirebaseStorage.instance.ref().child('profile_pics').child(
        '/${firebaseAuth.currentUser?.uid}/${DateTime.now().millisecondsSinceEpoch}');

    final metadata = SettableMetadata(
      contentType: 'image/jpeg',
      customMetadata: {'picked-file-path': file.path},
    );

    if (kIsWeb) {
      uploadTask = ref.putData(await file.readAsBytes(), metadata);
    } else {
      uploadTask = ref.putFile(io.File(file.path), metadata);
    }
    uploadTask.whenComplete(() async {
      profileUrl = await ref.getDownloadURL();
      setState(() {});
    });

    return Future.value(uploadTask);
  }

  getUserDetails() async {
    user = await users.doc(firebaseAuth.currentUser?.uid).get();

    if (user?.exists ?? false) {
      nameController =
          TextEditingController(text: (user?.data() as Map)['full_name']);
      mobileController =
          TextEditingController(text: (user?.data() as Map)['mobile']);
      emailController =
          TextEditingController(text: (user?.data() as Map)['email_id']);
      dobController = TextEditingController(text: (user?.data() as Map)['dob']);
    }
    setState(() {});
  }

  CollectionReference users = firebaseFirestore.collection('users');

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () async {
              if (user?.exists ?? false) {
                users
                    .doc(firebaseAuth.currentUser?.uid)
                    .update({
                      'full_name': nameController.text,
                      'mobile': mobileController.text,
                      'email_id': emailController.text,
                      'dob': dobController.text,
                      'profile_pic': profileUrl
                    })
                    .then((value) => print("User Added"))
                    .catchError((error) => print("Failed to add user: $error"));
              } else {
                users
                    .doc(firebaseAuth.currentUser?.uid)
                    .set({
                      'full_name': nameController.text,
                      'mobile': mobileController.text,
                      'email_id': emailController.text,
                      'dob': dobController.text,
                      'profile_pic': profileUrl
                    })
                    .then((value) => print("User Added"))
                    .catchError((error) => print("Failed to add user: $error"));
              }
              firebaseAuth.currentUser?.updatePhotoURL(profileUrl);
              FirebaseAuth.instance.currentUser?.reload();
              setState(() {});
              firebaseAuth.currentUser?.updateDisplayName(nameController.text);
            },
            child: Container(
              height: 40,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.black, borderRadius: BorderRadius.circular(8)),
              child: const Center(
                child: Text(
                  'Save Profile',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ),
        body: Column(children: [
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: const BoxDecoration(color: Colors.black),
                ),
              ),
              SizedBox(
                height: 180,
                width: double.infinity,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: InkWell(
                    onTap: () {
                      pickImage();
                    },
                    child: Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                          // color: Colors.black,
                          image: profileUrl != null
                              ? DecorationImage(
                                  image: NetworkImage(profileUrl!),
                                  fit: BoxFit.cover)
                              : FirebaseAuth.instance.currentUser?.photoURL !=
                                      null
                                  ? DecorationImage(
                                      image: NetworkImage(FirebaseAuth
                                          .instance.currentUser!.photoURL!),
                                      fit: BoxFit.cover)
                                  : null,
                          border: Border.all(color: Colors.white, width: 3),
                          shape: BoxShape.circle),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
              child: ListView(
            children: [
              const SizedBox(
                height: 50,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12),
                child: TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                      labelText: 'Enter Full Name',
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                      border: OutlineInputBorder()),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12),
                child: TextField(
                  controller: mobileController,
                  decoration: const InputDecoration(
                      labelText: 'Enter Mobile Number',
                      enabled: false,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                      border: OutlineInputBorder(),
                      disabledBorder: OutlineInputBorder()),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12),
                child: TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                      labelText: 'Enter Email id',
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                      border: OutlineInputBorder()),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12),
                child: TextField(
                  controller: dobController,
                  decoration: const InputDecoration(
                      labelText: 'Enter DOB',
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                      border: OutlineInputBorder()),
                ),
              ),
            ],
          ))
        ]),
      ),
    );
  }
}
