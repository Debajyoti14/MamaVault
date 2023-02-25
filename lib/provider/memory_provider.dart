import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MemoryProvider extends ChangeNotifier {
  List<Object?>? _userMemories;

  List<Object?> get getUserMemories => _userMemories ?? [];

  Future fetchUserMemories() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    User currentUser = _auth.currentUser!;
    try {
      CollectionReference _docRef = _firestore
          .collection('users')
          .doc(currentUser.uid)
          .collection('memories');
      QuerySnapshot querySnapshot = await _docRef.get();
      final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
      _userMemories = allData;
      notifyListeners();
    } catch (e) {
      print(e.toString());
    }
  }
}
