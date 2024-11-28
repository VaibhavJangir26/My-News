import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mynews/toast_msg.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});
  @override
  State<ForgotPasswordScreen> createState() => ForgotPasswordScreenState();
}

class ForgotPasswordScreenState extends State<ForgotPasswordScreen> {

  TextEditingController emailController=TextEditingController();
  final _formKey=GlobalKey<FormState>();
  bool isLoading=false;
  final auth=FirebaseAuth.instance;

  Future<void> forgotPassword(String email) async{
    setState(() {
      isLoading=true;
    });
    auth.sendPasswordResetEmail(email: email).then((value){
      setState(() {
        isLoading=false;
      });
      ToastMsg.showMsg("A password reset link has been sent to your email.");
      Navigator.pushReplacementNamed(context, "/login");
    }).catchError((error,stackTrace){
      setState(() {
        isLoading=false;
      });
      ToastMsg.showMsg(error.toString());
    });
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
              decoration:  const BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Color(0xfffff1eb),
                    Color(0xfface0f9),
                  ])
              ),
            ),
            SingleChildScrollView(
              child: Container(
                width: width*.85,
                height: height*.8,
                padding: const EdgeInsets.all(8),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const Text("Forgot Password!",style: TextStyle(fontSize: 33,fontWeight: FontWeight.bold),),

                      TextFormField(
                        enableSuggestions: true,
                        enableIMEPersonalizedLearning: true,
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value){
                          if(emailController.text.isEmpty){
                            return "Enter the email";
                          }
                          if(!value!.contains('@')){
                            return "Enter a valid mail";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            hintText: "Email",
                            prefixIcon: const Icon(Icons.email,),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(color: Colors.grey)
                            )
                        ),
                      ),



                      SizedBox(height: height*.02,),
                      const Text("We will send the reset password link on the entered email."),
                      Container(
                        width: width*.6,
                        height: height*.095,
                        padding: const EdgeInsets.all(8),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                          ),
                          onPressed: (){
                            setState(() {
                              setState(() {
                                isLoading=false;
                              });
                              if(_formKey.currentState!.validate()){
                                forgotPassword(emailController.text.toString());
                              }
                            });
                          },
                          child: isLoading?const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2.5,)):const Text("Send",style: TextStyle(fontSize: 15),),
                        ),
                      ),

                      SizedBox(height: height*.005,),
                      Container(
                        width: width,
                        height: height*.05,
                        padding: const EdgeInsets.all(4),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Back to login?"),
                            SizedBox(width: width*.005,),
                            InkWell(
                                onTap: ()=>Navigator.pushNamed(context, "/login"),
                                child: const Text("Login",style: TextStyle(color: Colors.pink),)),
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
