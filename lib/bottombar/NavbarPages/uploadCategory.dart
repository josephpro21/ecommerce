import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadCategory extends StatefulWidget {
  const UploadCategory({super.key});

  @override
  State<UploadCategory> createState() => _UploadCategoryState();
}

class _UploadCategoryState extends State<UploadCategory> {
  bool ImageSelected = false;
  File? _image;
  final _formkey = GlobalKey<FormState>();
  final categorynameControlller = TextEditingController();

  Future pickImageFile() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      ImageSelected = !ImageSelected;
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print("No image selected");
      }
    });
  }

  Future<void> uploadData() async {
    if (_formkey.currentState!.validate()) {
      _formkey.currentState!.save();
      String imageName = DateTime.now().millisecond.toString();
      Reference storageReference =
          FirebaseStorage.instance.ref().child('image/$imageName');
      UploadTask uploadTask = storageReference.putFile(_image!);
      await uploadTask.whenComplete(() async {
        String imageUrl = await storageReference.getDownloadURL();
        FirebaseFirestore.instance.collection("Category").add({
          'image': imageUrl,
          'categoryname': categorynameControlller.text,
        });
        categorynameControlller.clear();
        setState(() {
          _image = null;
        });
        const ScaffoldMessenger(
            child: SnackBar(
          content: Text("Upload Successful"),
        ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Upload Product",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold)),
          centerTitle: true,
          backgroundColor: Colors.purpleAccent,
        ),
        body: Center(
          child: Form(
              key: _formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Upload Category",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w300,
                        color: Colors.green),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Card(
                    child: Column(
                      children: [
                        ListTile(
                          title: const Text("Select image"),
                          leading: ImageSelected == true
                              ? CircleAvatar(
                                  backgroundImage: _image != null
                                      ? FileImage(_image!)
                                      : null,
                                )
                              : const Icon(Icons.image),
                          trailing: const Icon(Icons.arrow_forward),
                          onTap: pickImageFile,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: categorynameControlller,
                            decoration: const InputDecoration(
                              hintText: "Category name",
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Category Cant be empty";
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        uploadData();
                      },
                      child: const Text("Upload Now"))
                ],
              )),
        ),
      ),
    );
  }
}
