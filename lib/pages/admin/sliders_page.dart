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
import '../../components/home_screen_sliders.dart';
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
  final getSliders = HomeCubit();
  final slidersOrder = HomeCubit();

  Future<void> addSlider(int position) async {
    final titleController = TextEditingController();
    final subtitle = TextEditingController();
    File? pickedImage;

    final homeCubit = HomeCubit();

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
                      BlocConsumer<HomeCubit, HomeState>(
                        bloc: homeCubit,
                        listener: (context, state) {
                          if (state is AddSliderSuccess) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Slider added successfully!'),
                              ),
                            );
                            getSliders.getSliders();
                          } else if (state is AddSliderFailure) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(state.message),
                              ),
                            );
                          }
                        },
                        builder: (context, state) {
                          final isLoading = state is AddSliderLoading;

                          return MySecondButton(
                            isLoading: isLoading,
                            onTap: () async {
                              homeCubit.addSlider(
                                pickedFile: XFile(pickedImage!.path),
                                title: titleController.text,
                                subtitle: subtitle.text,
                                position: position,
                              );
                            },
                            buttonText: 'Add Slider',
                          );
                        },
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> deleteSlider(int id) async {
    final homeCubit = HomeCubit();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Slider'),
          content: const Text('Are you sure you want to delete this slider?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            BlocConsumer<HomeCubit, HomeState>(
              bloc: homeCubit,
              listener: (context, state) {
                if (state is DeleteSliderSuccess) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Slider deleted successfully!'),
                    ),
                  );
                  getSliders.getSliders();
                } else if (state is DeleteSliderFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                    ),
                  );
                }
              },
              builder: (context, state) {
                final isLoading = state is DeleteSliderLoading;

                return TextButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          homeCubit.deleteSlider(id);
                        },
                  child: isLoading
                      ? const Text('Deleting...')
                      : const Text('Delete'),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    getSliders.getSliders();
    super.initState();
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
    int dotIndex = 0;

    return BlocBuilder<HomeCubit, HomeState>(
      bloc: getSliders,
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
                BlocConsumer<HomeCubit, HomeState>(
                  bloc: slidersOrder,
                  listener: (context, state) {
                    if (state is ReorderSlidersSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Sliders reordered successfully!'),
                        ),
                      );
                      getSliders.getSliders();
                    } else if (state is ReorderSlidersFailure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.message),
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    final isLoading = state is ReorderSlidersLoading;

                    return Opacity(
                      opacity: isLoading ? 0.5 : 1.0,
                      child: IgnorePointer(
                        ignoring: isLoading,
                        child: ReorderableListView.builder(
                          itemCount: items.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            final item = items[index];

                            return ListTile(
                              key: ValueKey(item.id),
                              title: Text(item.title.toString()),
                              subtitle: Text(item.subtitle.toString()),
                              leading: Image.network(
                                item.image.toString(),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () {
                                      deleteSlider(item.id!);
                                    },
                                  ),
                                  Icon(Icons.reorder, color: Colors.grey[600]),
                                ],
                              ),
                            );
                          },
                          onReorder: (oldIndex, newIndex) {
                            final id = items[oldIndex].id!;
                            if (newIndex > oldIndex) {
                              newIndex -= 1;
                            }
                            slidersOrder.reorderSlider(id, newIndex);
                          },
                        ),
                      ),
                    );
                  },
                ),
              ],
              const SizedBox(height: 16),
              MyButton(
                onTap: () {
                  final lastPosition = items.isEmpty ? 0 : items.length;

                  addSlider(lastPosition);
                },
                buttonText: 'Add Slider',
              ),
              const SizedBox(height: 16),
              const Text('How it looks like on the app:'),
              const HomeScreenSliders(),
            ],
          );
        }

        return const Center(child: Text('Failed to get images.'));
      },
    );
  }
}
