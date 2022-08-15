import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

const tUsernameEmptyError='Kullanıcı adı boş olamaz';
const tPasswordEmptyError='Şifre alanı boş olamaz';
const tShortPasswordError='Şifre en az 8 karakter olmalıdır.';
const tEmptyFieldError='Alan boş olmamalı';
String? usernameValidator (value) {
  if (value == null || value.isEmpty) {
    Get.snackbar("Hata",tUsernameEmptyError);
    return tUsernameEmptyError;
  }
  return null;
}

String? emptyFieldValidator (value) {
  if (value == null || value.isEmpty) {
    Get.snackbar("Hata",tEmptyFieldError);
    return tUsernameEmptyError;
  }
  return null;
}

String? passwordValidator(value){
  RegExp regex =
  RegExp(r'^.{8,}$');
  if (value.isEmpty) {
    Get.snackbar("Hata",tPasswordEmptyError);
    return tPasswordEmptyError ;
  } else {
    if (!regex.hasMatch(value)) {
      Get.snackbar("Hata",tShortPasswordError);
      return tShortPasswordError;
    } else {
      return null;
    }
  }
}
