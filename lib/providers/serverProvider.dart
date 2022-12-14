import 'dart:convert';
import 'dart:core';

import 'package:dio/dio.dart';
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

    if (_username == null || _password == null) {
      Get.to(const LoginForm());
      return;
    }
    await externalLogin();
  }

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
              message: "Yanl???? ??a??r??", status: ServerStatus.falseTry);
        } else {
          throw ServerException(
              message: "Cevap yok", status: ServerStatus.noResponse);
        }
      } else {}
    });

    if (response.statusCode == 200)
      token = json.decode(response.toString())["token"];
  }

  Future<void> signUp(
      {required String username, required String password}) async {
    var response = await Dio().post('https://sabrey.tech/register',
        data: {"name": username, "password": password});
    /*

    var headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
       "Accept":"application/json",
    };
    var request =
        http.Request('GET', Uri.parse('https://sabrey.tech/register'));

    request.body = jsonEncode({"name": username, "password": password});
    request.headers.addAll(headers);
    request.encoding = Encoding.getByName('utf-8')!;

    http.StreamedResponse response = await request.send();*/

    if (response.statusCode == 200) {
      _username = username;
      _password = password;
    } else if (response.statusCode == 409) {
      throw ServerException(
          message: "Bu kullan??c?? ad?? kullan??mda",
          status: ServerStatus.userExist);
    } else if (response.statusCode!.floor() >= 400 &&
        response.statusCode!.floor() <= 500) {
      throw ServerException(
          message: "Yanl???? ??a??r??", status: ServerStatus.falseTry);
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
      Get.snackbar("Hata", " Kullan??c?? ad?? ve ??ifre kayd?? yok.",
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
      Get.snackbar("Giri?? yap??ld??.", "",
          backgroundColor: Colors.pink, colorText: Colors.white);

      Get.to(const HomePage());
    }
  }

  Future<String> encrypt({message, passphrase}) async {
    if (token == null) {
      throw ServerException(
          message: "Hesap hatas??", status: ServerStatus.tokenExpired);
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
      Get.snackbar("HATA", "??ifreleme Ger??ekle??tirilemedi");
    }

    notifyListeners();

    return encryptionText;
  }

  Future<String> decrypt({message, passphrase}) async {
    if (token == null) {
      throw ServerException(
          message: "Hesap hatas??", status: ServerStatus.tokenExpired);
    }

    if (!await checkToken()) {
      await login(username: _username!, password: _password!);
    }

    Dio dio = Dio();
    dio.options.headers['x-access-tokens'] = token!;
    dio.options.headers['Content-Type'] = 'application/json';

    var response = await dio.post('https://sabrey.tech/decrypt',
        data: {"passphrase": passphrase, "message": message}).catchError((e) {
      Get.snackbar("HATA", "??ifreleme Ger??ekle??tirilemedi");
      return Future.error(ServerException(
          message: "Decryption Hatas??", status: ServerStatus.falseTry));
    });

    if (response.statusCode == 200) {
      decryptionText = await response.data;
      notifyListeners();
    } else {
      Get.snackbar("HATA", "??ifreleme Ger??ekle??tirilemedi");
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
