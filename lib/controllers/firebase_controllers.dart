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
    signInAnon();
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

  bool ensureLoggedIn() {
    final firebaseUser = _auth.currentUser;
    // assert(firebaseUser != null);
    if (firebaseUser == null) {
      return false;
    } else {
      return true;
    }
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
}
