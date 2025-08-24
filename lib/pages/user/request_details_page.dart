import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nurse_app/components/loader.dart';
import 'package:nurse_app/components/star_rating.dart';
import 'package:nurse_app/components/text_data.dart';
import 'package:nurse_app/components/uneditable_labeled_date.dart';
import 'package:nurse_app/extensions/context_extension.dart';
import 'package:nurse_app/features/nurse/cubit/nurse_cubit.dart';
import 'package:nurse_app/features/request/cubit/request_cubit.dart';
import 'package:nurse_app/utilities/helper_functions.dart';
import 'package:cached_network_image_platform_interface/cached_network_image_platform_interface.dart';

import '../../components/service_card.dart';
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
      body: BlocBuilder<RequestCubit, RequestState>(
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
                        const Text(
                          'Critical Care Service',
                          style: TextStyle(
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
                              '\$${formatPrice(20)}',
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
                          '${request.timeNeededToArrive.toStringAsFixed(0)} mins',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.italic,
                          ),
                        )
                      ],
                    ),
                    const Row(
                      children: [
                        Text(
                          'Rating: ',
                          style: TextStyle(
                            fontSize: 22,
                            color: Color.fromRGBO(122, 179, 65, 1.0),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        StarRating(
                          nurseId: 1, // todo Replace with actual nurse ID
                          initialRating: 4,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Request Date: ${formateDateTimeForRequestDetails(request.createdAt!)}',
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
                      colorFilter:
                          ColorFilter.mode(Colors.black, BlendMode.srcATop),
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

          return const Center(
            child: Text('Failed to load request details'),
          );
        },
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
//   //       'Request Date: ${formateDateTimeForRequestDetails(request.createdAt!)}',
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
