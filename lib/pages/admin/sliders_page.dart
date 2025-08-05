import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nurse_app/components/labeled_textfield.dart';
import 'package:nurse_app/components/labeled_textfield_admin.dart';
import 'package:nurse_app/components/textfield.dart';
import 'package:nurse_app/components/third_button.dart';
import 'package:nurse_app/features/home/cubit/home_cubit.dart';

import '../../components/button.dart';
import '../../components/loader.dart';
import '../../components/second_button.dart';
import '../../consts.dart';
import '../../main.dart';
import '../../services/user_token.dart';

class SlidersPage extends StatefulWidget {
  const SlidersPage({super.key});

  @override
  State<SlidersPage> createState() => _SlidersPageState();
}

class _SlidersPageState extends State<SlidersPage> {
  final _homeCubitBtn = HomeCubit();

  Future<void> addSlider(int position) async {
    final titleController = TextEditingController();
    final subtitle = TextEditingController();
    File? pickedImage;

    // show bottom sheet to input information
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return SafeArea(
              child: Padding(
                padding: MediaQuery.of(context).viewInsets,
                child: ListView(
                  padding: const EdgeInsets.all(16.0),
                  shrinkWrap: true,
                  children: [
                    LabeledTextFieldAdmin(
                      controller: titleController,
                      label: 'Title',
                    ),
                    const SizedBox(height: 8),
                    LabeledTextFieldAdmin(
                      controller: subtitle,
                      label: 'Subtitle',
                    ),
                    if (pickedImage != null) ...[
                      const SizedBox(height: 16),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.file(
                          pickedImage!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    if (pickedImage == null)
                      MySecondButton(
                        onTap: () async {
                          final image = await ImagePicker().pickImage(
                            source: ImageSource.gallery,
                          );

                          if (image == null) return;

                          CroppedFile? croppedImage =
                              await ImageCropper().cropImage(
                            sourcePath: image.path,
                            aspectRatio:
                                const CropAspectRatio(ratioX: 16, ratioY: 9),
                          );

                          if (croppedImage == null) return;

                          setState(() {
                            pickedImage = File(croppedImage.path);
                          });
                        },
                        buttonText: 'Upload Image',
                      )
                    else
                      MySecondButton(
                        onTap: () async {},
                        buttonText: 'Add Slider',
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
    return;

    final imagePicker = ImagePicker();

    final pickedFile = await imagePicker.pickImage(
      source: ImageSource.gallery,
    );

    final formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(
        pickedFile!.path,
        filename: pickedFile.name,
      ),
      'title': 'Test Popup',
      'content': 'This is a test popup content.',
      'type': 'info',
    });

    final token = await UserToken.getToken();

    try {
      final response = await dio.post(
        '$HOST/admin/popups',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      logger.i('Popup created: ${response.data}');
    } on DioException catch (e) {
      logger.e(e.response?.statusCode);
      logger.e('Failed to create popup: ${e.response?.data}');
    } catch (e) {
      logger.e('Error creating popup: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sliders'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              _buildSliders(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSliders() {
    final getSliders = HomeCubit();

    int dotIndex = 0;

    return BlocBuilder<HomeCubit, HomeState>(
      bloc: getSliders..getSliders(),
      builder: (context, state) {
        if (state is GetSlidersLoading) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Loader(),
          );
        }

        if (state is GetSlidersFailure) {
          return Center(
            child: Text(
              state.message,
            ),
          );
        }

        if (state is GetSlidersSuccess) {
          final items = state.sliders.sliders;

          return Column(
            children: [
              if (items.isEmpty)
                const SizedBox.shrink()
              else ...[
                ExpandableCarousel(
                  items: [
                    for (var item in items)
                      CachedNetworkImage(
                        imageUrl: item.image!,
                        imageBuilder: (context, imageProvider) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                      ),
                  ],
                  options: ExpandableCarouselOptions(
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 5),
                    enlargeCenterPage: true,
                    enableInfiniteScroll: true,
                    pauseAutoPlayOnTouch: true,
                    showIndicator: false,
                    onPageChanged: (index, reason) {
                      setState(() {
                        dotIndex = index;
                      });
                    },
                  ),
                ),
                Center(
                  child: DotsIndicator(
                    dotsCount: items.length,
                    position: dotIndex.toDouble(),
                    decorator: const DotsDecorator(
                      activeColor: Color(0xFF7BB442),
                      color: Color.fromRGBO(217, 217, 217, 1),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              BlocConsumer<HomeCubit, HomeState>(
                bloc: _homeCubitBtn,
                listener: (context, state) {
                  // TODO: implement listener
                },
                builder: (context, state) {
                  return MyButton(
                    onTap: () {
                      final lastPosition = items.isEmpty ? 0 : items.length;

                      addSlider(lastPosition);
                    },
                    buttonText: 'Add Slider',
                  );
                },
              ),
            ],
          );
        }

        return const Center(child: Text('Failed to get images.'));
      },
    );
  }
}
