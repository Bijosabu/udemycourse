// ignore_for_file: file_names, use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'dart:async';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:udemycourse/controllers/firebase_controllers.dart';

class StorageControllers extends GetxController {
  PlatformFile? pickedFile;
  FirebaseControllers fbAuth = FirebaseControllers();
  bool? ifLoggedIn;
  Uri? location;
  Future<String?> uploadFile(
      File file, String baseName, BuildContext context) async {
    try {
      final ref = FirebaseStorage.instance.ref().child('file/test/$baseName');
      final uploadTask = ref.putFile(file);
      await uploadTask;

      final location = await ref.getDownloadURL();
      String name = ref.name;
      String bucket = ref.bucket;
      String path = ref.fullPath;

      if (kDebugMode) {
        print('Url: $location');
        print('Url: $name');
        print('Url: $bucket');
        print('Url: $path]');
      }

      return location.toString();
    } on Exception catch (e) {
      throw e.toString();
    }
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      pickedFile = result.files.first;
      update();
    }
  }

  Future<void> upload(BuildContext context) async {
    ifLoggedIn = fbAuth.ensureLoggedIn();
    if (!ifLoggedIn!) {
      // User is not logged in, show an error dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const AlertDialog(
            title: Text('Authentication Error'),
            content: Text('You must be logged in to upload a file.'),
          );
        },
      );
      return;
    }
    await selectFile();
    if (pickedFile != null) {
      final file = File(pickedFile!.path!);
      final location = await uploadFile(file, pickedFile!.name, context);
      // ignore: unnecessary_null_comparison
      if (location != null) {
        // File uploaded successfully
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertDialog(
              title: Text('File Uploaded'),
              content: Text('The file was uploaded successfully.'),
            );
          },
        );
      } else {
        //  upload failed
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertDialog(
              title: Text('Upload Error'),
              content: Text('Failed to upload the file.'),
            );
          },
        );
      }
    }
  }

  // Future<String?> downloadFile(Uri location, BuildContext context) async {
  //   try {
  //     final data = await http.get(location);
  //     showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           title: const Text('Downloaded'),
  //           content: Text('FIle name is ${data.body}'),
  //         );
  //       },
  //     );
  //     return data.body;
  //   } catch (e) {
  //     // Handle any download errors gracefully
  //     if (kDebugMode) {
  //       print('Download error: $e');
  //     }
  //     return null;
  //   }
  // }
}
