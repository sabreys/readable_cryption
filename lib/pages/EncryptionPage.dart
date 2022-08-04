import 'package:flutter/material.dart';
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
                    child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(Provider.of<ServerProvider>(context, listen: true)
                      .encryptionText),
                )),
              ),
              SizedBox(
                height: 50,
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
