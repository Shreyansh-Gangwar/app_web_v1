import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Firestore with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Map<String, dynamic>? _userData;

  Map<String, dynamic>? get userData => _userData;

  Future<ChangeNotifier> fetchUserData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return this;

    _userData = await getUserData();
    notifyListeners();
    return this;
  }

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
          'name': 'User',
          'scannedCount': 0,
          'savedCount': 0,
          'dailyCalories': 2000,
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

  updateUserData(String field, dynamic value) {
    _firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({field: value})
        .then((value) => log("User data updated"))
        .catchError((error) => log("Failed to update user data: $error"));
  }
}
