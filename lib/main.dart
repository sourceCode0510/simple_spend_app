import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
//
import './models/db_provider.dart';
import './screens/onboarding_screen.dart';
import './screens/home_screen.dart';

int? loginData;
void main() async {
  // enabled by the 'services' package
  // it's to set the statusbar color to white
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  WidgetsFlutterBinding.ensureInitialized();
  // to get the saved login data, if any available
  SharedPreferences preferences = await SharedPreferences.getInstance();
  loginData = preferences.getInt('loggedIn');
  runApp(ChangeNotifierProvider(
    create: (ctx) => Dbprovider(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.comicNeueTextTheme(),
        scaffoldBackgroundColor: Colors.white,
        primarySwatch: Colors.pink,
      ),
      initialRoute: loginData != 1 || loginData == null
          ? OnboardingScreen.name
          : HomeScreen.name,
      routes: {
        OnboardingScreen.name: (context) => const OnboardingScreen(),
        HomeScreen.name: (context) => const HomeScreen(),
      },
    );
  }
}
