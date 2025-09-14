import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nurse_app/components/labeled_textfield_admin.dart';
import 'package:nurse_app/components/loader.dart';
import 'package:nurse_app/features/home/cubit/home_cubit.dart';

class ManageCategoriesPage extends StatefulWidget {
  const ManageCategoriesPage({super.key});

  @override
  State<ManageCategoriesPage> createState() => _ManageCategoriesPageState();
}

class _ManageCategoriesPageState extends State<ManageCategoriesPage> {
  final _categoriesCubit = HomeCubit();
  final _categoriesCubitBtn = HomeCubit();

  @override
  initState() {
    _categoriesCubit.getCategories();
    super.initState();
  }

  _showAddCategoryDialog() {
    showDialog(
      context: context,
      builder: (context) {
        final selectedImage = ValueNotifier<File?>(null);
        TextEditingController categoryNameController = TextEditingController();

        return AlertDialog(
          title: const Text('Add New Category'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LabeledTextFieldAdmin(
                label: 'Category Name',
                controller: categoryNameController,
                hasPadding: false,
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 10),
              ValueListenableBuilder(
                valueListenable: selectedImage,
                builder: (context, value, child) {
                  return ElevatedButton.icon(
                    onPressed: () async {
                      final pickedImage = await ImagePicker()
                          .pickImage(source: ImageSource.gallery);

                      if (pickedImage == null) return;

                      selectedImage.value = File(pickedImage.path);
                    },
                    icon: const Icon(Icons.image),
                    label: value != null
                        ? const Text('Image Selected')
                        : const Text('Select Image'),
                  );
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            BlocConsumer<HomeCubit, HomeState>(
              bloc: _categoriesCubitBtn,
              listener: (context, state) {
                if (state is AddCategorySuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Category added successfully!')),
                  );
                  categoryNameController.clear();
                  selectedImage.value = null;
                  _categoriesCubit.getCategories();
                  Navigator.of(context).pop();
                } else if (state is AddCategoryFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: ${state.message}')),
                  );
                  Navigator.of(context).pop();
                }
              },
              builder: (context, state) {
                final isLoading = state is AddCategoryLoading;

                return ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          final name = categoryNameController.text.trim();
                          final imageFile = selectedImage.value;

                          if (name.isEmpty || imageFile == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Please provide both name and image.'),
                              ),
                            );
                            return;
                          }

                          _categoriesCubitBtn.addCategory(
                            name: name,
                            imageFile: imageFile,
                          );
                        },
                  child: Text(isLoading ? 'Adding...' : 'Add Category'),
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
        title: const Text('Manage Categories'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: BlocBuilder<HomeCubit, HomeState>(
          bloc: _categoriesCubit,
          builder: (context, state) {
            if (state is GetCategoriesLoading) {
              return const Loader();
            } else if (state is GetCategoriesFailure) {
              return Center(child: Text(state.message));
            } else if (state is GetCategoriesSuccess) {
              final categories = state.categories.categories;
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        return ListTile(
                          title: Text(category.name.toString()),
                          subtitle: Text('ID: ${category.id}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              // Implement delete functionality
                            },
                          ),
                          leading: category.imageUrl == null
                              ? const Icon(Icons.image_not_supported)
                              : CachedNetworkImage(
                                  imageUrl: category.imageUrl.toString(),
                                ),
                        );
                      },
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      _showAddCategoryDialog();
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add Category'),
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
