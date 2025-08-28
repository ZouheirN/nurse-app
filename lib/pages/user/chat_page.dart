import 'package:chat_bubbles/bubbles/bubble_normal_image.dart';
import 'package:chat_bubbles/bubbles/bubble_special_one.dart';
import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:chat_bubbles/bubbles/bubble_special_two.dart';
import 'package:chat_bubbles/message_bars/message_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latLng;
import 'package:map_launcher/map_launcher.dart';
import 'package:nurse_app/main.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
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
                      onPressed: () {},
                      icon: const Icon(Icons.call, color: Colors.black87),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView(
                shrinkWrap: true,
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
                          final availableMaps = await MapLauncher.installedMaps;

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
            ),
            MessageBar(
              messageBarColor: const Color.fromRGBO(122, 179, 65, 1.0),
              onSend: (_) => print(_),
              sendButtonColor: Colors.white,
              actions: [
                InkWell(
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 24,
                  ),
                  onTap: () {},
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: InkWell(
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 24,
                    ),
                    onTap: () {},
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
