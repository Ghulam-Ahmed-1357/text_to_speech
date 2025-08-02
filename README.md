# 🗣️ Flutter Text-to-Speech (TTS) App

This Flutter app uses the [`flutter_tts`](https://pub.dev/packages/flutter_tts) plugin to convert typed text into speech. It supports multiple languages and lets you adjust speech rate. The app is optimized for Android and uses Material Design.

---

## 🚀 Features

- Convert text to speech using `flutter_tts`
- Select language from a dropdown
- Adjust speech rate
- Play, pause, stop speech
- Snackbar validation if language is not selected
- Clean UI and responsive layout
- Track maximum input length

## Limitations
- Internet is not required for basic TTS, but some voices/languages may need network access.

- Language support depends on the device’s installed TTS engines.

- If no language is selected, a snackbar prompts the user to select one before speaking.

- App does not yet support saving custom voices or playback history.

## 🎬 Demo Video

[▶️ Watch Video] (https://github.com/user-attachments/assets/31c9444e-a8b8-4283-a1af-3ba16380db3e)