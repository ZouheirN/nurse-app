import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:nurse_app/components/labeled_edit_textfield.dart';
import 'package:nurse_app/components/third_button.dart';
import 'package:nurse_app/features/location/cubit/location_cubit.dart';
import 'package:nurse_app/main.dart';
import 'package:nurse_app/utilities/dialogs.dart';

class UpdateLocationPage extends StatefulWidget {
  const UpdateLocationPage({super.key});

  @override
  _UpdateLocationPageState createState() => _UpdateLocationPageState();
}

class _UpdateLocationPageState extends State<UpdateLocationPage> {
  LatLng _initialPosition = const LatLng(0.0, 0.0);
  final MapController _mapController = MapController();

  final _locationCubit = LocationCubit();

  bool _isGetLocationLoading = false;

  final _locationController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      _setInitialLocation();
    });
  }

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  void _setInitialLocation() async {
    var currentLocation = const LatLng(33.851338, 35.518375);
    setState(() {
      _initialPosition = currentLocation;
    });
    _mapController.move(_initialPosition, 15.0);
  }

  void _updateLocation(LatLng latLng) {
    setState(() {
      _initialPosition = latLng;
    });
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            const Text(
              'Update Location',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700,
                fontSize: 23,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 20),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.9,
                width: MediaQuery.of(context).size.width * 0.9,
                child: FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _initialPosition,
                    initialZoom: 16,
                    onTap: (tapPosition, point) {
                      _updateLocation(point);
                    },
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                      // subdomains: ['a', 'b', 'c'],
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: _initialPosition,
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
                ),
              ),
              const SizedBox(height: 20),
              MyThirdButton(
                isLoading: _isGetLocationLoading,
                onTap: () async {
                  if (_isGetLocationLoading) return;

                  final hasPermission = await _handleLocationPermission();
                  if (!hasPermission) return;

                  setState(() {
                    _isGetLocationLoading = true;
                  });

                  await Geolocator.getCurrentPosition(
                    locationSettings: const LocationSettings(
                      accuracy: LocationAccuracy.high,
                    ),
                  ).then((Position position) {
                    setState(() => _initialPosition =
                        LatLng(position.latitude, position.longitude));
                    _mapController.move(_initialPosition, 15.0);
                  }).catchError((e) {
                    Dialogs.showErrorDialog(context, 'Error', e.toString());
                    logger.e(e);
                  });

                  setState(() {
                    _isGetLocationLoading = false;
                  });
                },
                buttonText: 'Get Current Location',
                margin: const EdgeInsets.symmetric(horizontal: 110),
              ),
              const SizedBox(height: 20),
              LabeledEditTextfield(
                label: 'Enter Your Location Details',
                keyboardType: TextInputType.text,
                controller: _locationController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your location details';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 20),
              BlocConsumer<LocationCubit, LocationState>(
                bloc: _locationCubit,
                listener: (context, state) {
                  if (state is LocationUpdateSuccess) {
                    Dialogs.showSuccessDialog(
                      context,
                      'Success',
                      'Location Updated Successfully',
                      onConfirmBtnTap: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                    );
                  } else if (state is LocationUpdateFailure) {
                    Dialogs.showErrorDialog(
                        context, 'Error Updating Location', state.message);
                  }
                },
                builder: (context, state) {
                  final isLoading = state is LocationUpdateLoading;

                  return MyThirdButton(
                    isLoading: isLoading,
                    onTap: () async {
                      if (_formKey.currentState!.validate()) {
                        await _locationCubit.updateLocation(
                          latitude: _initialPosition.latitude,
                          longitude: _initialPosition.longitude,
                          locationDetails: _locationController.text.trim(),
                        );
                      }
                    },
                    buttonText: 'Save',
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
