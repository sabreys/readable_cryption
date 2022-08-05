import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import 'package:readable_cryption/providers/serverProvider.dart';
import 'package:flutter/services.dart';

class DecryptionPage extends StatefulWidget {
  const DecryptionPage({Key? key}) : super(key: key);

  @override
  _DecryptionPageState createState() => _DecryptionPageState();
}

class _DecryptionPageState extends State<DecryptionPage> {
  final messageController = TextEditingController();
  final passphraseController = TextEditingController();

  final tSifreCoz = "Şifre Çöz";
  final tSifre ="Şifre:";
  final tMetinGirin ="Metin Girin:";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(

          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 20,0,0),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(tMetinGirin),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  height: 100,
                  child: TextField(
                    controller: messageController,
                    keyboardType: TextInputType.multiline,

                    maxLines: 50,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(tSifre),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextField(
                  controller: passphraseController,
                  maxLength: 100,
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
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
                        }, icon: Icon(Icons.copy))
                      ],
                    )),
              ),
              SizedBox(
                height: 20,
              ),
              TextButton(
                child: Text(tSifreCoz),
                onPressed: () => ServerProvider().decrypt(
                    message: messageController.text,
                    passphrase: passphraseController.text),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
