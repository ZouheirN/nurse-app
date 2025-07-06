import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:nurse_app/consts.dart';
import 'package:nurse_app/main.dart';
import 'package:nurse_app/services/user.dart';
import 'package:nurse_app/services/user_token.dart';

class Header extends StatefulWidget {
  final bool showLocation;

  const Header({super.key, required this.showLocation});

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  // String location = 'Loading...';

  ValueNotifier<bool?> isLocationServiceEnabled = ValueNotifier<bool?>(null);

  @override
  void initState() {
    super.initState();
    fetchUserData();
    checkLocationService();
  }

  Future<void> checkLocationService() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    isLocationServiceEnabled.value = serviceEnabled;
  }

  Future<void> fetchUserData() async {
    try {
      final token = await UserToken.getToken();

      if (token != null) {
        final response = await http.get(
          Uri.parse('$HOST/me'),
          headers: {
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode == 200) {
          final jsonData = json.decode(response.body);

          // Fetch location based on latitude and longitude
          final double? latitude = jsonData['latitude'];
          final double? longitude = jsonData['longitude'];

          if (latitude != null && longitude != null) {
            fetchLocationFromCoordinates(latitude, longitude);
          } else {
            UserBox.setUserLocation(
                'Location not available\nTap to update your location');
            // setState(() {
            //   location = 'Location not available\nTap to update your location';
            // });
          }
        }
      }
    } catch (e) {
      logger.e('Error fetching user data: $e');
    }
  }

  Future<void> fetchLocationFromCoordinates(
      double latitude, double longitude) async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://nominatim.openstreetmap.org/reverse?format=json&lat=$latitude&lon=$longitude'),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        UserBox.setUserLocation(jsonData['display_name'] ?? 'Unknown Location');
      } else {
        // UserBox.setUserLocation('Unable to fetch location');
        // setState(() {
        //   location = 'Unable to fetch location';
        // });
      }
    } catch (e) {
      logger.e('Error fetching location: $e');
      // setState(() {
      //   location = 'Unable to fetch location';
      // });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: UserBox.listenToUser(),
      builder: (context, value, child) {
        final user = UserBox.getUser();

        return Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/header_background.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: ListTile(
                minVerticalPadding: 0,
                leading: const ColorFiltered(
                  colorFilter:
                      ColorFilter.mode(Colors.white, BlendMode.srcATop),
                  child: Image(
                    image: AssetImage('assets/images/square_logo.png'),
                  ),
                ),
                title: IntrinsicHeight(
                  child: Row(
                    children: [
                      const VerticalDivider(
                        color: Colors.white,
                        thickness: 2,
                      ),
                      Expanded(
                        child: Text(
                          'Welcome Back,\n${user?.name ?? ''}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 20,
                            fontStyle: FontStyle.italic,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                trailing: IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/editProfile');
                  },
                  icon: const CircleAvatar(
                    backgroundColor: Color.fromRGBO(217, 217, 217, 1),
                    child: Icon(
                      Icons.person_outline_rounded,
                      color: Color(0xFF7BB442),
                    ),
                  ),
                ),
              ),
            ),
            ValueListenableBuilder<bool?>(
              valueListenable: isLocationServiceEnabled,
              builder: (context, serviceEnabled, child) {
                if (serviceEnabled == null || serviceEnabled) {
                  return const SizedBox.shrink();
                }

                return Container(
                  width: double.infinity,
                  color: const Color.fromRGBO(123, 180, 66, 1),
                  child: Row(
                    children: [
                      const Text(
                        ' Please turn on the location to use the app correctly',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          isLocationServiceEnabled.value = null;
                        },
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            if (widget.showLocation)
              ListTile(
                contentPadding: const EdgeInsets.only(
                  left: 4,
                  right: 4,
                ),
                leading: const Icon(
                  Icons.location_on,
                  color: Colors.black,
                ),
                title: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/updateLocation');
                  },
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          user?.location ?? 'Loading...',
                          // 'Saida, Lebanon',
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );

        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/updateLocation');
                    },
                    child: Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.location_on),
                        ),
                        Expanded(
                          child: Text(
                            user?.location ?? 'Loading...',
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/editProfile');
              },
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.person),
                  ),
                  Text(
                    'Welcome Back ${user?.name ?? ''}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:nurse_app/services/user.dart';
//
// class Header extends StatelessWidget {
//   const Header({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return ValueListenableBuilder(
//         valueListenable: UserBox.listenToUser(),
//         builder: (context, value, child) {
//           return Column(
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Row(
//                     children: [
//                       IconButton(
//                         icon: const Icon(Icons.location_on),
//                         onPressed: () {
//                           Navigator.pushNamed(context, '/updateLocation');
//                         },
//                       ),
//                       Text(
//                         UserBox.getUser()?.location ?? 'No Location',
//                         style: const TextStyle(
//                           fontWeight: FontWeight.w700,
//                           fontSize: 16,
//                         ),
//                       ),
//                     ],
//                   ),
//                   IconButton(
//                     icon: const Icon(
//                       Icons.notifications_none,
//                       color: Color(0xFF7BB442),
//                     ),
//                     onPressed: () {
//                       Navigator.pushNamed(context, '/notification');
//                     },
//                   ),
//                 ],
//               ),
//               Row(
//                 children: [
//                   IconButton(
//                     icon: const Icon(Icons.person),
//                     onPressed: () {
//                       Navigator.pushNamed(context, '/editProfile');
//                     },
//                   ),
//                   Text(
//                     'Welcome Back ${UserBox.getUser()?.name ?? ''}',
//                     style: const TextStyle(
//                       fontWeight: FontWeight.w500,
//                       fontSize: 16,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           );
//         });
//   }
// }
