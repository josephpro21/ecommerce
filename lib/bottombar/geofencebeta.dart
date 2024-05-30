import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geofence_service/geofence_service.dart';

class GeofenceFirebase extends StatefulWidget {
  const GeofenceFirebase({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _GeofenceFirebaseState();
}

class _GeofenceFirebaseState extends State<GeofenceFirebase> {
  final _geofenceStreamController = StreamController<Geofence>();

  final _geofenceService = GeofenceService.instance;

  // Firestore reference
  final _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeGeofences();
    });
  }

  Future<void> _initializeGeofences() async {
    // Fetch geofence data from Firestore
    final geofenceCollection = _firestore.collection('Geofence');
    final snapshot = await geofenceCollection.get();

    snapshot.docs.forEach((doc) {
      final id = doc.id;
      final latitude = doc['latitude'] as double;
      final longitude = doc['longitude'] as double;
      final radius = 100.0; // Hardcoded radius for now

      // Create geofence
      final geofence = Geofence(
        id: id,
        latitude: latitude,
        longitude: longitude,
        radius: [
          GeofenceRadius(id: 'radius_$id', length: radius),
        ],
      );

      // Add geofence
      _geofenceService.addGeofence(geofence);
    });

    // Start monitoring geofences
    _geofenceService.addGeofenceStatusChangeListener(_onGeofenceStatusChanged);
    _geofenceService.start();
  }

  Future<void> _onGeofenceStatusChanged(
      Geofence geofence,
      GeofenceRadius geofenceRadius,
      GeofenceStatus geofenceStatus,
      Location location) async {
    if (geofenceStatus == GeofenceStatus.ENTER) {
      _showGeofenceAlert(geofence);
    }
  }

  void _showGeofenceAlert(Geofence geofence) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Welcome to Geofence ${geofence.id}'),
        content: Text('Would you like to shop here?'),
        actions: [
          TextButton(
            onPressed: () {
              // Handle shop action
              Navigator.of(context).pop();
            },
            child: Text('Yes'),
          ),
          TextButton(
            onPressed: () {
              // Handle other action
              Navigator.of(context).pop();
            },
            child: Text('No'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _geofenceStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Geofence Service'),
          centerTitle: true,
        ),
        body: _buildContentView(),
      ),
    );
  }

  Widget _buildContentView() {
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
}
