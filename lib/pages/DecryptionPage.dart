import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import 'package:readable_cryption/providers/serverProvider.dart';
import 'package:flutter/services.dart';

import '../validators.dart';

class DecryptionPage extends StatefulWidget {
  const DecryptionPage({Key? key}) : super(key: key);

  @override
  _DecryptionPageState createState() => _DecryptionPageState();
}

class _DecryptionPageState extends State<DecryptionPage> {
  final messageController = TextEditingController();
  final passphraseController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  final tSifreCoz = "Şifre Çöz";
  final tSifre ="Şifre:";
  final tMetinGirin ="Metin Girin:";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 20,0,0),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(tMetinGirin),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: SizedBox(
                  height: 100,
                  child: TextField(
                    controller: messageController,
                    keyboardType: TextInputType.multiline,

                    maxLines: 50,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(tSifre),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextField(
                  controller: passphraseController,
                  maxLength: 100,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: double.infinity,
                  child: Card(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(Provider.of<ServerProvider>(context, listen: true)
                                .decryptionText),
                          ),
                          IconButton(onPressed: (){
                            Clipboard.setData(ClipboardData(text: (Provider.of<ServerProvider>(context, listen: false)
                                .decryptionText)));
                            Get.snackbar("Kopyalandı.","");
                          }, icon: const Icon(Icons.copy))
                        ],
                      )),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextButton(
                child: Text(tSifreCoz),
                onPressed: decrypt,
              )
            ]),
          ),
        ),
      ),
    );
  }

  void decrypt() {
    if(messageController.text != "" && passphraseController.text !="" ){
      ServerProvider().decrypt(
          message: messageController.text,
          passphrase: passphraseController.text);

      scrollController.animateTo(10, curve: Curves.linear, duration: const Duration(milliseconds: 10));
    }else{
      Get.snackbar("Hata", tEmptyFieldError);
    }
  }
}
