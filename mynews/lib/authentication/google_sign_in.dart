
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignInWithGoogle{

  Future<dynamic> googleSignIn() async{
    try{
      final GoogleSignInAccount? googleUser=await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth=await googleUser?.authentication;
      final credential =GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.accessToken,
      );
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } on Exception catch(e){
      throw Exception(e);
    }
  }

}