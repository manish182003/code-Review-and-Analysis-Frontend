import 'dart:async';

import 'package:code_review_and_analysis/models/chat_model.dart';
import 'package:code_review_and_analysis/services/home/code_analysis_service.dart';

import 'package:code_review_and_analysis/services/home/code_doc_service.dart';
import 'package:code_review_and_analysis/services/home/code_review_service.dart';

import 'package:code_review_and_analysis/utils/enums/app_feature_type.dart';
import 'package:code_review_and_analysis/utils/helper/helper.dart';
import 'package:code_review_and_analysis/utils/helper/responseModel/api_response.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:get/get.dart';
import 'package:logger/web.dart';

class CodeReviewController extends GetxController {
  final _codeReviewService = CodeReviewService();
  final _codeDocService = CodeDocService();
  final _codeAnalysisService = CodeAnalysisService();
  final stt.SpeechToText _speech = stt.SpeechToText();
  final Rx<TextEditingController> codeController = TextEditingController().obs;
  RxBool isListening = false.obs;
  var chats = <ChatModel>[].obs;
  Timer? _silenceTimer;
  var isTyping = false.obs;
  var typingMessage = ''.obs;
  var showLoadingDots = false.obs;
  var scrollTrigger = 0.obs;
  RxString filePath = ''.obs;

  Future<void> startListening() async {
    final status = await Permission.microphone.request();

    if (status.isGranted) {
      bool available = await _speech.initialize(
        onStatus: (status) {
          Logger().i("Status-> $status");
          if (status == 'done' || status == 'notListening') {
            stopListening();
          }
        },
        onError:
            (errorNotification) => Logger().e("Error-> $errorNotification"),
      );
      if (available) {
        isListening.value = true;
        _speech.listen(
          onResult: (result) {
            if (result.finalResult) {
              codeController.value.text += "${result.recognizedWords} ";
              codeController.value.selection = TextSelection.fromPosition(
                TextPosition(offset: codeController.value.text.length),
              );
            }
          },
        );
      }
    }
  }

  Future<void> stopListening() async {
    isListening.value = false;
    _silenceTimer?.cancel();
    _speech.stop();
  }

  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      withData: true,
      allowedExtensions: [
        'js',
        'py',
        'cpp',
        'java',
        'ts',
        'dart',
        'html', // ✅ this is fine
        'css',
      ],
    );

    if (result != null && result.files.single.path != null) {
      filePath.value = result.files.single.path ?? '';
    }
  }

  Future<void> animateTyping(String fullText) async {
    typingMessage.value = '';
    showLoadingDots.value = false;
    for (int i = 0; i < fullText.length; i++) {
      if (i % 10 == 0 || fullText[i] == ' ' || fullText[i] == '\n') {
        scrollTrigger.value++;
      }

      typingMessage.value += fullText[i];
      await Future.delayed(const Duration(milliseconds: 20)); // typing speed
    }
    scrollTrigger.value++;
  }

  Future<void> sendMessage({
    required String code,
    AppFeatureType featureType = AppFeatureType.codeReview,
    String? filePath,
  }) async {
    chats.add(
      ChatModel(
        chatId: "",
        message: code,
        isUser: true,
        isImageUploaded: filePath != null && filePath.isNotEmpty,
        filePath: filePath,
      ),
    );
    isTyping.value = true;
    typingMessage.value = "";
    showLoadingDots.value = true;

    chats.add(ChatModel(chatId: '', message: '', isUser: false));

    await Future.delayed(Duration(seconds: 2));

    late ApiResponse<dynamic> response;

    if (featureType == AppFeatureType.codeReview) {
      response = await _codeReviewService.reviewCode(
        code: code,
        filePath: filePath,
        onSendProgress: (count, total) {},
      );
    } else if (featureType == AppFeatureType.codeDocGeneration) {
      response = await _codeDocService.generateCodeDocumentation(
        code: code,
        filePath: filePath,
        onSendProgress: (count, total) {},
      );
    } else if (featureType == AppFeatureType.codeComplexityAnalysis) {
      response = await _codeAnalysisService.analysisCodeComplexity(
        code: code,
        filePath: filePath,
        onSendProgress: (count, total) {},
      );
    }

    if (response.isSuccess && response.data != null) {
      var data = response.data as Map<String, dynamic>;
      await animateTyping(data['data']);
      chats.last = ChatModel(
        chatId: chats.last.chatId,
        message: typingMessage.value,
        isUser: false,
      );
    } else {
      chats.removeLast();
      Logger().e("Error response->${response.message}");
      chats.add(
        ChatModel(
          chatId: "",
          message: response.message,
          isUser: false,
          isError: true,
        ),
      );
      Helper.toast(response.message ?? 'Something Went Wrong');
    }
    isTyping.value = false;
    showLoadingDots.value = false;

    typingMessage.value = '';
  }
}
