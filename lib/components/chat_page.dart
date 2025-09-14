import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:chat_bubbles/bubbles/bubble_normal_image.dart';
import 'package:chat_bubbles/bubbles/bubble_special_one.dart';
import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:chat_bubbles/bubbles/bubble_special_two.dart';
import 'package:chat_bubbles/message_bars/message_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart' as latLng;
import 'package:map_launcher/map_launcher.dart';
import 'package:nurse_app/main.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import 'call_screen.dart';
import 'custom_message_bar.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
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

  @override
  void initState() {
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
        child: Column(
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
                    const Text(
                      'Ahmad Sabbagh',
                      style: TextStyle(
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
                            id: 'pvz2v4bDmYb5OmMhTfpAA', // todo dynamic id
                          );

                          await call.getOrCreate();

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CallScreen(call: call),
                            ),
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
                    // shrinkWrap: true,
                    children: [
                      const BubbleSpecialOne(
                        text: 'Hello! How can I assist you today?',
                        color: Color.fromRGBO(122, 179, 65, 1.0),
                        isSender: false,
                        tail: true,
                        textStyle: TextStyle(color: Colors.white),
                      ),
                      const BubbleSpecialOne(
                        text: 'Hi! I have a question about my order.',
                        color: Color.fromRGBO(64, 115, 15, 1.0),
                        isSender: true,
                        tail: true,
                        textStyle: TextStyle(color: Colors.white),
                      ),
                      BubbleNormalImage(
                        id: '1',
                        image: FlutterMap(
                          options: MapOptions(
                            onTap: (tapPosition, point) async {
                              final availableMaps =
                                  await MapLauncher.installedMaps;

                              await availableMaps.first.showDirections(
                                destination: Coords(
                                  33.563520668688156,
                                  35.389677252154485,
                                ),
                                destinationTitle: 'Patient Location',
                              );
                            },
                            interactionOptions: const InteractionOptions(
                                flags: InteractiveFlag.none),
                            initialCenter: const latLng.LatLng(
                                33.563520668688156, 35.389677252154485),
                            initialZoom: 15.0,
                          ),
                          children: [
                            TileLayer(
                              urlTemplate:
                                  'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                              subdomains: const ['a', 'b', 'c'],
                              userAgentPackageName: "com.devzur.alahmad",
                            ),
                          ],
                        ),
                        isSender: false,
                      ),
                    ],
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
                                      child: Icon(Icons.image,
                                          color: Colors.white),
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
              onSend: (msg) {},
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
        ),
      ),
    );
  }
}
