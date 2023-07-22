import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NumberProvider extends ChangeNotifier {
  List<Object?>? _userNumber;

  List<Object?> get gerVerifiedNumber => _userNumber ?? [];

  Future fetchAllNumber() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    User currentUser = auth.currentUser!;
    try {
      CollectionReference docRef = firestore
          .collection('users')
          .doc(currentUser.uid)
          .collection('panic_info');
      QuerySnapshot querySnapshot = await docRef.get();
      final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
      print("In Number Provider");
      _userNumber = allData;
      print(_userNumber);
      notifyListeners();
    } catch (e) {
      print(e.toString());
    }
  }
}
