import 'dart:convert';
import 'dart:core';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
  String encryptionText = "";
  String decryptionText = "";



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

  final storage = const FlutterSecureStorage();

  Future<void> saveCredential() async {
    await storage.write(key: "username", value: _username);
    await storage.write(key: "password", value: _password);
  }
  Future<void> deleteCredential() async {
    await storage.delete(key: "username");
    await storage.delete(key: "password");
  }

  Future<void> loadCredential() async {
    _username = await storage.read(key: "username");
    _password = await storage.read(key: "password");
  }

  Future<void> checkCredential() async {
    await loadCredential();

    if(_username == null ||_password == null){
      Get.to(const LoginForm());
    }
    await externalLogin();
  }

  Future<void> login(
      {required String username, required String password}) async {
    String basicAuth =
        'Basic ' + base64.encode(utf8.encode('$username:$password'));

    var headers = {'Authorization': basicAuth};
    var request = http.Request('GET', Uri.parse('https://sabrey.tech/login'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      token = jsonDecode(await response.stream.bytesToString())["token"];
      saveCredential();

    } else if (response.statusCode >= 400 && response.statusCode <= 500) {
      throw ServerException(
          message: "Yanlış Çağrı", status: ServerStatus.falseTry);
    } else {
      throw ServerException(
          message: "Cevap yok", status: ServerStatus.noResponse);
    }
  }

  Future<void> signUp(
      {required String username, required String password}) async {
    var headers = {'Content-Type': 'application/json'};
    var request =
        http.Request('GET', Uri.parse('https://sabrey.tech/register'));
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
    } else if (response.statusCode >= 400 && response.statusCode <= 500) {
      throw ServerException(
          message: "Yanlış Çağrı", status: ServerStatus.falseTry);
    } else {
      throw ServerException(
          message: "Cevap yok", status: ServerStatus.noResponse);
    }
  }

  Future<void> logOut(context) async {
    _password = null;
    _username = null;
    token = null;
    await deleteCredential();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginForm()),
    );
    notifyListeners();
  }

  Future<void> externalLogin() async {
    bool error = false;

    if (_username == null || _password == null) {
      Get.snackbar("Hata", " Kullanıcı adı ve şifre kaydı yok.",
          backgroundColor: Colors.pink, colorText: Colors.white);
      return;
    }
    await login(password: _password!, username: _username!).catchError((e) {
      Get.snackbar("Hata", e.message,
          backgroundColor: Colors.pink, colorText: Colors.white);

      error = true;
    });

    if (!error) {
      Get.snackbar("Giriş yapıldı.", "",
          backgroundColor: Colors.pink, colorText: Colors.white);

      Get.to(const HomePage());
    }
  }

  Future<String> encrypt({message, passphrase}) async {
    if (token == null ) {
      throw ServerException(
          message: "Hesap hatası", status: ServerStatus.tokenExpired);
    }

    if(!await checkToken()){
      await login(username: _username!, password: _password!);
    }
    var headers = {
      'x-access-tokens': token!,
      'Content-Type': 'application/json'
    };
    var request = http.Request('GET', Uri.parse('https://sabrey.tech/encrypt'));
    request.body = json.encode({"passphrase": passphrase, "message": message});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      encryptionText = await response.stream.bytesToString();
      notifyListeners();
    } else {
      Get.snackbar("HATA", "Şifreleme Gerçekleştirilemedi");
    }

    notifyListeners();

    return encryptionText;
  }

  Future<String> decrypt({message, passphrase}) async {
    if (token == null ) {
      throw ServerException(
          message: "Hesap hatası", status: ServerStatus.tokenExpired);
    }

    if(!await checkToken()){
    await login(username: _username!, password: _password!);
    }
    var headers = {
    'x-access-tokens': token!,
    'Content-Type': 'application/json'
    };
    var request = http.Request('GET', Uri.parse('https://sabrey.tech/decrypt'));
    request.body = json.encode({"passphrase": passphrase, "message": message});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
    decryptionText = await response.stream.bytesToString();
    notifyListeners();
    } else {
    Get.snackbar("HATA", "Şifreleme Gerçekleştirilemedi");
    }

    notifyListeners();

    return decryptionText;
  }

  Future<bool> checkToken() async {
    if(token == null){
     return false;
    }
    var headers = {'x-access-tokens': token!};
    var request =
        http.Request('GET', Uri.parse('https://sabrey.tech/checktoken'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      bool check = await response.stream.bytesToString() == "1" ? true : false;
      return check;
    } else {
      return false;
    }
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
