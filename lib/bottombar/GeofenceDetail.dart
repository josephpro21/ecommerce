import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geofence_service/geofence_service.dart';

import '../Geofence/displayGeofenceProducts.dart';

class Geofencing extends StatefulWidget {
  const Geofencing({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _GeofencingState();
}

class _GeofencingState extends State<Geofencing> {
  List<Geofence> _geofenceList = [];
  final _activityStreamController = StreamController<Activity>();
  final _geofenceStreamController = StreamController<Geofence>();

  final _geofenceService = GeofenceService.instance.setup(
      interval: 5000,
      accuracy: 100,
      loiteringDelayMs: 60000,
      statusChangeDelayMs: 10000,
      useActivityRecognition: true,
      allowMockLocations: false,
      printDevLog: false,
      geofenceRadiusSortType: GeofenceRadiusSortType.DESC);

  Future<void> populateGeofenceList() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('Geofence').get();
      List<Geofence> geofences = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        List<Map<String, dynamic>> radiusList =
            (data['radius'] as List<dynamic>).cast<Map<String, dynamic>>();
        List<GeofenceRadius> radius = radiusList.map((radiusData) {
          return GeofenceRadius(
            id: radiusData['id'],
            length: radiusData['length'].toDouble(),
          );
        }).toList();

        return Geofence(
          id: data['geofenceId'],
          latitude: data['latitude'],
          longitude: data['longitude'],
          radius: radius,
        );
      }).toList();

      setState(() {
        _geofenceList = geofences;
      });
    } catch (e) {
      print("Error getting geofences: $e");
      // Handle error
    }
  }

  Future _onGeofenceStatusChanged(
      Geofence geofence,
      GeofenceRadius geofenceRadius,
      GeofenceStatus geofenceStatus,
      Location location) async {
    // populateGeofenceList();
    print('geofence: ${geofence.toJson()}');
    print('geofenceRadius: ${geofenceRadius.toJson()}');
    print('geofenceStatus: ${geofenceStatus.toString()}');
    late String activeGeofenceId = geofence.id;

    if (geofenceStatus == GeofenceStatus.ENTER) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Welcome to ${geofence.id}"),
              content: SingleChildScrollView(
                child: SizedBox(
                  height: 210,
                  child: Column(
                    children: [
                      const Text("Would you like to shop ?"),
                      Center(child: const Text("Contact Seller")),
                      ListTile(
                        leading: CircleAvatar(
                          radius: 18,
                          backgroundImage:
                              AssetImage('assets/images/Whatsapp.jpeg'),
                        ),
                        title: const Text("WhatsApp"),
                        // trailing: const Icon(Icons.arrow_forward),
                        onTap: () {},
                      ),
                      ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.indigo,
                          radius: 18,
                          child: Icon(
                            Icons.phone,
                            color: Colors.white,
                          ),
                        ),
                        title: const Text("Phone Call"),
                        // trailing: const Icon(Icons.arrow_forward),
                        onTap: () {},
                      ),
                      ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.indigo,
                          radius: 18,
                          child: Icon(
                            Icons.location_on,
                            color: Colors.white,
                          ),
                        ),
                        title: const Text("Location"),
                        //trailing: const Icon(Icons.arrow_forward),
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("No"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DisplayGeofenceProducts(
                                // geofenceId: activeGeofenceId,
                                )));
                  },
                  child: const Text("Yes"),
                )
              ],
            );
          });
      Notify(geofence);
    }

    _geofenceStreamController.sink.add(geofence);
  }

  //Creating a method to show notifications.
  Future<void> Notify(Geofence geofence) async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('laucher');
    InitializationSettings initializationSettings =
        InitializationSettings(android: androidInitializationSettings);

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'Notification',
      'Geofence Alerts',
      importance: Importance.max,
      priority: Priority.high,
      enableVibration: true,
      channelDescription: 'This shows real time notifications',
      playSound: true,
    );
    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    flutterLocalNotificationsPlugin.show(
        1, geofence.id, 'Would you like to shop', notificationDetails);
  }

  // This function is to be called when the activity has changed.
  void _onActivityChanged(Activity prevActivity, Activity currActivity) {
    print('prevActivity: ${prevActivity.toJson()}');
    print('currActivity: ${currActivity.toJson()}');
    _activityStreamController.sink.add(currActivity);
  }

  // This function is to be called when the location has changed.
  void _onLocationChanged(Location location) {
    print('location: ${location.toJson()}');
  }

  // This function is to be called when a location services status change occurs
  // since the service was started.
  void _onLocationServicesStatusChanged(bool status) {
    print('isLocationServicesEnabled: $status');
  }

  // This function is used to handle errors that occur in the service.
  void _onError(error) {
    final errorCode = getErrorCodesFromError(error);
    if (errorCode == null) {
      print('Undefined error: $error');
      return;
    }

    print('ErrorCode: $errorCode');
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      populateGeofenceList(); // Call the function to populate geofences
      _geofenceService
          .addGeofenceStatusChangeListener(_onGeofenceStatusChanged);
      _geofenceService.addLocationChangeListener(_onLocationChanged);
      _geofenceService.addLocationServicesStatusChangeListener(
          _onLocationServicesStatusChanged);
      _geofenceService.addActivityChangeListener(_onActivityChanged);
      _geofenceService.addStreamErrorListener(_onError);
      _geofenceService.start(_geofenceList).catchError(_onError);
    });
  }

  @override
  void dispose() {
    _activityStreamController.close();
    _geofenceStreamController.close();
    super.dispose();
  }

// Rest of your code remains the same...
  Widget _buildContentView() {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(8.0),
      children: [
        _buildActivityMonitor(),
        const SizedBox(height: 20.0),
        _buildGeofenceMonitor(),
      ],
    );
  }

  Widget _buildActivityMonitor() {
    return StreamBuilder<Activity>(
      stream: _activityStreamController.stream,
      builder: (context, snapshot) {
        final updatedDateTime = DateTime.now();
        final content = snapshot.data?.toJson().toString() ?? '';

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('•\t\tActivity (updated: $updatedDateTime)'),
            const SizedBox(height: 10.0),
            Text(content),
          ],
        );
      },
    );
  }

  Widget _buildGeofenceMonitor() {
    return StreamBuilder<Geofence>(
      stream: _geofenceStreamController.stream,
      builder: (context, snapshot) {
        final updatedDateTime = DateTime.now();
        final content = snapshot.data?.toJson().toString() ?? '';

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('•\t\tGeofence (updated: $updatedDateTime)'),
            const SizedBox(height: 10.0),
            Text(content),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
