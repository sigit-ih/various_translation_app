import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf_translator_app_test/views/blocs/dictionary_bloc.dart';

class DictionaryScreen extends StatefulWidget {
  const DictionaryScreen({super.key});

  @override
  State<DictionaryScreen> createState() => _DictionaryScreenState();
}

class _DictionaryScreenState extends State<DictionaryScreen> {
  final TextEditingController _controller = TextEditingController();
  String _selectedLanguage = 'en'; // Default ke Inggris

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("translation".tr())),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Input Kata
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: "title".tr(),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),

            // Dropdown Bahasa
            DropdownButton<String>(
              value: _selectedLanguage,
              items: [
                DropdownMenuItem(value: 'id', child: Text("indonesian".tr())),
                DropdownMenuItem(value: 'en', child: Text("english".tr())),
                DropdownMenuItem(value: 'ja', child: Text("japanese".tr())),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedLanguage = value!;
                });
              },
            ),
            const SizedBox(height: 10),

            // Tombol Cari
            ElevatedButton(
              onPressed: () {
                if (_controller.text.isNotEmpty) {
                  context.read<DictionaryBloc>().add(
                      SearchWord(_controller.text, "en", _selectedLanguage));
                }
              },
              child: Text("translation".tr()),
            ),
            const SizedBox(height: 20),

            // Hasil Pencarian
            BlocBuilder<DictionaryBloc, DictionaryState>(
              builder: (context, state) {
                if (state is DictionaryLoading) {
                  return CircularProgressIndicator();
                } else if (state is DictionaryLoaded) {
                  return Column(
                    children: [
                      Text("Terjemahan: ${state.translation}",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      ...state.definitions
                          .map((def) => Text("• $def"))
                          .toList(),
                    ],
                  );
                } else if (state is DictionaryError) {
                  return Text(state.message, style: TextStyle(color: Colors.red));
                }
                return SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}