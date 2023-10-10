// ignore_for_file: sized_box_for_whitespace, unused_local_variable, unused_import, unused_element, unused_field

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:latlong2/latlong.dart';
import 'package:udemycourse/controllers/counterDatabase.dart';
import 'package:udemycourse/controllers/firebase_controllers.dart';
import 'package:udemycourse/controllers/storageControllers.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_storage/firebase_storage.dart';

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
    return GetMaterialApp(
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
  // final FirebaseStorage storage = FirebaseStorage.instance;
  final firebaseController = Get.put(FirebaseControllers());
  final firebaseStorageControllers = Get.put(StorageControllers());
  final CounterDatabase counterDatabase = Get.put(CounterDatabase());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase module'),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GetBuilder<FirebaseControllers>(
              builder: (firebaseController) {
                return Column(
                  children: [
                    Text(firebaseController.status),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            firebaseController.signInAnon();
                          },
                          child: const Text('Sign in'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            firebaseController.signOut();
                          },
                          child: const Text('Sign out'),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              firebaseController.signInGoogle();
                            },
                            child: const Text(
                              'Sign in with Google',
                            ))
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              firebaseStorageControllers.upload(context);
                            },
                            child: const Text('Upload')),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                );
              },
            ),
            GetBuilder<CounterDatabase>(
              builder: (counterDatabase) {
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            counterDatabase.increment();
                          },
                          child: const Text('Increment'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            counterDatabase.decrement();
                          },
                          child: const Text('Decrement'),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Counter',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(counterDatabase.counter.toString())
                  ],
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
