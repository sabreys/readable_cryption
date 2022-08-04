import 'package:flutter/material.dart';
import 'package:readable_cryption/providers/serverProvider.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        body: Center(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(child: Card(child: Center(child: Text("Encrypt")),),height: 50,width: 300,),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(child: Card(child: Center(child: Text("Decrypt")),),height: 50,width: 300,),
                ),
                TextButton(
                  child: Text("Çıkış Yap"),
                  onPressed: (){
                    ServerProvider(
                    ).logOut(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
