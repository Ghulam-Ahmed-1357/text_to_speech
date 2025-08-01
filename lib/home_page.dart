import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:text_to_speech_app/practice.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? selectedLanguage;
  TextEditingController textController = TextEditingController();
  bool isPause = false;

  TtsState ttsState = TtsState.stopped;

  Future<void> flutterTTSinit() async {
    FlutterTts flutterTts = FlutterTts();

    await flutterTts.awaitSpeakCompletion(true);

    var engine = await flutterTts.getDefaultEngine;
    var voice = await flutterTts.getDefaultVoice;

    flutterTts.setStartHandler(() {
      setState(() {
        ttsState = TtsState.playing;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    flutterTTSinit();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Text to Speech App'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Container(
                width: size.width * 0.9,
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: DropdownButton(
                    hint: Text('Select Language'),
                    value: selectedLanguage,
                    underline: SizedBox(),
                    isExpanded: true,
                    items: ['items1', 'item2'].map((String value) {
                      return DropdownMenuItem(value: value, child: Text(value));
                    }).toList(),
                    onChanged: (String? newLanguage) {
                      setState(() {
                        selectedLanguage = newLanguage;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: textController,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(border: OutlineInputBorder()),
                minLines: 3,
                maxLines: 5,
              ),
              const SizedBox(height: 20),

              Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(children: [Icon(Icons.play_arrow), Text('Play')]),
              ),

              isPause
                  ? Container(
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [Icon(Icons.play_arrow), Text('Continue')],
                      ),
                    )
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}

