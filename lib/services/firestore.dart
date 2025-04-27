import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Firestore with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Map<String, dynamic>? _userData;

  Map<String, dynamic>? _dailyData;

  Map<String, dynamic>? get userData => _userData;

  Map<String, dynamic>? get dailyData => _dailyData;

  Future<ChangeNotifier> fetchUserData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      log("User is not logged in");
      return this;
    }

    _userData = await getUserData();
    _dailyData = await addDailycaloriesCollection();
    notifyListeners();

    return this;
  }

  void initListeners() {
    listenToUserData();
    listenToDailyData();
  }

  void listenToUserData() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    _firestore.collection('users').doc(uid).snapshots().listen((doc) {
      _userData = doc.data();
      notifyListeners(); // Triggers UI updates wherever the provider is used
      log("User data updated in real-time: $_userData");
    });
  }

  void listenToDailyData() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final today = Timestamp.now().toDate().toString().split(' ')[0];

    _firestore
        .collection('users')
        .doc(uid)
        .collection('DailyData')
        .doc(today)
        .snapshots()
        .listen((doc) {
          _dailyData = doc.data();
          notifyListeners();
          log("Daily data updated in real-time: $_dailyData");
        });
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

  addDailycaloriesCollection() async {
    CollectionReference dailyCaloriesCollection = _firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('DailyData');

    DocumentSnapshot doc =
        await dailyCaloriesCollection
            .doc(Timestamp.now().toDate().toString().split(' ')[0])
            .get();

    if (doc.exists) {
      log("Document already exists");
      return doc.data() as Map<String, dynamic>?;
    }
    dailyCaloriesCollection
        .doc(Timestamp.now().toDate().toString().split(' ')[0])
        .set({
          'date': Timestamp.now().toDate(),
          'caloriesConsumed': 0,
          'protien': 0,
          'carbs': 0,
          'fat': 0,
        })
        .then((value) => log("Daily calories added"))
        .catchError((error) => log("Failed to add daily calories: $error"));
    return doc.data() as Map<String, dynamic>?;
  }
}
