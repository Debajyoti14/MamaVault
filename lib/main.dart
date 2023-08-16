import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:interrupt/resources/theme.dart';
import 'package:interrupt/firebase_options.dart';
import 'package:interrupt/view_model/expire_provider.dart';
import 'package:interrupt/view_model/google_signin.dart';
import 'package:interrupt/view_model/memory_provider.dart';
import 'package:interrupt/view_model/theme_provider.dart';
import 'package:interrupt/view_model/user_provider.dart';
import 'package:interrupt/view_model/verified_number_provider.dart';
import 'package:interrupt/view/splash.dart';
import 'package:provider/provider.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
    SystemUiOverlay.bottom,
  ]);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeProvider themeChangeProvider = ThemeProvider();
  @override
  void initState() {
    super.initState();
    getCurrentAppTheme();
  }

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
        await themeChangeProvider.darkThemePreference.getTheme();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => GoogleSignInProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ExpireProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => NumberProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => MemoryProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
        ),
      ],
      child: ScreenUtilInit(
          designSize: const Size(393, 852),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) {
            return Consumer<ThemeProvider>(
              builder: (context, ThemeProvider themeNotifier, child) {
                final provider = Provider.of<ThemeProvider>(context);
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'MamaVault',
                  theme: provider.darkTheme ? darkThemeData : lightThemeData,
                  home: const SplashScreen(),
                );
              },
            );
          }),
    );
  }
}
