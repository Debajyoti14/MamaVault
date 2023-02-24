import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:interrupt/widgets/primary_button.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../provider/user_provider.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  Future fetchTimeline(List allDocs) async {
    print(allDocs.length);
    print(allDocs);
    var url = Uri.parse(
        "https://us-central1-mamavault-019.cloudfunctions.net/getTimeline");
    Map data = {
      "documents": allDocs //array of all documents
    };
    var body = json.encode(data);
    var response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: body,
    );

    print(response.body.length);
    List a = json.decode(response.body);
    print(a.length);
  }

  @override
  Widget build(BuildContext context) {
    List allUserDocs = Provider.of<UserProvider>(context).getUserDocs;
    return Scaffold(
      body: PrimaryButton(
          buttonTitle: "Test",
          onPressed: () {
            fetchTimeline(allUserDocs);
          }),
    );
  }
}
