import 'package:flutter/material.dart';
import 'package:mytravaly_flutter_assesment/Constants/prefs.dart';
import 'package:provider/provider.dart';
import 'Constants/routes.dart';
import 'CustomUI/theme/app_theme.dart';
import 'Screens/home.dart';
import 'Screens/login.dart';
import 'Utils/shared_preferences.dart';
import 'Utils/theme_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SessionManager.init();
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeManager(),
      child: const MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MyTravaly',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeManager.currentTheme,
      initialRoute: SessionManager.getBoolean(Prefs.isLoggedIn)==true ? Routes.home : Routes.login,

      routes: {
        Routes.login : (context) => Login(),
        Routes.home : (context) => Home()
      },
    );
  }
}

