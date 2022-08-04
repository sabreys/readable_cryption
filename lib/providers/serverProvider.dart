import 'dart:convert';
import 'dart:core';

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:readable_cryption/pages/LoginPage.dart';

import '../pages/HomePage.dart';

class ServerProvider extends ChangeNotifier {

  static final ServerProvider _singleton = ServerProvider._internal();

  String? token;
  String? _username;
  String? _password;

  set username(String value) {
    _username = value;
  }

  set password(String value) {
    _password = value;
  }


  factory ServerProvider() {
    return _singleton;
  }

  ServerProvider._internal();

  Future<void> login({required String username, required String password}) async {

    String basicAuth =
        'Basic ' + base64.encode(utf8.encode('$username:$password'));

    var headers = {
      'Authorization': basicAuth
    };
    var request = http.Request('GET', Uri.parse('https://readable-cryption-ntedq.ondigitalocean.app/login'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      token = jsonDecode(await response.stream.bytesToString())["token"];
      print(token);
    }
    else if (response.statusCode >= 400 && response.statusCode <= 500){
      throw ServerException(
          message: "Yanlış Çağrı", status: ServerStatus.falseTry);
    }
    else {
      throw ServerException(
          message: "Cevap yok", status: ServerStatus.noResponse);
    }

  }



  Future<void> signUp(
      {required String username, required String password}) async {
    var headers = {'Content-Type': 'application/json'};
    var request =
        http.Request('GET', Uri.parse('https://readable-cryption-ntedq.ondigitalocean.app/register'));
    request.body = json.encode({"name": username, "password": password});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      _username = username;
      _password = password;
    } else if (response.statusCode == 409) {
      throw ServerException(
          message: "Bu kullanıcı adı kullanımda",
          status: ServerStatus.userExist);
    } else if (response.statusCode >= 400 && response.statusCode <= 500){
      throw ServerException(
          message: "Yanlış Çağrı", status: ServerStatus.falseTry);
    }
    else {
      throw ServerException(
          message: "Cevap yok", status: ServerStatus.noResponse);
    }
  }

  void logOut(context){
    _password= null;
    _username = null;
    token = null;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginForm()),
    );
  }


  Future<void> externalLogin() async {
    bool error = false;

    if(_username == null ||_password == null){
      Get.snackbar("Hata"," Kullanıcı adı ve şifre kaydı yok.",backgroundColor: Colors.pink, colorText: Colors.white);
      return;
    }
     await login(password: _password!,username: _username!) .catchError((e) {
       Get.snackbar("Hata",e.message,backgroundColor: Colors.pink, colorText: Colors.white);

       error= true;
     });

    if(!error){
      Get.snackbar("Giriş yapıldı.","",backgroundColor: Colors.pink , colorText: Colors.white);

     Get.to(const HomePage());

    }

  }

  String encrypt() {
    return "";
  }

  String decrypt() {
    return "";
  }



}

enum ServerStatus {
  falseTry,
  tokenExpired,
  successLogin,
  successSignUp,
  noResponse,
  successCryption,
  noConnection,
  userExist
}

class ServerException implements Exception {
   late ServerStatus status;
   late String message;

  ServerException({required this.message, required this.status});

  String errMsg() => message;
}
