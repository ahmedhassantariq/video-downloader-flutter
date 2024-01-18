import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/controlsModel.dart';
class FirebaseServices extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String> getTokenFromUser(String userUID) async {
    DocumentSnapshot<Map<String, dynamic>> userCredentials = await _firestore
        .collection('users').doc(userUID).get();
    return userCredentials.get('fcmToken');
  }

  Future<ControlsModel> getControls() async {
    DocumentSnapshot<Map<String, dynamic>> doc = await  _firestore.collection('settings').doc("controls").get();
    return ControlsModel.fromMap(doc);
  }

  Future<void> saveDeviceToken(String fcmToken) async {
    try{
      _firestore.collection('users').doc(_firebaseAuth.currentUser!.uid).update({
        'fcmToken': fcmToken,
      });
    } on FirebaseAuthException catch(e){
      throw Exception(e.code);
    }
  }

}
