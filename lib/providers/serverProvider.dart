import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:dio/dio.dart';
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

  Future<void> login(
      {required String username, required String password}) async {
    String basicAuth =
        'Basic ' + base64.encode(utf8.encode('$username:$password'));

    Dio dio = Dio();

    dio.options.headers["authorization"] = basicAuth;

    var response =
        await dio.get('https://sabrey.tech/login').catchError((error) {
      print(error);
      if (error is DioError) {
        if (error.response!.statusCode! >= 400 &&
            error.response!.statusCode! <= 500) {
          throw ServerException(
              message: "Yanlış Çağrı", status: ServerStatus.falseTry);
        } else {
          throw ServerException(
              message: "Cevap yok", status: ServerStatus.noResponse);
        }
      } else {}
    });

    if (response.statusCode == 200) {
      token = json.decode(response.toString())["token"];
    }
  }

  Future<void> signUp(
      {required String username, required String password}) async {
    var response = await Dio().post('https://sabrey.tech/register',
        data: {"name": username, "password": password});


    if (response.statusCode == 200) {
      _username = username;
      _password = password;
    } else if (response.statusCode == 409) {
      throw ServerException(
          message: "Bu kullanıcı adı kullanımda",
          status: ServerStatus.userExist);
    } else if (response.statusCode!.floor() >= 400 &&
        response.statusCode!.floor() <= 500) {
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
      if (e.runtimeType == ServerException) {
        Get.snackbar("Hata", e.message,
            backgroundColor: Colors.pink, colorText: Colors.white);
      }
      error = true;
    });

    if (!error) {
      Get.snackbar("Giriş yapıldı.", "",
          backgroundColor: Colors.pink, colorText: Colors.white);

      Get.to(const HomePage());
    }
  }

  Future<String> encrypt({message, passphrase}) async {
    if (token == null) {
      throw ServerException(
          message: "Hesap hatası", status: ServerStatus.tokenExpired);
    }

    if (!await checkToken()) {
      await login(username: _username!, password: _password!);
    }

    Dio dio = Dio();
    dio.options.headers['x-access-tokens'] = token!;
    dio.options.headers['Content-Type'] = 'application/json';

    var response = await dio.post('https://sabrey.tech/encrypt',
        data: {"passphrase": passphrase, "message": message});

    if (response.statusCode! == 200) {
      encryptionText = await response.data;
      notifyListeners();
    } else {
      Get.snackbar("HATA", "Şifreleme Gerçekleştirilemedi");
    }

    notifyListeners();

    return encryptionText;
  }

  Future<String> decrypt({message, passphrase}) async {
    if (token == null) {
      throw ServerException(
          message: "Hesap hatası", status: ServerStatus.tokenExpired);
    }

    if (!await checkToken()) {
      await login(username: _username!, password: _password!);
    }

    Dio dio = Dio();
    dio.options.headers['x-access-tokens'] = token!;
    dio.options.headers['Content-Type'] = 'application/json';

    var response = await dio.post('https://sabrey.tech/decrypt',
        data: {"passphrase": passphrase, "message": message}).catchError((e) {
      Get.snackbar("HATA", "Şifreleme Gerçekleştirilemedi");
      return Future.error(ServerException(
          message: "Decryption Hatası", status: ServerStatus.falseTry));
    });

    if (response.statusCode == 200) {
      decryptionText = await response.data;
      notifyListeners();
    } else {
      Get.snackbar("HATA", "Şifreleme Gerçekleştirilemedi");
    }

    notifyListeners();

    return decryptionText;
  }

  Future<bool> checkToken() async {
    if (token == null) {
      return false;
    }

    var dio = Dio();
    dio.options.headers["x-access-tokens"] = token!;

    var response = await dio.get('https://sabrey.tech/checktoken');

    if (response.statusCode == 200) {
      bool check = await response.data == "1" ? true : false;
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
