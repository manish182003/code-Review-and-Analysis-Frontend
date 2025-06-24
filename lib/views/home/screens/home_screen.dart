import 'dart:io';

import 'package:code_review_and_analysis/controllers/home/auth_controller.dart';
import 'package:code_review_and_analysis/controllers/home/code_review_controller.dart';
import 'package:code_review_and_analysis/routes/app_route_path.dart';
import 'package:code_review_and_analysis/routes/app_routes.dart';
import 'package:code_review_and_analysis/utils/enums/app_feature_type.dart';
import 'package:code_review_and_analysis/utils/helper/helper.dart';

import 'package:code_review_and_analysis/utils/theme/app_color.dart';
import 'package:code_review_and_analysis/views/home/widgets/animation_widget.dart';
import 'package:code_review_and_analysis/views/home/widgets/home_chip.dart';
import 'package:code_review_and_analysis/views/home/widgets/uploaded_file.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';

import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // late final CodeReviewController codeReviewController;

  final ScrollController _scrollController = ScrollController();
  final RxBool _showEmojiPicker = false.obs;
  RxBool isDropdownOpen = false.obs;
  final FocusNode _focusNode = FocusNode();
  final features = AppFeatureType.values;
  final selectedFeature = AppFeatureType.codeReview.obs;

  @override
  void initState() {
    // codeReviewController = Get.find<CodeReviewController>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final codeReviewController = Get.find<CodeReviewController>();
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: AppColor.transparentColor,
        scrolledUnderElevation: 0,

        elevation: 0,
        actions: [
          Obx(() {
            return ElevatedButton(
              onPressed:
                  codeReviewController.isTyping.value
                      ? null
                      : () async {
                        if (authController.appToken.isNotEmpty &&
                            authController.userModel.value.userId != null &&
                            authController.userModel.value.userId!.isNotEmpty) {
                          await authController.logoutUser();
                          return;
                        }
                        appNavigatorKey.currentContext?.push(
                          AppRoutePath.loginPageRoute,
                        );
                      },
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll<Color>(
                  AppColor.secondaryBackgroundColor,
                ),
                side: WidgetStatePropertyAll<BorderSide>(
                  BorderSide(
                    color:
                        codeReviewController.isTyping.value
                            ? AppColor.greyColor
                            : AppColor.transparentColor,
                  ),
                ),
              ),
              child:
                  authController.isloading.value
                      ? SizedBox(
                        height: 23,
                        width: 23,
                        child: CircularProgressIndicator(
                          color: AppColor.greyColor,
                        ),
                      )
                      : Text(
                        authController.appToken.isNotEmpty &&
                                authController.userModel.value.userId != null &&
                                authController
                                    .userModel
                                    .value
                                    .userId!
                                    .isNotEmpty
                            ? 'logout User'
                            : 'login Now',
                        style: TextStyle(
                          color:
                              codeReviewController.isTyping.value
                                  ? AppColor.greyColor
                                  : AppColor.hintTextColor,
                          fontSize: 14,
                        ),
                      ),
            );
          }),
          SizedBox(width: 5.w),
        ],
      ),
      body: Column(
        children: [
          Obx(() {
            if (codeReviewController.chats.isEmpty) {
              return Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Center(
                          child: Text(
                            'Ai Chat',
                            style: TextStyle(
                              color: AppColor.mainheadingtextColor,
                              fontSize: 56,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 🔵 Recents
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Recents', style: headingStyle),
                                    SizedBox(height: 1.h),
                                    chipWidget(
                                      "Speak Any Language: Translate phrases instantly.",
                                    ),
                                    chipWidget(
                                      "Explore Philosophy:\nDiscuss profound questions.",
                                    ),
                                    chipWidget(
                                      "Code Problem Solver: Debug coding issues with ease.",
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 2.w),
                              // 🟢 Frequent
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Frequent', style: headingStyle),
                                    SizedBox(height: 1.h),
                                    chipWidget(
                                      "Imagination Unleashed: Create a unique story from any idea.",
                                    ),
                                    chipWidget(
                                      "Learn Something New: Explain complex topics in simple terms.",
                                    ),
                                    chipWidget(
                                      "Cooking Made Easy: Get custom recipes from your ingredients.",
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else {
              // SizedBox(height: 2.h),
              return Expanded(
                child: Obx(() {
                  final codeReviewController = Get.find<CodeReviewController>();
                  codeReviewController.scrollTrigger.value;
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (_scrollController.hasClients) {
                      _scrollController.animateTo(
                        _scrollController.position.maxScrollExtent,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                      );
                    }
                  });
                  return ListView.builder(
                    shrinkWrap: true,
                    controller: _scrollController,
                    physics: AlwaysScrollableScrollPhysics(),
                    itemCount: codeReviewController.chats.length,
                    itemBuilder: (context, index) {
                      var chat = codeReviewController.chats[index];

                      if (index == codeReviewController.chats.length - 1 &&
                          chat.isUser == false &&
                          codeReviewController.isTyping.value) {
                        return Obx(() {
                          if (codeReviewController.showLoadingDots.value) {
                            // Loading dots animation
                            return Container(
                              padding: const EdgeInsets.all(12),
                              margin: EdgeInsets.symmetric(
                                horizontal: 5.w,
                                vertical: 1.h,
                              ),
                              child:
                                  const AnimatedTypingDots(), // Use the animated dots widget
                            );
                          }

                          // Typing animation
                          var typingMsg =
                              codeReviewController.typingMessage.value;
                          if (typingMsg.isNotEmpty) {
                            return Container(
                              constraints: BoxConstraints(maxWidth: 80.w),
                              padding: EdgeInsets.all(12),
                              margin: EdgeInsets.symmetric(horizontal: 5.w),
                              decoration: BoxDecoration(
                                color: AppColor.responsecontainerColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Markdown(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                data: typingMsg,
                                styleSheet: _markdownStyleSheet(context),
                              ),
                            );
                          }
                          return SizedBox.shrink();
                        });
                      }

                      return Obx(() {
                        chat = codeReviewController.chats[index];
                        if (chat.isUser == true) {
                          return Align(
                            alignment: Alignment.topRight,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                if (chat.isImageUploaded == true &&
                                    chat.filePath != null &&
                                    chat.filePath!.isNotEmpty) ...[
                                  Container(
                                    padding: EdgeInsets.all(12),
                                    margin: EdgeInsets.only(top: 8, right: 5.w),
                                    decoration: BoxDecoration(
                                      color: AppColor.textfieldBackgroundColor,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: buildCompactFileView(
                                      File(chat.filePath!),
                                      60,
                                      16,
                                    ),
                                  ),
                                ],
                                if (chat.message != null &&
                                    chat.message!.isNotEmpty)
                                  Container(
                                    constraints: BoxConstraints(maxWidth: 70.w),
                                    padding: EdgeInsets.all(12),
                                    margin: EdgeInsets.symmetric(
                                      horizontal: 5.w,
                                      vertical: 2.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColor.requestcontainerColor,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        bottomLeft: Radius.circular(20),
                                        bottomRight: Radius.circular(20),
                                      ),
                                    ),
                                    child: Text(
                                      chat.message!,
                                      style: TextStyle(
                                        color: AppColor.secondarytextColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        } else {
                          if (chat.isError == true) {
                            return Container(
                              constraints: BoxConstraints(maxWidth: 80.w),
                              padding: EdgeInsets.all(12),
                              margin: EdgeInsets.symmetric(
                                horizontal: 5.w,
                                vertical: 1.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppColor.errorFillColor,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: AppColor.errorBorderColor,
                                ),
                              ),

                              child: Row(
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    color: Color(0xFFB00020),
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      chat.message!,
                                      style: TextStyle(
                                        color: AppColor.errorTextColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                          return Container(
                            constraints: BoxConstraints(maxWidth: 80.w),
                            padding: EdgeInsets.all(12),
                            margin: EdgeInsets.symmetric(
                              horizontal: 5.w,
                              vertical: 1.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColor.responsecontainerColor,
                              borderRadius: BorderRadius.circular(20),
                            ),

                            child: Markdown(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              data: chat.message!,
                              styleSheet: _markdownStyleSheet(context),
                              onTapLink: (text, href, title) async {
                                if (href != null) {
                                  final Uri url = Uri.parse(href);
                                  if (await canLaunchUrl(url)) {
                                    await launchUrl(
                                      url,
                                      mode: LaunchMode.externalApplication,
                                    );
                                  } else {
                                    Helper.toast("Could Not Open link");
                                  }
                                }
                              },
                            ),
                          );
                        }
                      });
                    },
                  );
                }),
              );
            }
          }),

          Padding(
            padding: EdgeInsets.only(
              left: 3.w,
              right: 3.w,
              top: 2.h,
              bottom: 3.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () => DropdownButtonHideUnderline(
                    child: DropdownButton2<AppFeatureType>(
                      items:
                          features
                              .map(
                                (type) => DropdownMenuItem(
                                  value: type,
                                  child: Text(type.label),
                                ),
                              )
                              .toList(),
                      value: selectedFeature.value,
                      onChanged: (value) => selectedFeature.value = value!,
                      onMenuStateChange: (isOpen) {
                        isDropdownOpen.value = isOpen;
                      },
                      style: TextStyle(
                        color: AppColor.textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      iconStyleData: IconStyleData(
                        icon:
                            isDropdownOpen.value
                                ? Icon(
                                  Icons.arrow_drop_up,
                                  color: AppColor.whiteColor,
                                )
                                : Icon(
                                  Icons.arrow_drop_down,
                                  color: AppColor.whiteColor,
                                ),
                        iconEnabledColor: AppColor.whiteColor,
                      ),
                      buttonStyleData: ButtonStyleData(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColor.greyColor,
                            width: 0.5,
                          ),
                          color: AppColor.secondaryBackgroundColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      menuItemStyleData: MenuItemStyleData(height: 45),
                      dropdownStyleData: DropdownStyleData(
                        isOverButton: true,

                        offset: const Offset(0, 155),
                        decoration: BoxDecoration(
                          color: AppColor.selectedContainerColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColor.greyColor,
                            width: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 0.5.h),
                Obx(
                  () => TextField(
                    controller: codeReviewController.codeController.value,
                    minLines: 1,
                    maxLines: 8,
                    readOnly: codeReviewController.isListening.value,
                    onTap: () {
                      if (_showEmojiPicker.value) {
                        _showEmojiPicker.toggle();
                      }
                    },
                    focusNode: _focusNode,
                    style: TextStyle(
                      color: AppColor.whiteColor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: AppColor.blackColor,
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: AppColor.blackColor,
                          width: 1,
                        ),
                      ),
                      filled: true,
                      fillColor: AppColor.textfieldBackgroundColor,
                      contentPadding: EdgeInsets.all(12),

                      hintText: 'How can I help you?',
                      hintStyle: TextStyle(
                        color: AppColor.hintTextColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 1.h),
                Obx(() {
                  if (codeReviewController.filePath.value.isNotEmpty) {
                    return Stack(
                      children: [
                        Container(
                          padding: EdgeInsets.all(12),
                          margin: EdgeInsets.only(top: 8, right: 8),
                          decoration: BoxDecoration(
                            color: AppColor.textfieldBackgroundColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: buildCompactFileView(
                            File(codeReviewController.filePath.value),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          child: GestureDetector(
                            onTap: () {
                              codeReviewController.filePath.value = '';
                            },
                            child: CircleAvatar(
                              radius: 10,
                              backgroundColor:
                                  AppColor.secondaryBackgroundColor,
                              child: Icon(
                                Icons.close,
                                color: AppColor.whiteColor,
                                size: 10,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                  return SizedBox.shrink();
                }),
                SizedBox(height: 1.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: AppColor.textfieldBackgroundColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColor.blackColor,
                              width: 1,
                            ),
                          ),
                          child: IconButton(
                            padding: EdgeInsets.all(12),
                            icon: Icon(
                              Icons.attachment,
                              color: AppColor.whiteColor,
                            ),
                            onPressed: () async {
                              await codeReviewController.pickFile();
                            },
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColor.textfieldBackgroundColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColor.blackColor,
                              width: 1,
                            ),
                          ),
                          child: Obx(
                            () => IconButton(
                              padding: EdgeInsets.all(12),
                              icon:
                                  codeReviewController.isListening.value
                                      ? Lottie.asset(
                                        "assets/animations/mic_animation.json",
                                        height: 40,
                                        repeat: true,
                                        filterQuality: FilterQuality.high,
                                        delegates: LottieDelegates(
                                          values: [
                                            ValueDelegate.color(
                                              const ['**'],
                                              value:
                                                  AppColor.appBackgroundColor,
                                            ),
                                          ],
                                        ),
                                      )
                                      : Icon(
                                        Icons.mic,
                                        color: AppColor.whiteColor,
                                      ),
                              onPressed: () {
                                if (!codeReviewController.isListening.value) {
                                  codeReviewController.startListening();
                                } else {
                                  codeReviewController.stopListening();
                                }
                                // send action
                              },
                            ),
                          ),
                        ),
                      ],
                    ),

                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: AppColor.textfieldBackgroundColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColor.blackColor,
                              width: 1,
                            ),
                          ),
                          child: IconButton(
                            padding: EdgeInsets.all(12),
                            icon: Icon(
                              Icons.emoji_emotions,
                              color: AppColor.whiteColor,
                            ),
                            onPressed: () {
                              FocusScope.of(context).unfocus(); // Hide keyboard

                              _showEmojiPicker.toggle();
                            },
                          ),
                        ),
                        SizedBox(width: 3.w),
                        // 📤 Send Button
                        Obx(
                          () => Container(
                            decoration: BoxDecoration(
                              color: AppColor.textfieldBackgroundColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color:
                                    codeReviewController.isTyping.value
                                        ? AppColor.greyColor
                                        : AppColor.blackColor,
                                width: 1,
                              ),
                            ),
                            child: IconButton(
                              padding: EdgeInsets.all(12),
                              icon: Icon(
                                Icons.send,
                                color:
                                    codeReviewController.isTyping.value
                                        ? AppColor.greyColor
                                        : AppColor.whiteColor,
                              ),
                              onPressed:
                                  codeReviewController.isTyping.value
                                      ? null
                                      : () {
                                        if (codeReviewController
                                                .codeController
                                                .value
                                                .text
                                                .trim()
                                                .isEmpty &&
                                            codeReviewController
                                                .filePath
                                                .isEmpty) {
                                          Helper.toast("Please Enter Message");
                                        } else {
                                          codeReviewController.sendMessage(
                                            code:
                                                codeReviewController
                                                    .codeController
                                                    .value
                                                    .text
                                                    .trim(),
                                            featureType: selectedFeature.value,
                                            filePath:
                                                codeReviewController
                                                    .filePath
                                                    .value,
                                          );
                                          codeReviewController
                                              .codeController
                                              .value
                                              .clear();
                                          codeReviewController.filePath.value =
                                              '';
                                        }
                                      },
                              tooltip:
                                  codeReviewController.isTyping.value
                                      ? "Please wait..."
                                      : "Send",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                Obx(() {
                  if (_showEmojiPicker.value) {
                    return SizedBox(
                      height: 240,
                      child: EmojiPicker(
                        onEmojiSelected: (category, emoji) {
                          codeReviewController.codeController.value.text +=
                              emoji.emoji;
                          codeReviewController
                              .codeController
                              .value
                              .selection = TextSelection.fromPosition(
                            TextPosition(
                              offset:
                                  codeReviewController
                                      .codeController
                                      .value
                                      .text
                                      .length,
                            ),
                          );
                        },
                        config: Config(
                          checkPlatformCompatibility: true,
                          categoryViewConfig: CategoryViewConfig(
                            backgroundColor: AppColor.textfieldBackgroundColor,
                            indicatorColor: AppColor.whiteColor,
                            iconColorSelected: AppColor.whiteColor,
                            initCategory: Category.SMILEYS,
                          ),
                          emojiViewConfig: EmojiViewConfig(
                            backgroundColor: AppColor.textfieldBackgroundColor,
                            columns: 7,
                          ),
                          bottomActionBarConfig: BottomActionBarConfig(
                            enabled: false,
                          ),
                        ),
                      ),
                    );
                  }
                  return SizedBox.shrink();
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  MarkdownStyleSheet _markdownStyleSheet(BuildContext context) {
    return MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
      p: TextStyle(
        color: AppColor.textColor,
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
      code: const TextStyle(
        fontFamily: 'monospace',
        backgroundColor: Colors.black,
        color: Colors.greenAccent,
      ),
      codeblockDecoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(8),
      ),
      // Headings
      h1: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      h2: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white70,
      ),
      h3: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.white60,
      ),
      h4: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Colors.white54,
      ),
      h5: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Colors.white38,
      ),
      h6: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: Colors.white30,
      ),

      // Bullet and numbered lists
      listBullet: TextStyle(color: AppColor.textColor, fontSize: 14),

      a: TextStyle(color: Colors.blueAccent),

      // Blockquote
      blockquote: TextStyle(color: Colors.black54, fontStyle: FontStyle.italic),
      blockquotePadding: EdgeInsets.all(12),
      blockquoteDecoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(8),
        border: Border(left: BorderSide(color: Colors.blueAccent, width: 4)),
      ),

      // Horizontal rule
      horizontalRuleDecoration: BoxDecoration(
        border: Border(
          top: BorderSide(width: 1.0, color: Colors.grey.shade700),
        ),
      ),

      // Table styling (if needed)
      tableHead: TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.white,
        backgroundColor: Colors.grey[700],
      ),
      tableBody: TextStyle(color: Colors.white70),
    );
  }

  final headingStyle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 24,
  );
}
