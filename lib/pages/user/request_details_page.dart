import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nurse_app/components/loader.dart';
import 'package:nurse_app/components/request_stepper.dart';
import 'package:nurse_app/components/star_rating.dart';
import 'package:nurse_app/features/request/cubit/request_cubit.dart';
import 'package:nurse_app/utilities/helper_functions.dart';

import '../../features/request/models/request_details_model.dart';

class RequestDetailsPage extends StatelessWidget {
  final num requestId;

  RequestDetailsPage({super.key, required this.requestId});

  final _requestCubit = RequestCubit();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: const Icon(Icons.chevron_left, size: 48, color: Colors.white),
        ),
        title: const Text(
          'Request Details',
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
      body: SafeArea(
        child: BlocBuilder<RequestCubit, RequestState>(
          bloc: _requestCubit..getOrder(orderId: requestId),
          builder: (context, state) {
            if (state is RequestDetailsLoading) {
              return const Loader();
            }

            if (state is RequestDetailsFailure) {
              return Center(
                child: Text(
                  'Error: ${state.message}',
                ),
              );
            }

            if (state is RequestDetailsSuccess) {
              final request = state.request;

              final isOngoing = isRequestOngoing(request.status);
              // const isOngoing = true;

              // todo fix names of requests (not hardcoded)
              if (isOngoing) {
                return _buildOngoingDetails(request, context);
              } else {
                return _buildNormalDetails(request);
              }
            }

            return const Center(
              child: Text('Failed to load request details'),
            );
          },
        ),
      ),
    );
  }

  Widget _buildNormalDetails(RequestDetailsModel request) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: const BoxDecoration(
          color: Color.fromRGBO(255, 255, 255, 1),
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 6,
              spreadRadius: 0,
              offset: Offset(0, 0),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Image.asset(
              'assets/images/default.png',
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  request.problemDescription,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Container(
                  height: 28,
                  width: 28,
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(123, 180, 66, 1),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 4,
                        spreadRadius: 0,
                        offset: Offset(-4, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      '\$${formatPrice(request.totalPrice)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Request Details',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Row(
              children: [
                Text(
                  'Nurse Name: ',
                  style: TextStyle(
                    fontSize: 22,
                    color: Color.fromRGBO(122, 179, 65, 1.0),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'TODO',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.italic,
                  ),
                )
              ],
            ),
            if (request.timeNeededToArrive != null)
              Row(
                children: [
                  const Text(
                    'Time to arrive: ',
                    style: TextStyle(
                      fontSize: 22,
                      color: Color.fromRGBO(122, 179, 65, 1.0),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '${request.timeNeededToArrive!.toStringAsFixed(0)} mins',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.italic,
                    ),
                  )
                ],
              ),
            // const Row(
            //   children: [
            //     Text(
            //       'Rating: ',
            //       style: TextStyle(
            //         fontSize: 22,
            //         color: Color.fromRGBO(122, 179, 65, 1.0),
            //         fontWeight: FontWeight.w600,
            //       ),
            //     ),
            //     StarRating(
            //       nurseId: 1, // todo Replace with actual nurse ID
            //       initialRating: 4,
            //     ),
            //   ],
            // ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Request Date: ${formatDateTimeForRequestDetails(request.createdAt!)}',
                style: const TextStyle(
                  fontSize: 13,
                  color: Color.fromRGBO(142, 142, 142, 1),
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            // if (request.nurse != null && request.nurseId != null)
            //   _buildNurseDetails(request.nurseId!),
            // if (request.services != null)
            //   _buildServiceDetails(request.services!),
            // if (request.endingTime == null &&
            //     request.timeNeededToArrive != null)
            // if (request.nurse != null && request.nurseId != null)
            // _buildRequestDate(request),
            const SizedBox(height: 30),
            const ColorFiltered(
              colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcATop),
              child: Image(
                image: AssetImage('assets/images/square_logo.png'),
                height: 110,
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildOngoingDetails(
      RequestDetailsModel request, BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(123, 180, 66, 1),
              Color.fromRGBO(55, 80, 30, 1)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 6,
              spreadRadius: 0,
              offset: Offset(0, 0),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Image.asset(
              'assets/images/default.png',
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  request.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Container(
                  height: 28,
                  width: 28,
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(123, 180, 66, 1),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 2,
                        spreadRadius: 0,
                        offset: Offset(-2, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      '\$${formatPrice(request.totalPrice)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Request Details',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Row(
              children: [
                Text(
                  'Nurse Name: ',
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'TODO',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.italic,
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Request Tracking',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Arriving at 11:25 PM',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: RequestStepper(
                currentStep: 1,
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Text(
                  'Your Request is being Prepared',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Image(
              image: AssetImage('assets/images/clock.png'),
              height: 147,
            ),
            const SizedBox(height: 20),
            Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed('/chat', arguments: {
                    'requestId': request.id,
                    'isAdmin': false,
                  });
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black, width: 1),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.25),
                        blurRadius: 4,
                        spreadRadius: 0,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.chat_bubble_outline,
                        size: 24,
                      ),
                      Spacer(),
                      Text(
                        'Live Chat',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      Spacer(),
                      // CircleAvatar(
                      //   radius: 18,
                      //   backgroundColor: Colors.black,
                      //   child: Text(
                      //     '1',
                      //     style: TextStyle(
                      //       fontSize: 24,
                      //       fontWeight: FontWeight.w700,
                      //       color: Colors.white,
                      //       fontStyle: FontStyle.italic,
                      //     ),
                      //   ),
                      // )
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

// Widget _buildNurseDetails(num nurseId) {
//   return BlocBuilder<NurseCubit, NurseState>(
//     bloc: NurseCubit()..fetchNurse(nurseId),
//     builder: (context, state) {
//       if (state is NurseDetailsFetchLoading) {
//         return const Loader();
//       }
//
//       if (state is NurseDetailsFetchSuccess) {
//         final nurse = state.nurse.nurse!;
//
//         return Column(
//           children: [
//             if (nurse.profilePicture != null)
//               CachedNetworkImage(
//                 imageUrl: nurse.profilePicture!,
//                 height: 250,
//                 imageRenderMethodForWeb: ImageRenderMethodForWeb.HttpGet,
//                 fit: BoxFit.contain,
//               )
//             else
//               Image.asset(
//                 'assets/images/default_profile.png',
//                 height: 250,
//                 fit: BoxFit.contain,
//               ),
//             const SizedBox(height: 20),
//             TextData(
//               label: 'Nurse name: ',
//               data: Text(
//                 nurse.name ?? '',
//                 style: const TextStyle(
//                   fontSize: 22,
//                   color: Color(0xFF000000),
//                   fontWeight: FontWeight.w400,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 10),
//           ],
//         );
//       }
//
//       return const SizedBox();
//     },
//   );
// }

// Widget _buildServiceDetails(List<Service> services) {
//   return Column(
//     children: services.map((service) {
//       return Container(
//         margin: const EdgeInsets.only(bottom: 10),
//         // decoration: BoxDecoration(
//         //   color: Colors.white,
//         //   borderRadius: BorderRadius.circular(10),
//         //   border: Border.all(
//         //     color: const Color.fromARGB(255, 221, 221, 221),
//         //     width: 1,
//         //   ),
//         // ),
//         child: Column(
//           children: [
//             TextData(
//               label: 'Service: ',
//               data: Text(
//                 service.name,
//                 style: const TextStyle(
//                   fontSize: 22,
//                   color: Color(0xFF000000),
//                   fontWeight: FontWeight.w400,
//                 ),
//                 overflow: TextOverflow.visible,
//               ),
//             ),
//             const SizedBox(height: 10),
//             TextData(
//               label: 'Service Price: ',
//               data: Row(
//                 children: [
//                   Stack(
//                     alignment: Alignment.center,
//                     children: [
//                       Text(
//                         '\$${formatPrice(num.tryParse(service.price))}',
//                         style: const TextStyle(
//                           // color: service.discountPrice != null
//                           //     ? Colors.grey
//                           //     : Colors.black,
//                           fontSize: 22,
//                           fontWeight: FontWeight.w400,
//                         ),
//                       ),
//                       // if (service.discountPrice != null)
//                       //   Positioned.fill(
//                       //     child: CustomPaint(
//                       //       painter: DiagonalLinePainter(),
//                       //     ),
//                       //   ),
//                     ],
//                   ),
//                   // if (service.discountPrice != null) ...[
//                   //   const SizedBox(width: 5),
//                   //   FittedBox(
//                   //     fit: BoxFit.scaleDown,
//                   //     child: Text(
//                   //       '\$${formatPrice(service.discountPrice!)}',
//                   //       style: const TextStyle(
//                   //         fontSize: 22,
//                   //         fontWeight: FontWeight.w400,
//                   //       ),
//                   //     ),
//                   //   ),
//                   // ],
//                 ],
//               ),
//             ),
//             const SizedBox(height: 10),
//           ],
//         ),
//       );
//     }).toList(),
//   );
// }
//
// Widget _buildRequestDate(RequestDetailsModel request) {
//   return Padding(
//     padding: const EdgeInsets.symmetric(horizontal: 40),
//     child: Container(
//       decoration: BoxDecoration(
//         color: const Color(0xFFE7E7E7),
//         border: Border.all(
//           color: const Color(0xFFE7E7E7),
//           width: 2,
//         ),
//         borderRadius: BorderRadius.circular(10),
//       ),
//       padding: const EdgeInsets.symmetric(vertical: 10),
//       child: Column(
//         children: [
//           UneditableLabeledDate(
//             label: 'Start Date',
//             date: request.scheduledTime!,
//           ),
//           // const SizedBox(height: 7),
//           // UneditableLabeledDate(
//           //   label: 'End Date',
//           //   date: request.endingTime!,
//           // ),
//         ],
//       ),
//     ),
//   );
//
//   // if (request.endingTime == null) {
//   //   return Padding(
//   //     padding: const EdgeInsets.symmetric(horizontal: 40),
//   //     child: Text(
//   //       'Request Date: ${formatDateTimeForRequestDetails(request.createdAt!)}',
//   //       style: const TextStyle(
//   //         fontSize: 22,
//   //         color: Color(0xFF8E8E8E),
//   //         fontWeight: FontWeight.w400,
//   //       ),
//   //     ),
//   //   );
//   // } else {
//   //
//   // }
// }
}
