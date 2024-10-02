import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:nurse_app/components/labeled_edit_textfield.dart';
import 'package:nurse_app/components/third_button.dart';
import 'package:nurse_app/utilities/dialogs.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:nurse_app/features/location/cubit/location_cubit.dart';

class UpdateLocationPage extends StatefulWidget {
  const UpdateLocationPage({super.key});

  @override
  _UpdateLocationPageState createState() => _UpdateLocationPageState();
}

class _UpdateLocationPageState extends State<UpdateLocationPage> {
  LatLng _initialPosition = const LatLng(0.0, 0.0);
  final MapController _mapController = MapController();

  final _locationCubit = LocationCubit();

  @override
  void initState() {
    super.initState();
    _setInitialLocation();
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

    _locationCubit.updateLocation(latitude: latLng.latitude, longitude: latLng.longitude);

    print("Location Updated: $_initialPosition");
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
            const LabeledEditTextfield(
              label: 'Enter Your Location Details',
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 20),
            BlocConsumer<LocationCubit, LocationState>(
              bloc:  _locationCubit,
              listener: (context, state) {
                if (state is LocationUpdateSuccess) {
                  QuickAlert.show(
                    context: context,
                    type: QuickAlertType.success,
                    text: 'Location Updated Successfully',
                    onConfirmBtnTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                  );
                } else if (state is LocationUpdateFailure) {
                  Dialogs.showErrorDialog(context, 'Error Updating Location', state.message);
                }
              },
              builder: (context, state) {
                final isLoading = state is LocationUpdateLoading;

                return MyThirdButton(
                  isLoading: isLoading,
                  onTap: () {
                    _updateLocation(_initialPosition);
                  },
                  buttonText: 'Save',
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
