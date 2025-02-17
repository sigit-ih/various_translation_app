import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pdf_translator_app_test/translations/locale_keys.g.dart';
import 'package:pdf_translator_app_test/utilities/sharedpreferences.dart';
import 'package:pdf_translator_app_test/views/mainscreen.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.indigo.shade800,
      backgroundColor: Colors.indigo.shade800,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icons/icons8-translate-100.png',
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
              LocaleKeys.title.tr(),
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
                  text: '${LocaleKeys.version.tr()} ',
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

    
    // Ambil language dari SharedPreferences
    SharedPreferencesHelper.readLanguage().then((lang) {
      setState(() {
        context.setLocale(Locale(setLocalLanguage(lang)));
      });
    });

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

  String setLocalLanguage(String? lang) {
    if(lang == 'Bahasa Indonesia') {
      return 'id';
    } else if(lang == 'English') {
      return 'en';
    } else if(lang == '日本語') {
      return 'ja';
    }
    return '';
  }
}
