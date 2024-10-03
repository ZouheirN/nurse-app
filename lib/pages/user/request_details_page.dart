import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nurse_app/components/loader.dart';
import 'package:nurse_app/components/star_rating.dart';
import 'package:nurse_app/components/text_data.dart';
import 'package:nurse_app/components/uneditable_labeled_date.dart';
import 'package:nurse_app/features/nurse/cubit/nurse_cubit.dart';
import 'package:nurse_app/features/request/cubit/request_cubit.dart';
import 'package:nurse_app/features/request/models/requests_history_model.dart';
import 'package:nurse_app/main.dart';
import 'package:nurse_app/utilities/helper_functions.dart';

import '../../components/service_card.dart';

class RequestDetailsPage extends StatelessWidget {
  final num requestId;

  RequestDetailsPage({super.key, required this.requestId});

  final _requestCubit = RequestCubit();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leadingWidth: 75,
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
        title: const Text(
          'Nurse Request',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: BlocBuilder<RequestCubit, RequestState>(
        bloc: _requestCubit..getOrder(orderId: requestId),
        builder: (context, state) {
          if (state is RequestDetailsLoading) {
            return const Loader();
          }

          if (state is RequestDetailsSuccess) {
            final request = state.request;

            logger.d(request.toJson());

            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  const Center(
                    child: Text(
                      'Request Details:',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (request.nurse != null && request.nurseId != null)
                    _buildNurseDetails(request.nurseId!),
                  if (request.services != null)
                    _buildServiceDetails(request.services!),
                  if (request.endingTime == null &&
                      request.timeNeededToArrive != null)
                    Column(
                      children: [
                        TextData(
                          label: 'Time to arrive: ',
                          data: Text(
                            '${request.timeNeededToArrive} minutes',
                            style: const TextStyle(
                              fontSize: 22,
                              color: Color(0xFF000000),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  if (request.nurse != null && request.nurseId != null)
                    Column(
                      children: [
                        StarRating(
                          nurseId: request.nurseId!,
                          initialRating: 0,
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  _buildRequestDate(request),
                  const SizedBox(height: 30),
                  const Center(
                    child: Image(
                      image: AssetImage('assets/images/logo.png'),
                      height: 110,
                      width: 220,
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
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

  Widget _buildNurseDetails(num nurseId) {
    return BlocBuilder<NurseCubit, NurseState>(
      bloc: NurseCubit()..fetchNurse(nurseId),
      builder: (context, state) {
        if (state is NurseDetailsFetchLoading) {
          return const Loader();
        }

        if (state is NurseDetailsFetchSuccess) {
          final nurse = state.nurse.nurse!;

          return Column(
            children: [
              if (nurse.profilePicture != null)
                Image.network(
                  nurse.profilePicture!,
                  height: 250,
                  fit: BoxFit.contain,
                )
              else
                Image.asset(
                  'assets/images/default_profile.png',
                  height: 250,
                  fit: BoxFit.contain,
                ),
              const SizedBox(height: 20),
              TextData(
                label: 'Nurse name: ',
                data: Text(
                  nurse.name ?? '',
                  style: const TextStyle(
                    fontSize: 22,
                    color: Color(0xFF000000),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          );
        }

        return const SizedBox();
      },
    );
  }

  Widget _buildServiceDetails(List<Service> services) {
    return Column(
      children: services.map((service) {
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          // decoration: BoxDecoration(
          //   color: Colors.white,
          //   borderRadius: BorderRadius.circular(10),
          //   border: Border.all(
          //     color: const Color.fromARGB(255, 221, 221, 221),
          //     width: 1,
          //   ),
          // ),
          child: Column(
            children: [
              TextData(
                label: 'Service: ',
                data: Text(
                  service.name ?? '',
                  style: const TextStyle(
                    fontSize: 22,
                    color: Color(0xFF000000),
                    fontWeight: FontWeight.w400,
                  ),
                  overflow: TextOverflow.visible,
                ),
              ),
              const SizedBox(height: 10),
              TextData(
                label: 'Service Price: ',
                data: Row(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Text(
                          '\$${formatPrice(service.price!)}',
                          style: TextStyle(
                            color: service.discountPrice != null
                                ? Colors.grey
                                : Colors.black,
                            fontSize: 22,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        if (service.discountPrice != null)
                          Positioned.fill(
                            child: CustomPaint(
                              painter: DiagonalLinePainter(),
                            ),
                          ),
                      ],
                    ),
                    if (service.discountPrice != null) ...[
                      const SizedBox(width: 5),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          '\$${formatPrice(service.discountPrice!)}',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildRequestDate(request) {
    if (request.endingTime == null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Text(
          'Request Date: ${formateDateTimeForRequestDetails(request.createdAt!)}',
          style: const TextStyle(
            fontSize: 22,
            color: Color(0xFF8E8E8E),
            fontWeight: FontWeight.w400,
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFE7E7E7),
            border: Border.all(
              color: const Color(0xFFE7E7E7),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            children: [
              UneditableLabeledDate(
                label: 'Start Date',
                date: request.scheduledTime!,
              ),
              const SizedBox(height: 7),
              UneditableLabeledDate(
                label: 'End Date',
                date: request.endingTime!,
              ),
            ],
          ),
        ),
      );
    }
  }
}
