import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:readable_cryption/pages/RegisterPage.dart';
import 'package:readable_cryption/providers/serverProvider.dart';

import '../validators.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {

  var usernameController = TextEditingController();
  var passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 60),
            child: const Text(
              "Giriş",
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 150,
            child: Stack(
              children: [
                Container(
                  height: 150,
                  margin: const EdgeInsets.only(
                    right: 70,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(100),
                      bottomRight: Radius.circular(100),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 0,
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 16, right: 32),
                          child: TextFormField(
                            validator: usernameValidator,

                            controller: usernameController,
                            decoration: const InputDecoration(
                             errorStyle: TextStyle(fontSize: 0, height: 0),
                              hintStyle: TextStyle(fontSize: 20),
                              border: InputBorder.none,
                              icon: Icon(Icons.account_circle_rounded),
                              hintText: "Username",
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 16, right: 32),
                          child:  TextFormField(
                            validator: passwordValidator,
                            obscureText: true,
                            enableSuggestions: false,
                            autocorrect: false,
                             controller: passwordController,
                            decoration: const InputDecoration(
                              errorStyle: TextStyle(fontSize: 0, height: 0),
                              hintStyle: TextStyle(fontSize: 22),
                              border: InputBorder.none,
                              icon: Icon(Icons.account_circle_rounded),
                              hintText: "********",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: ()=> login(),
                    child: Container(
                      margin: const EdgeInsets.only(right: 15),
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green[200]!.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(0, 3),
                          ),
                        ],
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Color(0xff1bccba),
                            Color(0xff22e2ab),
                          ],
                        ),
                      ),
                      child: const Icon(
                        Icons.arrow_forward_outlined,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {


                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegisterForm()),
                    );




                },
                child: Container(
                  margin: const EdgeInsets.only(left: 16, top: 24),
                  child: const Text(
                    "Üye ol ",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color(0xffe98f60),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  login() {
    if (_formKey.currentState!.validate()) {
      ServerProvider().username = usernameController.text;
      ServerProvider().password = passwordController.text;
      ServerProvider().externalLogin();
    }
  }



}
