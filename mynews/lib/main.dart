import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mynews/authentication/forgot_password_screen.dart';
import 'package:mynews/authentication/login_screen.dart';
import 'package:mynews/authentication/signup_screen.dart';
import 'package:mynews/firebase_options.dart';
import 'package:mynews/screens/categories_screen.dart';
import 'package:mynews/screens/homescreen.dart';
import 'package:mynews/screens/splash_screen.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setPreferredOrientations(
    [
     DeviceOrientation.portraitUp,
     DeviceOrientation.portraitDown,
    ]
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My News',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        primarySwatch: Colors.blue,
        primaryColor: Colors.blue.shade200,
        useMaterial3: true,
      ),
      initialRoute: "/",
      routes: {
         "/":(context)=>const SplashScreen(),
        "/home":(context)=>const HomeScreen(),
        "/login":(context)=>const Login(),
        "/signup":(context)=>const Signup(),
        "/category":(context)=>const CategoriesScreen(),
        "/forgot":(context)=>const ForgotPasswordScreen(),
      }

    );
  }
}
