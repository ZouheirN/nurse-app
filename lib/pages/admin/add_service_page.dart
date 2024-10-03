import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nurse_app/components/admin_header.dart';
import 'package:nurse_app/components/labeled_mini_textfield_admin.dart';
import 'package:nurse_app/components/labeled_textfield_admin.dart';
import 'package:nurse_app/components/pick_image.dart';
import 'package:nurse_app/components/third_button.dart';
import 'package:nurse_app/features/services/cubit/services_cubit.dart';
import 'package:quickalert/quickalert.dart';

import '../../utilities/dialogs.dart';

class AddServicePage extends StatefulWidget {
  const AddServicePage({super.key});

  @override
  State<AddServicePage> createState() => _AddServicePageState();
}

class _AddServicePageState extends State<AddServicePage> {
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final discountPriceController = TextEditingController();
  String? _serviceImageUrl;

  final _servicesCubit = ServicesCubit();

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    discountPriceController.dispose();
    super.dispose();
  }

  // void createService(String serviceName, double price, double discountPrice,
  //     String? imageUrl, BuildContext context) async {
  //   if (!_validateInputs()) return;
  //
  //   setState(() {
  //     _isSubmitting = true;
  //   });
  //
  //   try {
  //     final token = await UserToken.getToken();
  //
  //     final Map<String, dynamic> requestBody = {
  //       'name': serviceName,
  //       'price': price,
  //       'service_pic': imageUrl ?? '',
  //     };
  //
  //     if (discountPrice != 0) {
  //       requestBody['discount_price'] = discountPrice;
  //     }
  //
  //     final response = await http.post(
  //       Uri.parse('$HOST/admin/services'),
  //       headers: {
  //         'Authorization': 'Bearer $token',
  //         'Content-Type': 'application/json',
  //       },
  //       body: jsonEncode(requestBody),
  //     );
  //
  //     setState(() {
  //       _isSubmitting = false;
  //     });
  //
  //     if (response.statusCode == 201) {
  //       QuickAlert.show(
  //         context: context,
  //         type: QuickAlertType.success,
  //         text: 'Service created successfully',
  //         onConfirmBtnTap: () {
  //           Navigator.of(context).pop();
  //           Navigator.of(context).pop();
  //         },
  //       );
  //     } else {
  //       final errorData = json.decode(response.body);
  //       final errorMessage = errorData['message'];
  //
  //       QuickAlert.show(
  //         context: context,
  //         type: QuickAlertType.error,
  //         text: errorMessage,
  //       );
  //     }
  //   } catch (e) {
  //     setState(() {
  //       _isSubmitting = false;
  //     });
  //     QuickAlert.show(
  //       context: context,
  //       type: QuickAlertType.error,
  //       text: 'An error occurred, please try again later.',
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AdminHeader(title: 'Add New Service'),
      body: SingleChildScrollView(
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
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            controller: priceController,
                          ),
                        ),
                        Expanded(
                          child: LabeledMiniTextfieldAdmin(
                            label: 'Sale Price',
                            keyboardType: const TextInputType.numberWithOptions(
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
                    onImageSelected: (imageUrl) {
                      setState(() {
                        _serviceImageUrl = imageUrl;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  BlocConsumer<ServicesCubit, ServicesState>(
                    bloc: _servicesCubit,
                    listener: (context, state) {
                      if (state is ServiceAddSuccess) {
                        Dialogs.showSuccessDialog(
                          context,
                          'Success',
                          'Service created successfully',
                          onConfirmBtnTap: () {
                            Navigator.pushNamedAndRemoveUntil(context,
                                '/manageServices', (route) => route.isFirst);
                          },
                        );
                      } else if (state is ServiceAddFailure) {
                        Dialogs.showErrorDialog(
                          context,
                          'Error',
                          state.message,
                        );
                      }
                    },
                    builder: (context, state) {
                      final isLoading = state is ServiceAddLoading;

                      return MyThirdButton(
                        isLoading: isLoading,
                        onTap: () {
                          final double price =
                              double.tryParse(priceController.text) ?? 0.0;
                          final double? discountPrice =
                              double.tryParse(discountPriceController.text);

                          if (nameController.text.isEmpty ||
                              priceController.text.isEmpty) {
                            QuickAlert.show(
                              context: context,
                              type: QuickAlertType.error,
                              text: 'Service name and price are required.',
                            );
                            return false;
                          }

                          _servicesCubit.addService(
                            name: nameController.text,
                            price: price,
                            discountPrice: discountPrice,
                            image: _serviceImageUrl,
                          );
                        },
                        buttonText: 'Add Service',
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
