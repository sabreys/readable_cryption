import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import 'package:readable_cryption/providers/serverProvider.dart';

class EncryptionPage extends StatefulWidget {
  const EncryptionPage({Key? key}) : super(key: key);

  @override
  _EncryptionPageState createState() => _EncryptionPageState();
}

class _EncryptionPageState extends State<EncryptionPage> {
  final messageController = TextEditingController();
  final passphraseController = TextEditingController();

  final tSifrele = "Şifrele";
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
                    enableInteractiveSelection: true,
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
                  enableInteractiveSelection: true,
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
                          .encryptionText),
                ),
                        IconButton(onPressed: () async {

                          await Clipboard.setData(ClipboardData(text: ServerProvider().encryptionText));
                          Get.snackbar("Kopyalandı.", "");
                        }, icon: Icon(Icons.copy))
                      ],
                    )),
              ),
              SizedBox(
                height: 20,
              ),
              TextButton(
                child: Text(tSifrele),
                onPressed: () => ServerProvider().encrypt(
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
