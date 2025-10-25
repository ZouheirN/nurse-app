import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nurse_app/components/admin_header.dart';
import 'package:nurse_app/components/labeled_mini_textfield_admin.dart';
import 'package:nurse_app/components/labeled_textfield_admin.dart';
import 'package:nurse_app/components/loader.dart';
import 'package:nurse_app/components/pick_image.dart';
import 'package:nurse_app/components/third_button.dart';
import 'package:nurse_app/features/services/cubit/services_cubit.dart';

import '../../utilities/dialogs.dart';

class EditServicePage extends StatefulWidget {
  final int serviceId;

  const EditServicePage({super.key, required this.serviceId});

  @override
  State<EditServicePage> createState() => _EditServicePageState();
}

class _EditServicePageState extends State<EditServicePage> {
  String? image;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController discountPriceController = TextEditingController();
  String? selectedImage;

  final _servicesCubit = ServicesCubit();
  final _servicesCubitButton = ServicesCubit();

  @override
  void initState() {
    super.initState();
    _servicesCubit.fetchService(serviceId: widget.serviceId);
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    discountPriceController.dispose();
    super.dispose();
  }

  // Future<void> updateService() async {
  //   final token = await UserToken.getToken();
  //
  //   final double updatedPrice = double.tryParse(priceController.text) ?? 0.0;
  //   final String discountPriceText = discountPriceController.text;
  //
  //   final Map<String, dynamic> requestBody = {
  //     'name': nameController.text,
  //     'price': updatedPrice,
  //     if (discountPriceText.isNotEmpty)
  //       'discount_price': double.tryParse(discountPriceText) ?? 0.0
  //     else
  //       'discount_price': null,
  //   };
  //
  //   final response = await http.put(
  //     Uri.parse('${Consts.host}/admin/services/${widget.serviceId}'),
  //     headers: {
  //       'Authorization': 'Bearer $token',
  //       'Content-Type': 'application/json',
  //     },
  //     body: json.encode(requestBody),
  //   );
  //
  //   if (response.statusCode == 200) {
  //     QuickAlert.show(
  //       context: context,
  //       type: QuickAlertType.success,
  //       text: 'Service updated successfully.',
  //       onConfirmBtnTap: () {
  //         Navigator.of(context).pop();
  //         Navigator.of(context).pop();
  //       },
  //     );
  //   } else {
  //     final errorData = json.decode(response.body);
  //     final errorMessage = errorData['message'];
  //
  //     QuickAlert.show(
  //       context: context,
  //       type: QuickAlertType.error,
  //       text: errorMessage,
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AdminHeader(title: 'Edit Service'),
      body: BlocConsumer<ServicesCubit, ServicesState>(
        bloc: _servicesCubit,
        listener: (context, state) {
          if (state is ServicesFetchDetailsSuccess) {
            final service = state.service;

            nameController.text = service['name']!;
            priceController.text = service['price'].toString();
            discountPriceController.text = service['discount_price'] == null
                ? ''
                : service['discount_price'].toString();
            image = service['service_pic'];
          }
        },
        builder: (context, state) {
          if (state is ServicesFetchDetailsLoading) {
            return const Loader();
          }

          if (state is ServicesFetchDetailsSuccess) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 40),
                        LabeledTextFieldAdmin(
                          label: 'Service Name',
                          keyboardType: TextInputType.name,
                          controller: nameController,
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 35),
                          child: Row(
                            children: [
                              Expanded(
                                child: LabeledMiniTextfieldAdmin(
                                  label: 'Service Price',
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          decimal: true),
                                  controller: priceController,
                                ),
                              ),
                              Expanded(
                                child: LabeledMiniTextfieldAdmin(
                                  label: 'Sale Price',
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          decimal: true),
                                  controller: discountPriceController,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        PickImage(
                          label: 'Service Picture',
                          initialImageUrl: image,
                          onImageSelected: (imageUrl) {
                            setState(() {
                              selectedImage = imageUrl;
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        BlocConsumer<ServicesCubit, ServicesState>(
                          bloc: _servicesCubitButton,
                          listener: (context, state) {
                            if (state is ServicesEditSuccess) {
                              Dialogs.showSuccessDialog(
                                context,
                                'Success',
                                'Service updated successfully.',
                                onConfirmBtnTap: () {
                                  Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      '/manageServices',
                                      (route) => route.isFirst);
                                },
                              );
                            } else if (state is ServicesEditFailure) {
                              Dialogs.showErrorDialog(
                                context,
                                'Error',
                                state.message,
                              );
                            }
                          },
                          builder: (context, state) {
                            final isLoading = state is ServicesEditLoading;

                            return MyThirdButton(
                              isLoading: isLoading,
                              onTap: () {
                                final updatedPrice =
                                    double.tryParse(priceController.text) ??
                                        0.0;

                                double? updatedDiscountPrice;

                                if (discountPriceController.text.isNotEmpty) {
                                  updatedDiscountPrice = double.tryParse(
                                          discountPriceController.text) ??
                                      0.0;
                                }

                                _servicesCubitButton.editService(
                                  serviceId: widget.serviceId,
                                  name: nameController.text.trim(),
                                  price: updatedPrice,
                                  discountPrice: updatedDiscountPrice,
                                  image: selectedImage ?? image,
                                );
                              },
                              buttonText: 'Update Service',
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          return const Center(
            child: Text('Error fetching service details.'),
          );
        },
      ),
    );
  }
}
