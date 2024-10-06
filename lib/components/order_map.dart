import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:nurse_app/components/loader.dart';
import 'package:nurse_app/consts.dart';
import 'package:nurse_app/main.dart';

class OrderMap extends StatefulWidget {
  final LatLng patientLocation;

  const OrderMap({super.key, required this.patientLocation});

  @override
  State<OrderMap> createState() => _OrderMapState();
}

class _OrderMapState extends State<OrderMap> {
  List<LatLng> _latLongPoints = [];

  bool isInDelay = false;

  Future<void> getDirections({
    required LatLng origin,
    required LatLng destination,
  }) async {
    if (isInDelay) {
      return;
    }

    final dio = Dio();

    try {
      final response = await dio.get(
        'https://api.openrouteservice.org/v2/directions/driving-car?api_key=$ORS_API_KEY&start=${origin.longitude},${origin.latitude}&end=${destination.longitude},${destination.latitude}',
      );

      setState(() {
        List points = response.data['features'][0]['geometry']['coordinates'];
        _latLongPoints =
            points.map((point) => LatLng(point[1], point[0])).toList();
      });
    } on DioException catch (e) {
      logger.e(e.response!.data);
    } catch (e) {
      logger.e(e);
    }

    // add a 15 seconds delay to get the next location
    isInDelay = true;
    Timer(const Duration(seconds: 15), () {
      isInDelay = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        initialCenter: widget.patientLocation,
        initialZoom: 16,
      ),
      children: [
        TileLayer(
          urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
        ),
        MarkerLayer(
          markers: [
            Marker(
              point: widget.patientLocation,
              width: 80,
              height: 80,
              child: const Icon(
                Icons.location_on,
                color: Colors.red,
                size: 40,
              ),
            ),
          ],
        ),
      ],
    );

    return StreamBuilder(
      stream: Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loader();
        }

        LatLng userLocation = LatLng(
          snapshot.data!.latitude,
          snapshot.data!.longitude,
        );

        getDirections(
          origin: userLocation,
          destination: widget.patientLocation,
        );

        return FlutterMap(
          options: MapOptions(
            initialCenter: widget.patientLocation,
            initialZoom: 16,
          ),
          children: [
            TileLayer(
              urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: widget.patientLocation,
                  width: 80,
                  height: 80,
                  child: const Icon(
                    Icons.location_on,
                    color: Colors.red,
                    size: 40,
                  ),
                ),
                Marker(
                  point: userLocation,
                  width: 80,
                  height: 80,
                  child: const Icon(
                    Icons.location_on,
                    color: Colors.blue,
                    size: 40,
                  ),
                ),
              ],
            ),
            PolylineLayer(
              polylines: [
                Polyline(
                  points: _latLongPoints,
                  strokeWidth: 2.0,
                  color: Colors.blue,
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
