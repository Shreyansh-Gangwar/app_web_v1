import 'dart:developer';

import 'package:app_web_v1/services/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Firestore {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch user data from Firestore
  Future<Map<String, dynamic>?> getUserData() async {
    try {
      DocumentSnapshot doc =
          await _firestore
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .get();
      log("User data fetched: ${doc.data() as Map<String, dynamic>?}");
      return doc.data() as Map<String, dynamic>?;
    } catch (e) {
      log("Error fetching user data: $e");
      return null;
    }
  }

  initialDataSet() {
    _firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
          'name': 'test',
          'scannedCount': 0,
          'savedCount': 0,
          'joiningDate': Timestamp.now(),
        })
        .then((value) {
          log("Successfully set initial data");
        })
        .catchError((error) {
          log("Failed to set initial data: $error");
        });
  }

  sendData() {
    _firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('scanned')
        .doc(
          Timestamp.fromMillisecondsSinceEpoch(
            DateTime.now().microsecond,
          ).toString(),
        )
        .set({'name': 'test'})
        .then((value) => log("Data sent"))
        .catchError((error) => log("Failed to send data: $error"));
  }
}
