// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:app_web_v1/widgets/snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthMethod {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static String uid = '1';

  // Sign up user with email & password

  Future<String> signupUser({
    required String email,
    required String password,
    required String name,
  }) async {
    String res = "Some error Occurred";
    try {
      if (email.isNotEmpty || password.isNotEmpty || name.isNotEmpty) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        uid = FirebaseAuth.instance.currentUser!.uid;
        log(cred.user!.uid);
        await _firestore.collection("users").doc(cred.user!.uid).set({
          'name': name,
          'uid': cred.user!.uid,
          'email': email,
          'scanned': 0,
        });

        res = "success";
      }
    } catch (err) {
      return err.toString();
    }
    return res;
  }

  //Log in user to an already existing email account

  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error Occurred";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    } catch (err) {
      return err.toString();
    }
    return res;
  }

  signOut() async {
    await _auth.signOut();
  }
  // Sign in users with google

  signinwithGoogle(BuildContext context) async {
    String res = "Some error Occurred";
    try {
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication gAuth = await gUser!.authentication;
      final OAuthCredential userCred = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(userCred);
      uid = FirebaseAuth.instance.currentUser!.uid;
      await _firestore.collection("users").doc(uid).update({
        'uid': FirebaseAuth.instance.currentUser!.uid,
        'email': FirebaseAuth.instance.currentUser!.email,
      });
      await Future.delayed(const Duration(milliseconds: 500));
      res = 'success';
      showSnackBar(context, res);
      log(res);
    } catch (err) {
      log(err.toString());
      showSnackBar(context, err.toString());
    }
    return res;
  }

  Future<bool> isLoggedIn() async {
    User? user = _auth.currentUser;
    if (user != null) {
      return true;
    } else {
      return false;
    }
  }
}
