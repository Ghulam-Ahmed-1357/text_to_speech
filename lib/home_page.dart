import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_tts/flutter_tts_web.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController textController = TextEditingController();
  final FlutterTts flutterTts = FlutterTts();

  List<String> languages = [];
  String? selectedLanguage;
  bool isPaused = false;
  bool isSpeaking = false;
  bool isButtonDisabled = true;
  int? maxTextLength;
  int inputTextLength = 0;
  bool isLoading = true;

  TtsState ttsState = TtsState.stopped;

  @override
  void initState() {
    super.initState();
    _initializeTTS();
  }

  Future<void> _initializeTTS() async {
    maxTextLength = await flutterTts.getMaxSpeechInputLength;
    final langs = await flutterTts.getLanguages;
    languages = List<String>.from(langs);

    await flutterTts.awaitSpeakCompletion(true);

    flutterTts.setStartHandler(() => setState(() {
          ttsState = TtsState.playing;
        }));
    flutterTts.setCompletionHandler(() => setState(() {
          ttsState = TtsState.stopped;
          isSpeaking = false;
          isPaused = false;
        }));
    flutterTts.setPauseHandler(() => setState(() {
          ttsState = TtsState.paused;
        }));
    flutterTts.setContinueHandler(() => setState(() {
          ttsState = TtsState.continued;
        }));
    flutterTts.setErrorHandler((msg) => setState(() {
          ttsState = TtsState.stopped;
          debugPrint('TTS Error: $msg');
        }));

    setState(() => isLoading = false);
  }

  Future<void> _speak() async {
    if (textController.text.trim().isNotEmpty) {
      await flutterTts.speak(textController.text.trim());
    }
  }

  Future<void> _pause() async {
    try {
      await flutterTts.pause();
    } catch (e) {
      debugPrint("Pause Error: $e");
    }
  }

  Future<void> _stop() async {
    try {
      await flutterTts.stop();
      setState(() {
        ttsState = TtsState.stopped;
        isSpeaking = false;
        isPaused = false;
      });
    } catch (e) {
      debugPrint("Stop Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Text to Speech App',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Container(
                    width: size.width * 0.9,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButton<String>(
                      hint: const Text('Select Language'),
                      value: selectedLanguage,
                      isExpanded: true,
                      underline: const SizedBox(),
                      items: languages
                          .map((lang) => DropdownMenuItem(
                                value: lang,
                                child: Text(lang),
                              ))
                          .toList(),
                      onChanged: (lang) {
                        setState(() {
                          selectedLanguage = lang;
                          flutterTts.setLanguage(lang!);
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: textController,
                    minLines: 5,
                    maxLines: 8,
                    maxLength: maxTextLength,
                    textInputAction: TextInputAction.newline,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        inputTextLength = value.length;
                        isButtonDisabled = value.trim().isEmpty;
                      });

                      if (value.length == maxTextLength) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Max characters limit reached')),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildActionButton(
                        label: isPaused
                            ? 'Continue'
                            : isSpeaking
                                ? 'Pause'
                                : 'Play',
                        icon: isSpeaking ? Icons.pause : Icons.play_arrow,
                        onTap: isButtonDisabled
                            ? null
                            : () async {
                                if (!isSpeaking && !isPaused) {
                                  setState(() {
                                    isSpeaking = true;
                                  });
                                  await _speak();
                                } else if (isSpeaking && !isPaused) {
                                  setState(() {
                                    isSpeaking = false;
                                    isPaused = true;
                                  });
                                  await _pause();
                                } else if (isPaused) {
                                  setState(() {
                                    isSpeaking = true;
                                    isPaused = false;
                                  });
                                  await _speak();
                                }
                              },
                        size: size,
                        isDisabled: isButtonDisabled,
                      ),
                      _buildActionButton(
                        label: 'Stop',
                        icon: Icons.stop,
                        onTap: _stop,
                        size: size,
                        isDisabled: false,
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required VoidCallback? onTap,
    required Size size,
    required bool isDisabled,
  }) {
    return InkWell(
      onTap: isDisabled ? null : onTap,
      child: Container(
        height: 50,
        width: size.width * 0.32,
        decoration: BoxDecoration(
          color: isDisabled ? Colors.grey : Colors.black,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 5),
            Text(
              label,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
