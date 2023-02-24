// import 'dart:convert';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:interrupt/provider/user_provider.dart';
// import 'package:interrupt/widgets/primary_icon_button.dart';
// import 'package:provider/provider.dart';

// import '../config/UI_constraints.dart';
// import '../config/color_pallete.dart';
// import 'package:http/http.dart' as http;

// class DashboardScreen extends StatefulWidget {
//   const DashboardScreen({super.key});

//   @override
//   State<DashboardScreen> createState() => _DashboardScreenState();
// }

// class _DashboardScreenState extends State<DashboardScreen> {
//   final user = FirebaseAuth.instance.currentUser!;
//   late List<dynamic> timelineData;

//   Future fetchTimeline(List allDocs) async {
//     var url = Uri.parse(
//         "https://us-central1-mamavault-019.cloudfunctions.net/getTimeline");
//     Map data = {
//       "documents": allDocs //array of all documents
//     };
//     var body = json.encode(data);
//     var response = await http.post(
//       url,
//       headers: {
//         "Content-Type": "application/json",
//       },
//       body: body,
//     );
//     return response.body;
//   }

//   @override
//   Widget build(BuildContext context) {
//     List allUserDocs = Provider.of<UserProvider>(context).getUserDocs;
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Container(
//           padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
//           height: MediaQuery.of(context).size.height * 3,
//           width: MediaQuery.of(context).size.width,
//           child: SizedBox(
//             width: double.infinity,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 const SizedBox(height: 20),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     const Align(
//                       alignment: Alignment.centerLeft,
//                       child: Text(
//                         'Dashboard',
//                         style: TextStyle(
//                             fontSize: 32, fontWeight: FontWeight.bold),
//                         textAlign: TextAlign.left,
//                       ),
//                     ),
//                     CircleAvatar(
//                       radius: 30,
//                       backgroundColor: PalleteColor.primaryPurple,
//                       child: CircleAvatar(
//                         backgroundImage: NetworkImage(
//                           user.photoURL!,
//                         ),
//                         radius: 25,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 20),
//                 Container(
//                   padding: const EdgeInsets.all(16.0),
//                   decoration: const BoxDecoration(
//                     color: Color.fromARGB(255, 255, 235, 233),
//                     borderRadius: BorderRadius.all(Radius.circular(8)),
//                   ),
//                   height: 104,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: const [
//                           Text(
//                             'Panic Button',
//                             style: TextStyle(
//                                 fontWeight: FontWeight.bold, fontSize: 16),
//                           ),
//                           SizedBox(
//                             width: 153,
//                             child: Text(
//                               'Panic Button is made for emergency situation so be careful',
//                               style: TextStyle(fontSize: 10),
//                             ),
//                           )
//                         ],
//                       ),
//                       SizedBox(
//                         width: 136,
//                         height: 50,
//                         child: PrimaryIconButton(
//                           backgroundColor: Colors.red,
//                           buttonTitle: 'Panic',
//                           buttonIcon: const FaIcon(FontAwesomeIcons.surprise),
//                           onPressed: () {},
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 FutureBuilder<dynamic>(
//                   future: fetchTimeline(allUserDocs),
//                   builder: (
//                     BuildContext context,
//                     AsyncSnapshot<dynamic> snapshot,
//                   ) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return const CircularProgressIndicator();
//                     } else if (snapshot.connectionState ==
//                         ConnectionState.done) {
//                       if (snapshot.hasError) {
//                         return const Text('Error');
//                       } else if (snapshot.hasData) {
//                         print(snapshot.data);
//                         return Center(
//                           child: const Text('Center'),
//                         );
//                       } else {
//                         return const Text('Empty data');
//                       }
//                     } else {
//                       return Text('State: ${snapshot.connectionState}');
//                     }
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
