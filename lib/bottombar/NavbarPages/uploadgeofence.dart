import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UploadGeofence extends StatefulWidget {
  const UploadGeofence({super.key});

  @override
  State<UploadGeofence> createState() => _UploadGeofenceState();
}

class _UploadGeofenceState extends State<UploadGeofence> {
  final _formkey = GlobalKey<FormState>();
  final idController = TextEditingController();
  final latController = TextEditingController();
  final longController = TextEditingController();
  final radiusController = TextEditingController();

  Future<void> uploadGeofenceData() async {
    if (_formkey.currentState!.validate()) {
      _formkey.currentState!.save();
      try {
        //add the GeofenceRadius
        List<Map<String, dynamic>> radiusList =
            radiusController.text.split(",").map((radius) {
          return {
            'id': 'radius_$radius',
            'length': double.parse(radius.trim()),
          };
        }).toList();

        //upload to firebase
        await FirebaseFirestore.instance.collection('Geofence').add({
          "geofenceId": idController.text,
          'latitude': double.parse(latController.text),
          'longitude': double.parse(longController.text),
          'radius': radiusList
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Added Successfully")));
        idController.clear();
        latController.clear();
        longController.clear();
        radiusController.clear();
      } catch (e) {
        print(e);
      }
    }
  }

  // double latitude = double.parse(latController.text);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Geofence'),
          backgroundColor: Colors.purpleAccent,
          centerTitle: true,
        ),
        body: Center(
          child: Card(
            child: Form(
              key: _formkey,
              child: Column(
                children: [
                  TextFormField(
                    controller: idController,
                    decoration: const InputDecoration(
                      hintText: "Id",
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("Field Cant be null"),
                          behavior: SnackBarBehavior.floating,
                          elevation: 8,
                        ));
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: latController,
                    decoration: const InputDecoration(
                      hintText: "Latitude",
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("Field Cant be null"),
                          behavior: SnackBarBehavior.floating,
                          elevation: 8,
                        ));
                      }
                      return null;
                    },
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: longController,
                    decoration: const InputDecoration(
                      hintText: "Longitude",
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("Field Cant be null"),
                          behavior: SnackBarBehavior.floating,
                          elevation: 8,
                        ));
                      }
                      return null;
                    },
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: radiusController,
                    decoration: const InputDecoration(
                      hintText: "Radius",
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("Field Cant be null"),
                          behavior: SnackBarBehavior.floating,
                          elevation: 8,
                        ));
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        uploadGeofenceData();
                      },
                      child: const Text("Submit"))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
