import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:path_provider/path_provider.dart';

class MobileMessageBox extends StatelessWidget {
  final TextEditingController messageController;
  final FocusNode focusNode;
  final FlutterSoundRecorder soundRecorder;
  final ValueNotifier<bool> isUploading;
  final ValueNotifier<bool> isRecording;
  final ValueNotifier<Duration> recordingDuration;
  final String? receiverId;

  // final void Function(String filePath) sendVoiceMessage;
  final Widget? leftAction;
  final Widget? rightAction;
  final void Function(String)? onSend;
  final void Function(String)? onVoiceSend;

  const MobileMessageBox({
    super.key,
    required this.messageController,
    required this.focusNode,
    required this.soundRecorder,
    required this.isUploading,
    required this.isRecording,
    required this.recordingDuration,
    required this.receiverId,
    // required this.sendVoiceMessage,
    required this.onSend,
    this.leftAction,
    this.rightAction,
    this.onVoiceSend,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
      child: ValueListenableBuilder(
        valueListenable: isUploading,
        builder: (context, value, child) {
          if (value) {
            return const LinearProgressIndicator();
          }

          return ValueListenableBuilder(
            valueListenable: isRecording,
            builder: (context, isRecordingValue, child) {
              return Row(
                children: [
                  if (isRecordingValue)
                    Expanded(
                      child: ValueListenableBuilder(
                        valueListenable: recordingDuration,
                        builder: (context, recordingDurationValue, child) {
                          return TextField(
                            enabled: false,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor:
                                  const Color.fromRGBO(122, 179, 65, 1.0),
                              prefixIcon: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Icon(
                                  Icons.mic_none,
                                  color: Colors.red,
                                ),
                              ),
                              hintText: recordingDurationValue
                                  .toString()
                                  .split('.')
                                  .first,
                              hintStyle: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                ),
                              ),
                              contentPadding: const EdgeInsets.all(10),
                            ),
                          );
                        },
                      ),
                    )
                  else
                    Expanded(
                      child: TextField(
                        controller: messageController,
                        focusNode: focusNode,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color.fromRGBO(242, 242, 247, 1.0),
                          prefixIcon: leftAction != null
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: leftAction,
                                )
                              : null,
                          suffixIcon: leftAction != null
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: rightAction,
                                )
                              : null,
                          hintText: 'Type a message...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          ),
                          contentPadding: const EdgeInsets.all(10),
                        ),
                      ),
                    ),
                  const SizedBox(width: 5),
                  ValueListenableBuilder(
                    valueListenable: messageController,
                    builder: (context, value, child) {
                      if (messageController.text.isNotEmpty) {
                        return CircleAvatar(
                          radius: 20,
                          backgroundColor:
                              const Color.fromRGBO(122, 179, 65, 1.0),
                          child: IconButton(
                            onPressed: () {
                              if (messageController.text.trim() != '') {
                                if (onSend != null) {
                                  onSend!(messageController.text.trim());
                                }
                                messageController.text = '';
                              }
                            },
                            icon: const Icon(
                              Icons.send,
                              color: Colors.white,
                            ),
                          ),
                        );
                      } else {
                        return CircleAvatar(
                          radius: isRecordingValue ? 30 : 20,
                          backgroundColor: isRecordingValue
                              ? Colors.red
                              : const Color.fromRGBO(122, 179, 65, 1.0),
                          child: GestureDetector(
                            onLongPress: () async {
                              final tempDir = await getTemporaryDirectory();
                              final path =
                                  '${tempDir.path}/audio_${DateTime.now()}.aac';

                              await soundRecorder.startRecorder(
                                toFile: path,
                              );

                              isRecording.value = true;
                            },
                            onLongPressEnd: (details) async {
                              String? filePath =
                                  await soundRecorder.stopRecorder();

                              // sendVoiceMessage(filePath!);
                              if (onVoiceSend != null && filePath != null) {
                                onVoiceSend!(filePath);
                              }

                              isRecording.value = false;
                            },
                            child: Icon(
                              isRecordingValue ? Icons.close : Icons.mic,
                              color: Colors.white,
                            ),
                          ),
                        );
                      }
                    },
                  )
                ],
              );
            },
          );
        },
      ),
    );
  }
}

// class CustomMessageBar extends StatelessWidget {
//   final bool replying;
//   final String replyingTo;
//   final List<Widget> actions;
//   final TextEditingController _textController = TextEditingController();
//   final Color replyWidgetColor;
//   final Color replyIconColor;
//   final Color replyCloseColor;
//   final Color messageBarColor;
//   final String messageBarHintText;
//   final TextStyle messageBarHintStyle;
//   final TextStyle textFieldTextStyle;
//   final Color sendButtonColor;
//   final void Function(String)? onTextChanged;
//   final void Function(String)? onSend;
//   final void Function()? onTapCloseReply;
//   final ValueNotifier<bool>? isVoiceRecording;
//
//   CustomMessageBar({
//     super.key,
//     this.replying = false,
//     this.replyingTo = "",
//     this.actions = const [],
//     this.replyWidgetColor = const Color(0xffF4F4F5),
//     this.replyIconColor = Colors.blue,
//     this.replyCloseColor = Colors.black12,
//     this.messageBarColor = const Color(0xffF4F4F5),
//     this.sendButtonColor = Colors.blue,
//     this.messageBarHintText = "Type a message...",
//     this.messageBarHintStyle = const TextStyle(fontSize: 16),
//     this.textFieldTextStyle = const TextStyle(color: Colors.black),
//     this.onTextChanged,
//     this.onSend,
//     this.onTapCloseReply,
//     this.isVoiceRecording,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Align(
//       alignment: Alignment.bottomCenter,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: [
//           replying
//               ? Container(
//                   color: replyWidgetColor,
//                   padding: const EdgeInsets.symmetric(
//                     vertical: 8,
//                     horizontal: 16,
//                   ),
//                   child: Row(
//                     children: [
//                       Icon(
//                         Icons.reply,
//                         color: replyIconColor,
//                         size: 24,
//                       ),
//                       Expanded(
//                         child: Container(
//                           child: Text(
//                             'Re : ' + replyingTo,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                       ),
//                       InkWell(
//                         onTap: onTapCloseReply,
//                         child: Icon(
//                           Icons.close,
//                           color: replyCloseColor,
//                           size: 24,
//                         ),
//                       ),
//                     ],
//                   ))
//               : Container(),
//           replying
//               ? Container(
//                   height: 1,
//                   color: Colors.grey.shade300,
//                 )
//               : Container(),
//           Container(
//             color: messageBarColor,
//             padding: const EdgeInsets.symmetric(
//               vertical: 8,
//               horizontal: 16,
//             ),
//             child: Row(
//               children: <Widget>[
//                 ...actions,
//                 Expanded(
//                   child: TextField(
//                     controller: _textController,
//                     keyboardType: TextInputType.multiline,
//                     textCapitalization: TextCapitalization.sentences,
//                     minLines: 1,
//                     maxLines: 3,
//                     onChanged: onTextChanged,
//                     style: textFieldTextStyle,
//                     decoration: InputDecoration(
//                       hintText: messageBarHintText,
//                       hintMaxLines: 1,
//                       contentPadding: const EdgeInsets.symmetric(
//                           horizontal: 8.0, vertical: 10),
//                       hintStyle: messageBarHintStyle,
//                       fillColor: Colors.white,
//                       filled: true,
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(30.0),
//                         borderSide: const BorderSide(
//                           color: Colors.white,
//                           width: 0.2,
//                         ),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(30.0),
//                         borderSide: const BorderSide(
//                           color: Colors.black26,
//                           width: 0.2,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(left: 16),
//                   child: InkWell(
//                     child: Icon(
//                       Icons.send,
//                       color: sendButtonColor,
//                       size: 24,
//                     ),
//                     onTap: () {
//                       if (_textController.text.trim() != '') {
//                         if (onSend != null) {
//                           onSend!(_textController.text.trim());
//                         }
//                         _textController.text = '';
//                       }
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
