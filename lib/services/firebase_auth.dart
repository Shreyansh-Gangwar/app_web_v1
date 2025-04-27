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
    String? name,
  }) async {
    if (email.isEmpty || password.isEmpty) {
      return "Email and password cannot be empty";
    }
    if (!RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    ).hasMatch(email)) {
      return "Invalid email format";
    }
    if (password.length < 6) {
      return "Password must be at least 6 characters long";
    }

    try {
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      uid = cred.user!.uid;
      log(uid);

      await _firestore.collection("users").doc(uid).set({
        'name': name ?? 'User',
        'uid': uid,
        'email': email,
        'scanned': 0,
      });

      return "success";
    } on FirebaseAuthException catch (e) {
      return e.message ?? "An unexpected error occurred";
    } catch (err) {
      log(err.toString());
      return "An unexpected error occurred";
    }
  }

  // Log in user to an already existing email account
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    if (email.isEmpty || password.isEmpty) {
      return "Please enter all the fields";
    }

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return "success";
    } on FirebaseAuthException catch (e) {
      return e.message ?? "An unexpected error occurred";
    } catch (err) {
      log(err.toString());
      return "An unexpected error occurred";
    }
  }

  // Sign out user
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (err) {
      log("Error signing out: $err");
    }
  }

  // Sign in users with Google
  Future<String> signinwithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
      if (gUser == null) {
        return "Google sign-in aborted";
      }

      final GoogleSignInAuthentication gAuth = await gUser.authentication;
      final OAuthCredential userCred = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      UserCredential cred = await _auth.signInWithCredential(userCred);
      uid = cred.user!.uid;

      await _firestore.collection("users").doc(uid).set({
        'uid': uid,
        'email': cred.user!.email,
      }, SetOptions(merge: true));

      showSnackBar(context, "success");
      log("Google sign-in successful: $uid");
      return "success";
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message ?? "An unexpected error occurred");
      log(e.toString());
      return e.message ?? "An unexpected error occurred";
    } catch (err) {
      showSnackBar(context, "An unexpected error occurred");
      log(err.toString());
      return "An unexpected error occurred";
    }
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    return _auth.currentUser != null;
  }
}
