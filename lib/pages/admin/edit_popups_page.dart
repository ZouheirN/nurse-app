import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nurse_app/components/labeled_textfield_admin.dart';
import 'package:nurse_app/components/loader.dart';
import 'package:nurse_app/components/textfield.dart';
import 'package:nurse_app/features/home/cubit/home_cubit.dart';

import '../../components/second_button.dart';
import '../../utilities/dialogs.dart';

class EditPopupsPage extends StatefulWidget {
  const EditPopupsPage({super.key});

  @override
  State<EditPopupsPage> createState() => _EditPopupsPageState();
}

class _EditPopupsPageState extends State<EditPopupsPage> {
  final _homeCubit = HomeCubit();

  @override
  void initState() {
    _homeCubit.getPopupsAdmin();
    super.initState();
  }

  void _showAddPopupDialog() {
    final popupsCubit = HomeCubit();

    final titleController = TextEditingController();
    final contentController = TextEditingController();

    final types = ['Info', 'Warning', 'Promo'];
    String selectedType = types[0];

    File? selectedImage;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Popup'),
          content: StatefulBuilder(builder: (context, setState) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  LabeledTextFieldAdmin(
                    label: 'Title',
                    controller: titleController,
                    hasPadding: false,
                  ),
                  LabeledTextFieldAdmin(
                    label: 'Content',
                    controller: contentController,
                    hasPadding: false,
                  ),
                  const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Type',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500))),
                  DropdownButtonFormField(
                    decoration: InputDecoration(
                      hintText: 'Type',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(color: Color(0xFF7BB442)),
                      ),
                      disabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(color: Color(0xFF7BB442)),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(color: Color(0xFF7BB442)),
                      ),
                      errorBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      focusedErrorBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      fillColor: const Color(0xFFE8FFD1),
                      filled: true,
                    ),
                    items: types
                        .map(
                          (type) => DropdownMenuItem(
                            value: type,
                            child: Text(type),
                          ),
                        )
                        .toList(),
                    value: selectedType,
                    onChanged: (value) {
                      setState(() {
                        selectedType = value!;
                      });
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        final pickedImage = await ImagePicker()
                            .pickImage(source: ImageSource.gallery);

                        if (pickedImage == null) return;

                        CroppedFile? croppedImage =
                            await ImageCropper().cropImage(
                          sourcePath: pickedImage.path,
                          aspectRatio:
                              const CropAspectRatio(ratioX: 1, ratioY: 1),
                        );

                        if (croppedImage == null) return;

                        setState(() {
                          selectedImage = File(croppedImage.path);
                        });
                      },
                      child: Text(
                        selectedImage == null
                            ? 'Select Image (Optional)'
                            : 'Change Selected Image',
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          actions: [
            BlocConsumer<HomeCubit, HomeState>(
              bloc: popupsCubit,
              listener: (context, state) {
                if (state is AddPopupSuccess) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Popup added successfully!'),
                    ),
                  );
                  _homeCubit.getPopups();
                } else if (state is AddPopupFailure) {
                  Dialogs.showErrorDialog(
                    context,
                    "Error",
                    state.message,
                  );
                }
              },
              builder: (context, state) {
                final isLoading = state is AddPopupLoading;

                return MySecondButton(
                  isLoading: isLoading,
                  onTap: () async {
                    popupsCubit.addPopup(
                      pickedFile: selectedImage != null
                          ? XFile(selectedImage!.path)
                          : null,
                      title: titleController.text,
                      content: contentController.text,
                      type: selectedType.toLowerCase(),
                    );
                  },
                  buttonText: 'Add Slider',
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Popups'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: BlocBuilder<HomeCubit, HomeState>(
          bloc: _homeCubit,
          builder: (context, state) {
            if (state is GetPopupsLoading) {
              return const Loader();
            } else if (state is GetPopupsFailure) {
              return Center(
                child: Text(state.message),
              );
            } else if (state is GetPopupsAdminSuccess) {
              final popups = state.popups.popups;

              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: popups.length,
                      itemBuilder: (context, index) {
                        final popup = popups[index];

                        bool isActive = popup.isActive ?? false;

                        HomeCubit itemHomeCubit = HomeCubit();

                        return StatefulBuilder(
                          builder: (context, setState) => Slidable(
                            key: ValueKey(popup.id),
                            endActionPane: ActionPane(
                              motion: const DrawerMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (context) {},
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  icon: Icons.delete,
                                  label: 'Delete',
                                  padding: EdgeInsets.zero,
                                ),
                              ],
                            ),
                            child: ListTile(
                              leading: CachedNetworkImage(
                                imageUrl: popup.image!,
                                progressIndicatorBuilder:
                                    (context, url, progress) =>
                                        const SizedBox.shrink(),
                                errorWidget: (context, url, error) =>
                                    const SizedBox.shrink(),
                              ),
                              title: Text(popup.title.toString()),
                              subtitle: Text(popup.content.toString()),
                              trailing: Switch(
                                value: isActive,
                                onChanged: (value) {
                                  itemHomeCubit.editPopup(
                                    id: popup.id.toString(),
                                    title: popup.title!,
                                    content: popup.content!,
                                    type: popup.type!,
                                    startDate: popup.startDate,
                                    endDate: popup.endDate,
                                    isActive: value,
                                  );

                                  setState(() {
                                    isActive = value;
                                  });
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton.icon(
                      onPressed: _showAddPopupDialog,
                      label: const Text('Add New Popup'),
                      icon: const Icon(Icons.add),
                    ),
                  ),
                ],
              );
            }

            return const Center(child: Text('An unexpected error occurred.'));
          },
        ),
      ),
    );
  }
}
