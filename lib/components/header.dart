import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nurse_app/consts.dart';
import 'package:nurse_app/services/user_token.dart';

class Header extends StatefulWidget {
  const Header({super.key});

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  String name = '';
  String location = 'Loading...';

  @override
  void initState() {
    super.initState();
    fetchUserData();
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
          setState(() {
            name = jsonData['name'].split(' ')[0] ?? '';
          });

          // Fetch location based on latitude and longitude
          final double? latitude = jsonData['latitude'];
          final double? longitude = jsonData['longitude'];

          if (latitude != null && longitude != null) {
            fetchLocationFromCoordinates(latitude, longitude);
          } else {
            setState(() {
              location = 'Location not available';
            });
          }
        }
      }
    } catch (e) {
      print('Error fetching user data: $e');
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
        setState(() {
          location = jsonData['display_name'] ?? 'Unknown Location';
        });
      } else {
        setState(() {
          location = 'Unable to fetch location';
        });
      }
    } catch (e) {
      print('Error fetching location: $e');
      setState(() {
        location = 'Unable to fetch location';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.location_on),
                  onPressed: () {
                    Navigator.pushNamed(context, '/updateLocation');
                  },
                ),
                Text(
                  location,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            IconButton(
              icon: const Icon(
                Icons.notifications_none,
                color: Color(0xFF7BB442),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/notification');
              },
            ),
          ],
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {
                Navigator.pushNamed(context, '/editProfile');
              },
            ),
            Text(
              'Welcome Back $name',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ],
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
