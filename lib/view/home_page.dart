import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:interrupt/model/user_model.dart';
import 'package:interrupt/utils/date_formatter.dart';
import 'package:interrupt/view/bottom_nav_bar.dart';
import 'package:interrupt/view/onboarding/add_details.dart';
import 'package:interrupt/view/signin_page.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isOnboarded = false;

  @override
  void initState() {
    _checkLoginPrefs();
    super.initState();
  }

  void _checkLoginPrefs() async {
    // final prefs = await SharedPreferences.getInstance();
    final prefs = await checkUserOnboarded();
    setState(
      () {
        isOnboarded = prefs ?? false;
      },
    );
  }

  Future<bool?> checkUserOnboarded() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    User currentUser = auth.currentUser!;
    try {
      DocumentReference docRef =
          firestore.collection('users').doc(currentUser.uid);
      DocumentSnapshot docData = await docRef.get();

      final userData =
          UserModel.fromJson(docData.data() as Map<String, dynamic>);
      if (userData.bloodGroup == "" ||
          userData.allergies.isEmpty ||
          userData.medicines.isEmpty) {
        return false;
      }
      return true;
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasData) {
              createUser();
              if (isOnboarded) {
                return const BottomNav();
              } else {
                return const AddDetailsScreen();
              }
            } else if (snapshot.hasError) {
              return const Center(
                child: Text("Something went wrong!"),
              );
            } else {
              return const SignInPage();
            }
          },
        ),
      );

  Future createUser() async {
    final user = FirebaseAuth.instance.currentUser!;

    final finalUser =
        FirebaseFirestore.instance.collection('users').doc(user.uid);
    FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) async {
      if (!documentSnapshot.exists) {
        final data = {
          'account_created': formatdateTimeToStoreInFireStore(DateTime.now()),
          'email': user.email,
          'name': user.displayName,
          'uid': user.uid,
          'image': user.photoURL
        };
        await finalUser.set(data);
      } else {
        return 0;
      }
    });
  }
}
