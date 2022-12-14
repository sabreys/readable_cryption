import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:readable_cryption/pages/DecryptionPage.dart';
import 'package:readable_cryption/pages/EncryptionPage.dart';
import 'package:readable_cryption/providers/serverProvider.dart';
import 'package:readable_cryption/styles/styles.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
  final tEncrypt = "Encrypt";
  final tDecrypt = "Decrypt";

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        body: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  HomePageCard(
                      title: tEncrypt,
                      navigate: () => Get.to(const EncryptionPage())),
                  HomePageCard(
                      title: tDecrypt,
                      navigate: () => Get.to(const DecryptionPage())),
                  const ExitButton(),
                ],
              ),
            ),
            Positioned(
              child: RotationTransition(
                child: Image.asset(
                  "assets/images/shield.png",
                  height: 200,
                ),
                turns: const AlwaysStoppedAnimation(30 / 360),
              ),
              bottom: -50,
              left: -50,
            )
          ],
        ),
      ),
    );
  }
}

class ExitButton extends StatelessWidget {
  final tCikis = "Çıkış Yap";

  const ExitButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextButton(
        child: Text(tCikis, style: homePageExitButtonStyle),
        onPressed: () {
          ServerProvider().logOut(context);
        },
      ),
    );
  }
}

class HomePageCard extends StatelessWidget {
  final String title;
  Function navigate;

  HomePageCard({
    required this.navigate,
    required this.title,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () => navigate(),
        child: SizedBox(
          child: Card(
              child: Center(
                  child: Text(
                title,
                style: homePageCardTextStyle,
              )),
              color: homePageCardColor),
          height: 50,
          width: 300,
        ),
      ),
    );
  }
}
