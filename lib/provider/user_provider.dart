import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  Map<String, dynamic>? _userDocs;

  Map<String, dynamic> get getUserDocs => _userDocs!;

  Future fetchUserDocs() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    User currentUser = _auth.currentUser!;
    try {
      DocumentSnapshot snap = await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .collection('documents')
          .doc()
          .get();
      print('Idhar hain bc');
      print(snap.data());
      _userDocs = {};
      print(_userDocs);
      notifyListeners();
    } catch (e) {
      print(e.toString());
    }
  }
}
