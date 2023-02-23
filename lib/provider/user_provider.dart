import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  List<Object?>? _userDocs;

  List<Object?> get getUserDocs => _userDocs ?? [];

  Future fetchUserDocs() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    User currentUser = _auth.currentUser!;
    try {
      CollectionReference _docRef = _firestore
          .collection('users')
          .doc(currentUser.uid)
          .collection('documents');
      QuerySnapshot querySnapshot = await _docRef.get();
      final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
      _userDocs = allData;
      notifyListeners();
    } catch (e) {
      print(e.toString());
    }
  }
}
