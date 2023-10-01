// ignore_for_file: sized_box_for_whitespace, unused_local_variable, unused_import, unused_element, unused_field

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:latlong2/latlong.dart';
import 'package:udemycourse/controllers/firebase_controllers.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Colors.deepPurple.withOpacity(0.4)),
        useMaterial3: true,
      ),
      home: MyHomePage(),
    );
  }
}

// ignore: must_be_immutable
class MyHomePage extends StatelessWidget {
  MyHomePage({
    super.key,
  });
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseControllers _firebaseControllers =
      Get.put(FirebaseControllers());

  void _signInAnon() async {
    final user = (await _auth.signInAnonymously()).user;
    if (user != null && user.isAnonymous == true) {
      _firebaseControllers.status = 'Signed in anonymuosly' as Rx<String>;
    } else {
      _firebaseControllers.status = 'Sign in failed' as Rx<String>;
    }
  }

  void signOut() async {
    await _auth.signOut();
    _firebaseControllers.status = 'Signed out' as Rx<String>;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase module'),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GetX(
                builder: (controller) {
                  return Text(_firebaseControllers.status.toString());
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Sign in'),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Sign out'),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
