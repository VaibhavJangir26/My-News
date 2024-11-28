
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}



class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    moveScreen();
  }
  moveScreen(){
    final auth=FirebaseAuth.instance;
    User? user=auth.currentUser;
    if(user!=null){
      Timer(const Duration(seconds: 4),
              ()=>Navigator.pushReplacementNamed(context,"/home"),
      );
    }
    else{
      Timer(const Duration(seconds: 4),
              ()=>Navigator.pushReplacementNamed(context,"/login"),
      );
    }

  }


  @override
  Widget build(BuildContext context) {
    final width=MediaQuery.of(context).size.width;
    final height=MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            
            Container(
              width: width,
              height: height,
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [
                  Color(0xfffff1eb),
                  Color(0xfface0f9),
                ]),
              ),
            ),
            
             Text("My News",style: GoogleFonts.italiana(fontSize: 35,fontWeight: FontWeight.bold),),
            
            



          ],
        ),
      ),
    );
  }
}
