import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:interrupt/config/UI_constraints.dart';
import 'package:interrupt/widgets/setting_component.dart';
import 'package:provider/provider.dart';

import '../provider/google_signin.dart';
import '../widgets/primary_icon_button.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: defaultPadding,
        ),
        child: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 40,
            ),
            Text(
              "Settings",
              style: TextStyle(
                fontSize: 32,
                fontFamily:
                    GoogleFonts.poppins(fontWeight: FontWeight.bold).fontFamily,
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            const SettingComponent(
              imagePath: 'assets/setting1.png',
              settingTitle: 'Theme',
            ),
            const SizedBox(
              height: 20,
            ),
            const SettingComponent(
              imagePath: 'assets/setting2.png',
              settingTitle: 'Export And Backup',
            ),
            const SizedBox(
              height: 20,
            ),
            const SettingComponent(
              imagePath: 'assets/setting3.png',
              settingTitle: 'Configure Panic Button',
            ),
            const SizedBox(
              height: 20,
            ),
            const SettingComponent(
              imagePath: 'assets/setting4.png',
              settingTitle: 'Terms and Conditions',
            ),
            const SizedBox(
              height: 20,
            ),
            const SettingComponent(
              imagePath: 'assets/setting5.png',
              settingTitle: 'About',
            ),
            const SizedBox(
              height: 130,
            ),
            PrimaryIconButton(
                buttonTitle: "Logout",
                buttonIcon: const FaIcon(FontAwesomeIcons.doorOpen),
                onPressed: () {
                  final provider =
                      Provider.of<GoogleSignInProvider>(context, listen: false);
                  provider.logout();
                })
          ],
        )),
      ),
    );
  }
}
