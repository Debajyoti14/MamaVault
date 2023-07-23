import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  List<Map<String, dynamic>>? _userDocs;

  List<Map<String, dynamic>> get getUserDocs => _userDocs ?? [];

  Future fetchUserDocs() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    User currentUser = auth.currentUser!;
    try {
      CollectionReference docRef = firestore
          .collection('users')
          .doc(currentUser.uid)
          .collection('documents');
      QuerySnapshot querySnapshot = await docRef.get();
      final allData = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
      _userDocs = allData;
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
