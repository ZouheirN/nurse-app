import 'dart:async';
import 'dart:io';

import 'package:chat_bubbles/bubbles/bubble_normal_image.dart';
import 'package:chat_bubbles/bubbles/bubble_special_one.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart' as lat_lng;
import 'package:map_launcher/map_launcher.dart';
import 'package:nurse_app/components/loader.dart';
import 'package:nurse_app/features/chat/cubit/chat_cubit.dart';
import 'package:nurse_app/features/chat/models/get_messages_model.dart';
import 'package:nurse_app/main.dart';
import 'package:nurse_app/services/user.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:nurse_app/services/user_token.dart' as ut;

import 'call_screen.dart';
import 'custom_message_bar.dart';

class ChatPage extends StatefulWidget {
  final int requestId;
  final bool isAdmin;
  final String? patientName;

  const ChatPage({
    super.key,
    required this.requestId,
    required this.isAdmin,
    this.patientName,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _chatCubit = ChatCubit();
  final _chatCubitMsg = ChatCubit();

  final ValueNotifier<bool> _showAttach = ValueNotifier(false);
  final ValueNotifier<bool> _isVoiceRecording = ValueNotifier(false);

  // message box
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  final FlutterSoundRecorder _soundRecorder = FlutterSoundRecorder();
  bool isRecorderInitialised = false;
  final ValueNotifier<bool> isUploading = ValueNotifier(false);
  final ValueNotifier<bool> isRecording = ValueNotifier(false);
  Timer recordingDurationTimer = Timer(Duration.zero, () {});
  final ValueNotifier<Duration> recordingDuration =
      ValueNotifier(Duration.zero);

  List<Message> messages = [];

  @override
  void initState() {
    _chatCubit.initializeChat(widget.requestId);
    _openAudio();
    super.initState();
  }

  void _openAudio() async {
    final status = await Permission.microphone.request();

    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Microphone permission not granted');
    }

    await _soundRecorder.openRecorder();
    _soundRecorder.onProgress!.listen((e) {
      setState(() {
        final pos = e.duration.inMilliseconds;

        recordingDuration.value = Duration(milliseconds: pos);
      });
    });
    await _soundRecorder.setSubscriptionDuration(
      const Duration(seconds: 1),
    );
    isRecording.addListener(() {
      if (!isRecording.value) {
        recordingDurationTimer.cancel();
        recordingDuration.value = const Duration();
      }
    });
    isRecorderInitialised = true;
  }

  @override
  void dispose() {
    _messageController.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    _soundRecorder.closeRecorder();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: const Icon(Icons.chevron_left, size: 48, color: Colors.white),
        ),
        title: const Text(
          'Service Chat',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            fontStyle: FontStyle.italic,
          ),
        ),
        centerTitle: true,
        flexibleSpace: const Image(
          image: AssetImage('assets/images/header_background.png'),
          fit: BoxFit.cover,
        ),
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: const Color.fromRGBO(243, 253, 233, 1.0),
      body: SafeArea(
        child: BlocConsumer<ChatCubit, ChatState>(
          bloc: _chatCubit,
          listener: (context, state) {
            if (state is ChatLoaded) {
              _chatCubitMsg.getMessages(chatId: state.chatId);
            }
          },
          builder: (context, state) {
            if (state is ChatLoading) {
              return const Loader();
            } else if (state is ChatError) {
              return Center(
                child: Text(
                  state.message,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            } else if (state is ChatLoaded) {
              final chatId = state.chatId;

              return _buildChatPage(chatId: chatId);
            } else {
              return const Center(
                child: Text(
                  'An unexpected error occurred',
                  style: TextStyle(color: Colors.red),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildChatPage({
    required int chatId,
  }) {
    return Column(
      children: [
        Container(
          height: 60,
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.08),
                blurRadius: 4,
                spreadRadius: 0,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        Color.fromRGBO(19, 27, 10, 1),
                        Color.fromRGBO(101, 148, 54, 1),
                      ],
                      begin: Alignment.centerRight,
                      end: Alignment.centerLeft,
                    ),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Image.asset(
                    'assets/images/user2.png',
                  ),
                ),
                Text(
                  widget.patientName ?? 'Al Ahmad',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    try {
                      var call = StreamVideo.instance.makeCall(
                        callType: StreamCallType.defaultType(),
                        id: chatId.toString(),
                      );

                      final result = await call.getOrCreate(
                        memberIds: ['2'],
                        video: false,
                        ringing: true,
                      );

                      result.fold(
                        success: (success) {
                          if (mounted) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => CallScreen(
                                  call: call,
                                ),
                              ),
                            );
                          }
                        },
                        failure: (failure) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(failure.error.message),
                            ),
                          );
                        },
                      );
                    } catch (e) {
                      logger.e(e.toString());
                    }
                  },
                  icon: const Icon(Icons.call, color: Colors.black87),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              ListView(
                shrinkWrap: true,
                children: [
                  _buildMessages(),
                ],
                // children :[
                // const BubbleSpecialOne(
                //   text: 'Hello! How can I assist you today?',
                //   color: Color.fromRGBO(122, 179, 65, 1.0),
                //   isSender: false,
                //   tail: true,
                //   textStyle: TextStyle(color: Colors.white),
                // ),
                // const BubbleSpecialOne(
                //   text: 'Hi! I have a question about my order.',
                //   color: Color.fromRGBO(64, 115, 15, 1.0),
                //   isSender: true,
                //   tail: true,
                //   textStyle: TextStyle(color: Colors.white),
                // ),
                // BubbleNormalImage(
                //   id: '1',
                //   image: FlutterMap(
                //     options: MapOptions(
                //       onTap: (tapPosition, point) async {
                //         final availableMaps = await MapLauncher.installedMaps;
                //
                //         await availableMaps.first.showDirections(
                //           destination: Coords(
                //             33.563520668688156,
                //             35.389677252154485,
                //           ),
                //           destinationTitle: 'Patient Location',
                //         );
                //       },
                //       interactionOptions: const InteractionOptions(
                //           flags: InteractiveFlag.none),
                //       initialCenter: const lat_lng.LatLng(
                //           33.563520668688156, 35.389677252154485),
                //       initialZoom: 15.0,
                //     ),
                //     children: [
                //       TileLayer(
                //         urlTemplate:
                //             'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                //         subdomains: const ['a', 'b', 'c'],
                //         userAgentPackageName: "com.devzur.alahmad",
                //       ),
                //     ],
                //   ),
                //   isSender: false,
                // ),
                // ],
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: ValueListenableBuilder<bool>(
                  valueListenable: _showAttach,
                  builder: (context, value, child) {
                    if (!value) return const SizedBox.shrink();

                    return Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                            onTap: () async {
                              final image = await ImagePicker().pickImage(
                                source: ImageSource.gallery,
                              );

                              if (image == null) return;

                              CroppedFile? croppedImage =
                                  await ImageCropper().cropImage(
                                sourcePath: image.path,
                              );

                              if (croppedImage == null) return;

                              final pickedImage = File(croppedImage.path);
                            },
                            child: const Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircleAvatar(
                                  radius: 24,
                                  backgroundColor:
                                      Color.fromRGBO(122, 179, 65, 1.0),
                                  child: Icon(Icons.image, color: Colors.white),
                                ),
                                SizedBox(height: 4),
                                Text('Gallery'),
                              ],
                            ),
                          ),
                          const Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleAvatar(
                                radius: 24,
                                backgroundColor:
                                    Color.fromRGBO(122, 179, 65, 1.0),
                                child: Icon(Icons.location_on,
                                    color: Colors.white),
                              ),
                              SizedBox(height: 4),
                              Text('Location'),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        MobileMessageBox(
          focusNode: _focusNode,
          receiverId: 'todo',
          isRecording: isRecording,
          isUploading: isUploading,
          messageController: _messageController,
          recordingDuration: recordingDuration,
          onSend: (msg) {
            _chatCubitMsg.sendTextMessage(text: msg, chatId: chatId);
          },
          onVoiceSend: (path) async {
            isUploading.value = true;

            // extract the file name from the file path
            final List<String> pathParts = path.split('/');
            final String fileName = pathParts.last;

            // Upload the file to firestore and get link
            // List<String> fileUrls = await StorageService().uploadFiles(
            //   widget.receiverId,
            //   [File(filePath)],
            //   [fileName],
            // );
            //
            // // Send the FileMessage
            // _chatService.sendVoiceMessages(
            //   receiverId: widget.receiverId,
            //   voiceMessagesUrl: fileUrls,
            //   voiceMessageNames: [fileName],
            // );

            isUploading.value = false;
          },
          // sendVoiceMessage: _sendVoiceMessage,
          soundRecorder: _soundRecorder,
          leftAction: ValueListenableBuilder<bool>(
            valueListenable: _showAttach,
            builder: (context, value, child) {
              return InkWell(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 100),
                  transitionBuilder: (child, anim) => RotationTransition(
                    turns: child.key == const ValueKey('icon1')
                        ? Tween<double>(begin: 1, end: 0.75).animate(anim)
                        : Tween<double>(begin: 0.75, end: 1).animate(anim),
                    child: FadeTransition(opacity: anim, child: child),
                  ),
                  child: value
                      ? const Icon(Icons.close,
                          color: Color.fromRGBO(122, 179, 65, 1.0),
                          size: 24,
                          key: ValueKey('icon1'))
                      : const Icon(
                          Icons.add,
                          color: Color.fromRGBO(122, 179, 65, 1.0),
                          size: 24,
                          key: ValueKey('icon2'),
                        ),
                ),
                onTap: () {
                  _showAttach.value = !_showAttach.value;
                },
              );
            },
          ),
          rightAction: InkWell(
            child: const Icon(
              Icons.camera_alt,
              color: Color.fromRGBO(122, 179, 65, 1.0),
              size: 24,
            ),
            onTap: () async {
              final image = await ImagePicker().pickImage(
                source: ImageSource.camera,
              );

              if (image == null) return;

              CroppedFile? croppedImage = await ImageCropper().cropImage(
                sourcePath: image.path,
              );

              if (croppedImage == null) return;

              final pickedImage = File(croppedImage.path);
            },
          ),
        ),
        // CustomMessageBar(
        //   messageBarColor: const Color.fromRGBO(122, 179, 65, 1.0),
        //   onSend: (msg) {},
        //   sendButtonColor: Colors.white,
        //   actions: [
        //     //
        //     // Padding(
        //     //   padding: const EdgeInsets.only(left: 8, right: 8),
        //     //   child:
        //     // ),
        //   ],
        // ),
      ],
    );
  }

  Widget _buildMessages() {
    return BlocConsumer(
      bloc: _chatCubitMsg,
      listener: (context, state) {
        if (state is MessagesLoaded) {
          final messages = state.messages.data?.messages;

          for (var msg in messages!) {
            if (!this.messages.any((m) => m.id == msg.id)) {
              this.messages.add(msg);
            }
          }
        }

        if (state is SendMessageSuccess) {
          _messageController.clear();
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent + 100,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );

          // add message to the start
          messages.insert(0, state.message);
        }
      },
      builder: (context, state) {
        final userId = UserBox.getUser()!.id?.toInt();

        return ListView.builder(
          reverse: true,
          itemCount: messages.length,
          shrinkWrap: true,
          controller: _scrollController,
          itemBuilder: (context, index) {
            final message = messages[index];

            switch (message.type) {
              case 'text':
                return userId != message.senderId
                    ? BubbleSpecialOne(
                        text: message.text ?? '',
                        color: const Color.fromRGBO(122, 179, 65, 1.0),
                        isSender: false,
                        tail: true,
                        textStyle: const TextStyle(color: Colors.white),
                      )
                    : BubbleSpecialOne(
                        text: message.text ?? '',
                        color: const Color.fromRGBO(64, 115, 15, 1.0),
                        isSender: true,
                        tail: true,
                        textStyle: const TextStyle(color: Colors.white),
                      );
              default:
                return const Text('Unsupported message type');
            }
          },
        );
      },
    );

    // return StreamBuilder(
    //   stream: streamSocket.getResponse,
    //   initialData: messages,
    //   builder: (context, snapshot) {
    //     if (snapshot.hasError) {
    //       return Center(
    //         child: Text(
    //           'Error: ${snapshot.error}',
    //           style: const TextStyle(color: Colors.red),
    //         ),
    //       );
    //     }
    //
    //     if (!snapshot.hasData) {
    //       return const Loader();
    //     }
    //
    //     final data = snapshot.data;
    //
    //     if (data is! List<Message>) {
    //       return const Text('No messages');
    //     }
    //
    //     return ListView.builder(
    //       itemCount: data.length,
    //       shrinkWrap: true,
    //       controller: _scrollController,
    //       itemBuilder: (context, index) {
    //         final message = data[index];
    //
    //         switch (message.type) {
    //           case 'text':
    //             return widget.isAdmin
    //                 ? BubbleSpecialOne(
    //                     text: message.text ?? '',
    //                     color: const Color.fromRGBO(122, 179, 65, 1.0),
    //                     isSender: false,
    //                     tail: true,
    //                     textStyle: const TextStyle(color: Colors.white),
    //                   )
    //                 : BubbleSpecialOne(
    //                     text: message.text ?? '',
    //                     color: const Color.fromRGBO(64, 115, 15, 1.0),
    //                     isSender: true,
    //                     tail: true,
    //                     textStyle: const TextStyle(color: Colors.white),
    //                   );
    //           default:
    //             return const Text('Unsupported message type');
    //         }
    //       },
    //     );
    //   },
    // );
  }
}
