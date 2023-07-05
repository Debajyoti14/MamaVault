import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MemoryProvider extends ChangeNotifier {
  List<Object?>? _userMemories;

  List<Object?> get getUserMemories => _userMemories ?? [];

  Future fetchUserMemories() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    User currentUser = auth.currentUser!;
    try {
      CollectionReference docRef = firestore
          .collection('users')
          .doc(currentUser.uid)
          .collection('memories');
      QuerySnapshot querySnapshot = await docRef.get();
      final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
      _userMemories = allData;
      notifyListeners();
    } catch (e) {
      print(e.toString());
    }
  }
}
