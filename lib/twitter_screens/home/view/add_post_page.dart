import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddPostPage extends StatefulWidget {
  const AddPostPage({super.key});

  @override
  State<AddPostPage> createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  List<File> images = [];
  ImagePicker imagePicker = ImagePicker();
  TextEditingController textEditingController = TextEditingController();

  getImages() {
    imagePicker.pickMultiImage().then((value) {
      print('value' + value.toString());
      if (value.isNotEmpty) {
        for (var element in value) {
          print(element.path);

          setState(() {
            images.add(File(element.path));
          });
        }
      }
      print(images);
    });
  }

  List<String> postUrl = [];

  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  firestoreDataPush() {
    firebaseFirestore
        .collection('post')
        .doc('${DateTime.now().millisecondsSinceEpoch}')
        .set({
      "user_image": FirebaseAuth.instance.currentUser?.photoURL,
      "user_full_name": FirebaseAuth.instance.currentUser?.displayName,
      "user_name": "@${FirebaseAuth.instance.currentUser?.displayName}",
      "posted_at": DateTime.now().subtract(Duration(hours: 10)),
      "caption": textEditingController.text,
      "hashtags": textEditingController.text
          .split(' ')
          .where((element) => element.contains('#'))
          .toList(),
      "comment_count": 0,
      "repost_count": 0,
      "like_count": 0,
      "activity": {
        "type": "liked",
        "users": [
          FirebaseAuth.instance.currentUser?.displayName,
        ]
      },
      "is_verified": false,
      "isliked": true,
      "posted_user_id": FirebaseAuth.instance.currentUser?.uid,
      "post_images_url": postUrl
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
        child: InkWell(
          onTap: () async {
            if (images.isNotEmpty) {
              for (var element in images) {
                Reference ref = firebaseStorage
                    .ref()
                    .child('post')
                    .child('${DateTime.now().millisecondsSinceEpoch}');
                final metadata = SettableMetadata(
                  contentType: 'image/jpeg',
                  customMetadata: {'picked-file-path': element.path},
                );
                UploadTask uploadTask;
                if (kIsWeb) {
                  uploadTask =
                      ref.putData(await element.readAsBytes(), metadata);
                } else {
                  uploadTask = ref.putFile(File(element.path), metadata);
                }
                setState(() {});
                uploadTask.whenComplete(() async {
                  postUrl.add(await ref.getDownloadURL());
                  setState(() {});
                  if (postUrl.length == images.length) {
                    firestoreDataPush();
                  }
                });
              }
            }
          },
          child: const BottomAppBar(
            color: Colors.black,
            height: 50,
            child: Center(
              child: Text(
                'Post Item',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
      appBar: AppBar(
        title: const Text(
          'Add Post Page',
          style: TextStyle(
              color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(children: [
        if (images.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Center(
              child: InkWell(
                onTap: () {
                  getImages();
                },
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(border: Border.all()),
                  child: const Center(
                      child: Icon(
                    Icons.add,
                    size: 50,
                  )),
                ),
              ),
            ),
          ),
        SizedBox(
          height: 100,
          width: double.infinity,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: images.length,
            itemBuilder: (context, index) {
              return Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                              image: FileImage(images[index]),
                              fit: BoxFit.cover)),
                    ),
                  ),
                  if (index == (images.length - 1))
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Center(
                        child: InkWell(
                          onTap: () {
                            getImages();
                          },
                          child: Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(border: Border.all()),
                            child: const Center(
                                child: Icon(
                              Icons.add,
                              size: 50,
                            )),
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: TextField(
            controller: textEditingController,
            decoration: const InputDecoration(border: OutlineInputBorder()),
            minLines: 4,
            maxLines: 8,
          ),
        ),
      ]),
    );
  }
}
