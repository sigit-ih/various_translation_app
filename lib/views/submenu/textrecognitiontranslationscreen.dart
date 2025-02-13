import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class TextRecognitionTranslationScreen extends StatefulWidget {
  const TextRecognitionTranslationScreen({super.key});

  @override
  State<TextRecognitionTranslationScreen> createState() =>
      _TextRecognitionTranslationScreenState();
}

class _TextRecognitionTranslationScreenState
    extends State<TextRecognitionTranslationScreen> {
  var _script = TextRecognitionScript.latin;
  var _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: _buildDropdown(),
                  )),
            ]),
          ),
      ]),
    );
  }

  Widget _buildDropdown() {
    Color dropdownIconColor = Colors.indigo.shade800;
    return DropdownButton<TextRecognitionScript>(
      // isExpanded: true,
      value: _script,
      icon: SvgPicture.asset(
        'assets/icons/carbon-design-system/32/triangle--down--solid.svg',
        colorFilter: ColorFilter.mode(dropdownIconColor, BlendMode.srcIn),
        width: 12,
        height: 12,
        semanticsLabel: 'Triangle Down Solid',
      ),
      elevation: 3,
      style: TextStyle(
          color: Colors.indigo.shade800,
          fontWeight: FontWeight.bold,
          fontSize: 15),
      underline: Container(
        color: Colors.transparent,
      ),
      iconEnabledColor: dropdownIconColor,
      dropdownColor: Colors.white,
      onChanged: (TextRecognitionScript? script) {
        if (script != null) {
          setState(() {
            _script = script;
            _textRecognizer.close();
            _textRecognizer = TextRecognizer(script: _script);
          });
        }
      },
      items: TextRecognitionScript.values
          .map<DropdownMenuItem<TextRecognitionScript>>((script) {
        return DropdownMenuItem<TextRecognitionScript>(
          value: script,
          child: Text(script.name.toUpperCase()),
        );
      }).toList(),
    );
  }
}
