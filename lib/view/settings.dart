import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:interrupt/resources/UI_constraints.dart';
import 'package:interrupt/view/Panic%20Mode/setup_panic.dart';
import 'package:interrupt/resources/components/setting_component.dart';
import 'package:provider/provider.dart';

import '../view_model/google_signin.dart';
import '../resources/components/primary_icon_button.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: defaultPadding,
        ),
        child: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 40.h,
            ),
            Text(
              "Settings",
              style: TextStyle(
                fontSize: 32.sp,
                fontFamily:
                    GoogleFonts.poppins(fontWeight: FontWeight.bold).fontFamily,
              ),
            ),
            SizedBox(
              height: 40.h,
            ),
            const SettingComponent(
              imagePath: 'assets/setting1.png',
              settingTitle: 'Theme',
            ),
            SizedBox(
              height: 20.h,
            ),
            const SettingComponent(
              imagePath: 'assets/setting2.png',
              settingTitle: 'Export And Backup',
            ),
            SizedBox(
              height: 20.h,
            ),
            SettingComponent(
              imagePath: 'assets/setting3.png',
              settingTitle: 'Configure Panic Button',
              onPressed: () {
                Navigator.of(context).push(CupertinoPageRoute(
                  builder: (context) => const SetupPanicScreen(),
                ));
              },
            ),
            SizedBox(
              height: 20.h,
            ),
            const SettingComponent(
              imagePath: 'assets/setting4.png',
              settingTitle: 'Terms and Conditions',
            ),
            SizedBox(
              height: 20.h,
            ),
            const SettingComponent(
              imagePath: 'assets/setting5.png',
              settingTitle: 'About',
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.075,
            ),
            PrimaryIconButton(
              buttonTitle: "Logout",
              buttonIcon: const FaIcon(FontAwesomeIcons.doorOpen),
              onPressed: () {
                final provider =
                    Provider.of<GoogleSignInProvider>(context, listen: false);
                provider.logout();
              },
            ),
          ],
        )),
      ),
    ));
  }
}
