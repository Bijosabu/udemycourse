import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseControllers extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  String status = 'Not authorised';
  @override
  void onInit() {
    status = 'Not authorised';
    super.onInit();
  }

  void signInAnon() async {
    final user = (await _auth.signInAnonymously()).user;
    if (user != null && user.isAnonymous == true) {
      status = 'Signed in';
      update();
    } else {
      status = 'Sign in failed';
      update();
    }
  }

  void signOut() async {
    await _auth.signOut();
    status = 'Signed out';
    update();
  }

  void signInGoogle() async {
    try {
      GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;

      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential authResult =
          await _auth.signInWithCredential(credential);
      final User? user = authResult.user;

      if (user != null && !user.isAnonymous) {
        status = 'Signed in with Google';
        update();
      } else {
        status = 'Sign in failed';
        update();
      }
    } catch (error) {
      // print('Google Sign-In Error: $error');
      status = 'Sign in failed';
      update();
    }
  }
  // void _signInGoogle() async {
  //   /*
  //   If you are using the new version, signInWithGoogle has been depreciated
  //   Try...

  //   final AuthCredential credential = GoogleAuthProvider.getCredential(
  //   accessToken: googleAuth.accessToken,
  //   idToken: googleAuth.idToken,
  //   );

  //   final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
  //   */

  //   GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
  //   GoogleSignInAuthentication googleSignInAuthentication =
  //       await googleSignInAccount!.authentication;

  //   AuthCredential credential = GoogleAuthProvider.credential(
  //     accessToken: googleSignInAuthentication.accessToken,
  //     idToken: googleSignInAuthentication.idToken,
  //   );
  //   final user = FirebaseAuth.instance.currentUser;
  //   if (user != null && user.isAnonymous == false) {
  //     status = 'Signed in with Google';
  //     update();
  //   } else {
  //     status = 'Signed in failed';
  //     update();
  //   }
  // }
}
