import 'dart:developer';

import 'package:app_web_v1/services/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Firestore {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch user data from Firestore
  Future<Map<String, dynamic>?> getUserData() async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(AuthMethod.uid).get();
      return doc.data() as Map<String, dynamic>?;
    } catch (e) {
      log("Error fetching user data: $e");
      return null;
    }
  }

  sendData() {
    _firestore
        .collection('users')
        .doc(AuthMethod.uid)
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
