import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mynews/authentication/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../toast_msg.dart';


class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cPasswordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  bool isPassVisible = false;
  bool isCPassVisible = false;
  bool isChecked = false;
  final _formKey = GlobalKey<FormState>();
  void showPassword() {
    setState(() {
      isPassVisible = !isPassVisible;
    });
  }

  void showCPassword() {
    setState(() {
      isCPassVisible = !isCPassVisible;
    });
  }

  bool isLoading = false;
  final auth = FirebaseAuth.instance;
  Future<void> signUp(String email, String password) async {
    setState(() {
      isLoading = true;
    });
    try {
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (!mounted) return; // Ensure widget is still in the widget tree
      setState(() {
        isLoading = false;
      });
      Navigator.pushReplacementNamed(context, "/home");
    } catch (error) {
      if (!mounted) return; // Ensure widget is still in the widget tree
      setState(() {
        isLoading = false;
      });
      ToastMsg.showMsg(error.toString());
    }
  }

  Future<void> saveUserInfo(String email, String password, String name) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("name", nameController.text.trim().toString());
    prefs.setString("email", emailController.text.toString().trim());
    prefs.setString("pass", passwordController.text.trim().toString());
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
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
                  // this is for light theme
                  Color(0xfffff1eb),
                  Color(0xfface0f9),
                ])
              ),
            ),
            SingleChildScrollView(
              child: Container(
                width: width * .85,
                height: height * .9,
                padding: const EdgeInsets.all(8),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const Text(
                        "Create an account",
                        style: TextStyle(
                            fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      TextFormField(
                        controller: nameController,
                        keyboardType: TextInputType.name,
                        validator: (value) {
                          if (nameController.text.isEmpty) {
                            return "Enter the Name";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            hintText: "Full Name",
                            prefixIcon: const Icon(Icons.person),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                const BorderSide(color: Colors.grey))),
                      ),
                      SizedBox(
                        height: height * .005,
                      ),
                      TextFormField(
                        enableSuggestions: true,
                        enableIMEPersonalizedLearning: true,
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (emailController.text.isEmpty) {
                            return "Enter the email";
                          }
                          if (!value!.contains('@')) {
                            return "Enter a valid mail";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            hintText: "Email",
                            prefixIcon: const Icon(
                              Icons.email,
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                const BorderSide(color: Colors.grey))),
                      ),
                      SizedBox(
                        height: height * .005,
                      ),
                      TextFormField(
                        controller: passwordController,
                        obscureText: isPassVisible ? false : true,
                        keyboardType: TextInputType.visiblePassword,
                        validator: (value) {
                          if (passwordController.text.isEmpty) {
                            return "Enter the Password";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            hintText: "Password",
                            prefixIcon: const Icon(
                              Icons.lock,
                            ),
                            suffixIcon: IconButton(
                              onPressed: showPassword,
                              icon: isPassVisible
                                  ? const Icon(Icons.remove_red_eye)
                                  : const Icon(CupertinoIcons.eye_slash_fill),
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                const BorderSide(color: Colors.grey))),
                      ),
                      CheckboxListTile(
                          value: isChecked,
                          activeColor: Colors.blue,
                          controlAffinity: ListTileControlAffinity.leading,
                          title: const Text(
                            "By clicking this you accept our T&Cs. and Privacy Policy.",
                            style: TextStyle(fontSize: 11),
                          ),
                          onChanged: (bool? value) {
                            setState(() {
                              isChecked = value ?? false;
                            });
                          }),
                      Container(
                        width: width * .6,
                        height: height * .095,
                        padding: const EdgeInsets.all(8),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          onPressed: () {
                            isLoading = false;
                            if (!isChecked) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                backgroundColor: Colors.blue.shade100,
                                content: Text(
                                  "Please accept the T&Cs and Privacy Policy",
                                  style: TextStyle(color: Colors.pink.shade300),
                                ),
                                duration: const Duration(seconds: 1),
                              ));
                            }
                            if (_formKey.currentState!.validate() &&
                                isChecked) {
                              signUp(emailController.text.toString(),
                                  passwordController.text.toString());
                              saveUserInfo(
                                  emailController.text.toString(),
                                  passwordController.text.toString(),
                                  nameController.text.toString());
                            }
                          },
                          child: isLoading
                              ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ))
                              : const Text(
                            "Create Account",
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                      Container(
                        width: width,
                        height: height * .04,
                        alignment: Alignment.center,
                        child: const Text("--or Continue with--"),
                      ),
                      Container(
                        width: width,
                        height: height * .08,
                        padding: const EdgeInsets.all(4),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                             InkWell(
                               onTap:(){
                                 SignInWithGoogle().googleSignIn();
                                 },
                               child: const CircleAvatar(
                                radius: 20,
                                foregroundColor: Colors.grey,
                                foregroundImage:
                                AssetImage("assets/images/googlelogo.png"),
                               ),
                             ),
                            SizedBox(
                              width: width * .02,
                            ),
                            const CircleAvatar(
                              radius: 20,
                              foregroundColor: Colors.grey,
                              foregroundImage: AssetImage("assets/images/facebooklogo.png",),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: height * .005,
                      ),
                      Container(
                        width: width,
                        height: height * .05,
                        padding: const EdgeInsets.all(4),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Create an Account?"),
                            SizedBox(
                              width: width * .025,
                            ),
                            InkWell(
                                onTap: () =>
                                    Navigator.pushNamed(context, "/login"),
                                child: const Text(
                                  "Login",
                                  style: TextStyle(color: Colors.pink),
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
