import 'dart:convert';
import 'dart:core';

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ServerProvider extends ChangeNotifier {
  String? token;
  String? _username;
  String? _password;

  void login({required String username, required String password}) {}

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
          message: response.reasonPhrase, status: ServerStatus.falseTry);
    }
    else {
      throw ServerException(
          message: response.reasonPhrase, status: ServerStatus.noResponse);
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

  ServerException({message, status});

  String errMsg() => message;
}
