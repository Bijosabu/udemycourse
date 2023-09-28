// ignore_for_file: unused_field, prefer_final_fields

import 'package:get/get.dart';

class MainController extends GetxController {
  RxBool visible = true.obs;
  void toggle() {
    visible.value = !visible.value;
  }

  RxInt sliderValue = 0.obs;
  RxDouble turns = 0.0.obs;
  void rotate(double value) {
    sliderValue.value = value.toInt();
    turns.value = value;
  }

  RxDouble x = 0.0.obs;
  RxDouble y = 0.0.obs;
  RxDouble z = 0.0.obs;
  void assignX(double value) {
    x.value = value;
  }

  void assignY(double value) {
    y.value = value;
  }

  void assignZ(double value) {
    z.value = value;
  }
}
