import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:my_api_client/my_api_client.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:personal_project/translation/utils/utils.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class TranslationRepository {
  TranslationRepository(this._client)
      : _speechToText = stt.SpeechToText(),
        _textToSpeech = FlutterTts(),
        _speechToTextStream = StreamController.broadcast();

  final ApiClient _client;
  final stt.SpeechToText _speechToText;
  final FlutterTts _textToSpeech;
  final StreamController<String> _speechToTextStream;

  Stream<String> get speechToTextStream => _speechToTextStream.stream;

  Future<void> initSpeechToText() async {
    final permissionStatus = await Permission.speech.request();
    print('speech permission status: $permissionStatus');

    final available = await _speechToText.initialize(
      onStatus: (status /* listening, notListening, done */) {
        print('stt result: $status');
        if (status == 'done') {
          // print(_sttResult);
          // _sttResult.clear();
        }
      },
      onError: (errorNotification /* timeout */) {
        print('------------ ${errorNotification.errorMsg}');
      },
    );
  }

  void startSpeechToText() {
    if (!_speechToText.isAvailable) return;

    _speechToText.listen(
      onResult: (result) {
        _speechToTextStream.sink.add(result.recognizedWords);
        // print('-------------- stt completed ---------------');
        // print('alternates: ${result.alternates}');
        // print('confidence: ${result.confidence}');
        // print('final: ${result.finalResult}');
        // print('hasConfidenceRating: ${result.hasConfidenceRating}');
        // print('recognizedWords: ${result.recognizedWords}');
        // print('toFinal: ${result.toFinal()}');
        // print('toJson: ${result.toJson()}');
        // print('-------------- stt completed ---------------');
        // _sttResult.add(result.recognizedWords);
      },
    );
  }

  Future<void> cancelSpeechToText() async {
    if (_speechToText.isListening) await _speechToText.stop();
  }

  Future<void> initTextToSpeech() async {
    // IOS만을 위한 셋업 코드입니다
    if (Platform.isIOS) {
      await _textToSpeech.setSharedInstance(true);
      await _textToSpeech.setIosAudioCategory(
        IosTextToSpeechAudioCategory.ambient,
        [
          IosTextToSpeechAudioCategoryOptions.allowBluetooth,
          IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
          IosTextToSpeechAudioCategoryOptions.mixWithOthers
        ],
        IosTextToSpeechAudioMode.voicePrompt,
      );
    }

    // Android, IOS 공통의 셋업 코드입니다
    //
    await _textToSpeech.awaitSpeakCompletion(true);
    //
    await _textToSpeech.awaitSynthCompletion(true);
  }

  Future<void> playTextToSpeech(String text) async {
    final result = await _textToSpeech.speak(text);
    // if (result == 1) setState(() => ttsState = TtsState.playing);
    if (result != 1) {
      // 응답 결과가 1이 아닐 경우의 예외 처리
    }
  }

  Future<void> stopTextToSpeech(String text) async {
    final result = await _textToSpeech.stop();
    // if (result == 1) setState(() => ttsState = TtsState.stopped);
    if (result != 1) {
      // 응답 결과가 1이 아닐 경우의 예외 처리
    }
  }

  Future<String> translate(List<String> texts, String endLocale) async {
    final response = await _client.post(
      deeplApiUrl,
      options: Options(
        headers: {
          'Authorization': 'DeepL-Auth-Key $deeplApiAuthKey',
        },
      ),
      body: {
        "text": texts,
        "target_lang": endLocale,
      },
    );

    print('translate response: ${response.jsonDecoded}');
    print('translate response: ${response.statusCode}');

    if (response.hasException) throw Exception();
    return response.jsonDecoded.toString();
  }

  Future<void> close() {
    return _speechToText.cancel();
  }
}
