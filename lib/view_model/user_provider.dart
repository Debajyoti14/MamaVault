import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:interrupt/model/document_model.dart';
import 'package:interrupt/model/user_model.dart';

class UserProvider extends ChangeNotifier {
  List<DocumentModel>? _userDocs;

  late UserModel _userData;

  List<DocumentModel> get getUserDocs => _userDocs ?? [];

  UserModel get userData => _userData;

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
          .map((doc) =>
              DocumentModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      _userDocs = allData;
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<bool?> checkUserOnboarded() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    User currentUser = auth.currentUser!;
    try {
      DocumentReference docRef =
          firestore.collection('users').doc(currentUser.uid);
      DocumentSnapshot docData = await docRef.get();

      _userData = UserModel.fromJson(docData.data() as Map<String, dynamic>);
      notifyListeners();
      if (_userData.bloodGroup == "" ||
          _userData.allergies.isEmpty ||
          _userData.medicines.isEmpty) {
        return false;
      }
      return true;
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<void> fetchUser() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    User currentUser = auth.currentUser!;
    try {
      DocumentReference docRef =
          firestore.collection('users').doc(currentUser.uid);
      DocumentSnapshot docData = await docRef.get();

      _userData = UserModel.fromJson(docData.data() as Map<String, dynamic>);
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
