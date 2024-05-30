import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:testtwo/bottombar/NavbarPages/uploadCategory.dart';
import 'package:testtwo/bottombar/NavbarPages/uploadgeofence.dart';

class UploadProduct extends StatefulWidget {
  const UploadProduct({super.key});

  @override
  State<UploadProduct> createState() => _UploadProductState();
}

class _UploadProductState extends State<UploadProduct> {
  bool ImageSelected = false;
  File? _image;
  final _formkey = GlobalKey<FormState>();
  final productnameControlller = TextEditingController();
  final productpriceControlller = TextEditingController();
  final productdescriptionControlller = TextEditingController();
  final geofendeIdController = TextEditingController();

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
        FirebaseFirestore.instance.collection("products").add({
          'image': imageUrl,
          'productname': productnameControlller.text,
          'productprice': productpriceControlller.text,
          'productdescription': productdescriptionControlller.text,
          'geofenceId': geofendeIdController.text
        });
        productdescriptionControlller.clear();
        productpriceControlller.clear();
        productnameControlller.clear();
        geofendeIdController.clear();
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
        drawer: Drawer(
          child: Column(
            children: [
              Container(
                height: 100,
                color: Colors.green,
              ),
              ListTile(
                leading: Icon(Icons.add),
                title: const Text("Add Geofence"),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const UploadGeofence()));
                },
              ),
              ListTile(
                leading: Icon(Icons.add),
                title: const Text("Add Category"),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const UploadCategory()));
                },
              )
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Form(
              key: _formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Upload Product",
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
                        TextFormField(
                          controller: productnameControlller,
                          decoration: const InputDecoration(
                            hintText: "Enter Product name",
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Name Cant be empty";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: productpriceControlller,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: "Enter Product Price",
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Price Cant be empty";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: productdescriptionControlller,
                          decoration: const InputDecoration(
                            hintText: "Enter Product Description",
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Cant be empty";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: geofendeIdController,
                          decoration: const InputDecoration(
                            hintText: "Enter Geofence ID",
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Geofence ID Cant be empty";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        )
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
