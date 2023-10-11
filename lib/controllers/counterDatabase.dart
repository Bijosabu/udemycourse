// ignore_for_file: unused_import

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';
import 'dart:io';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

class CounterDatabase extends GetxController {
  int? counter;
  DatabaseReference? counterReference;
  StreamSubscription? counterSubscription;
  String? error;
  final FirebaseDatabase database = FirebaseDatabase.instance;

  @override
  void onInit() {
    initDatabase(database);
    super.onInit();
  }

  void initDatabase(database) async {
    counterReference = FirebaseDatabase.instance.ref().child('test/counter');
    await counterReference!.keepSynced(true);
    await database.setPersistenceEnabled(true);
    await database.setPersistenceCacheSizeBytes(10000000);
    counterSubscription = counterReference!.onValue.listen((event) {
      counter = event.snapshot.value as int? ?? 0;

      update();
    }, onError: (Object object) {
      error = object as String;
      update();
    });
  }

  Future<int> getCounter(DatabaseReference counterReference) async {
    try {
      DatabaseEvent snapshot = await counterReference.once();
      if (kDebugMode) {
        print('Connected to the database and read $snapshot');
      }
      int value = snapshot as int; // Assuming the value is an integer
      return value;
    } catch (e) {
      if (kDebugMode) {
        print('Error reading counter value: $e');
      }
      return 0; // Return a default value (you can change this as needed)
    }
  }

  Future<void> setCounter(dynamic value) async {
    counterReference = FirebaseDatabase.instance.ref().child('test/counter');
    final TransactionResult result =
        await counterReference!.runTransaction((Object? post) {
      if (post == null) {
        return Transaction.abort();
      } else {
        return Transaction.success(post);
      }
    });
    if (result.committed) {
      if (kDebugMode) {
        print('Value saved to the database ');
      }
    } else {
      if (kDebugMode) {
        print('Failed to save the value to the database');
      }
    }
  }

  void increment() async {
    int value = counter! + 1;
    setCounter(value);
  }

  void decrement() async {
    int value = counter! - 1;
    setCounter(value);
  }
}
//hey this is the change done on the first branch

//hey this is the seconf time im commiting this 