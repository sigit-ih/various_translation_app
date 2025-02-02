import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pdf_translator_app_test/utilities/sharedpreferences.dart';
import 'package:pdf_translator_app_test/views/mainscreen.dart';
// import 'package:pembekalan_flutter_01/views/dashboardscreen.dart';


class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo.shade800,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/icons8-translate-100.png',
              width: 150,
              height: 150,
            ), // Jangan lupa kasih link icon8 di about atau section
            // Image.asset(
            //   'assets/images/logo_xa.png',
            //   width: 150,
            //   height: 150,
            // ),
            Padding(padding: EdgeInsets.fromLTRB(5, 20, 5, 20)),
            Text(
              'Various Translator',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
                  //fontFamily: 'BiomeRegular'),
            ),
            SizedBox(
              height: 5,
            ),
            RichText(
                text: TextSpan(children: <TextSpan>[
              TextSpan(
                  text: 'Versi ',
                  style: TextStyle(color: Colors.white, fontSize: 14)),
              TextSpan(
                  text: '1.0.0 Beta',
                  style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 14,
                      fontStyle: FontStyle.italic)),
            ])),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    startSplashScreenDelay();
  }

  startSplashScreenDelay() async {
    var duration = Duration(seconds: 3);
    return Timer(duration, callback);
  }

  callback() {
    // Proses berikutnya // setelah splash screen
    // Cek login?
    toMainScreen();
  }

  // toDashboardScreen() {
  //   //pindahKeDashboardScreen
  //   Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) {
  //     return DashboardScreen();
  //   }));
  // }

  toMainScreen() {
    //pindahKeMainScreen
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) {
      return MainScreen();
    }));
  }
}
