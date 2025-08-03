import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nurse_app/components/textfield.dart';

import '../../components/labeled_textfield_admin.dart';
import '../../components/loader.dart';
import '../../features/areas/cubit/areas_cubit.dart';

class AreasPage extends StatefulWidget {
  const AreasPage({super.key});

  @override
  State<AreasPage> createState() => _AreasPageState();
}

class _AreasPageState extends State<AreasPage> {
  final _areasCubit = AreasCubit();

  @override
  void initState() {
    _areasCubit.getAreasAdmin();
    super.initState();
  }

  void _showAddAreaDialog({
    String? areaName,
    int? areaId,
  }) {
    final TextEditingController areaNameController = TextEditingController(
      text: areaName ?? '',
    );
    final areaCubit2 = AreasCubit();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Area'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LabeledTextFieldAdmin(
                label: 'Area Name',
                controller: areaNameController,
                hasPadding: false,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
            BlocConsumer<AreasCubit, AreasState>(
              bloc: areaCubit2,
              listener: (context, state) {
                if (state is AddAreaSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Area added successfully')),
                  );
                  areaNameController.clear();
                  _areasCubit.getAreasAdmin();
                  Navigator.of(context).pop();
                } else if (state is AddAreaFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: ${state.message}')),
                  );
                  Navigator.of(context).pop();
                } else if (state is EditAreaSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Area updated successfully')),
                  );
                  areaNameController.clear();
                  _areasCubit.getAreasAdmin();
                  Navigator.of(context).pop();
                } else if (state is EditAreaFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: ${state.message}')),
                  );
                  Navigator.of(context).pop();
                }
              },
              builder: (context, state) {
                final isAdding = state is AddAreaLoading;
                final isEditing = state is EditAreaLoading;

                return TextButton(
                  onPressed: isAdding || isEditing
                      ? null
                      : () {
                          if (areaNameController.text.isNotEmpty) {
                            if (areaName != null) {
                              // Edit existing area
                              areaCubit2.editArea(
                                areaNameController.text.trim(),
                                areaId!,
                              );
                            } else {
                              // Add new area
                              areaCubit2
                                  .addArea(areaNameController.text.trim());
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Area name cannot be empty')),
                            );
                          }
                        },
                  child: isAdding
                      ? const Text('Adding Area...')
                      : isEditing
                          ? const Text('Editing Area...')
                          : areaName != null
                              ? const Text('Edit Area')
                              : const Text('Add Area'),
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
        title: const Text('Areas'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<AreasCubit, AreasState>(
            bloc: _areasCubit,
            builder: (context, state) {
              if (state is GetAreasAdminLoading) {
                return const Loader();
              }

              if (state is GetAreasAdminFailure) {
                return Center(child: Text('Error: ${state.message}'));
              }

              if (state is GetAreasAdminSuccess) {
                final areas = state.areas.data;
                return Column(
                  children: [
                    if (areas.isEmpty)
                      const Expanded(
                          child: Center(child: Text('No areas available.')))
                    else
                      Expanded(
                        child: ListView.builder(
                          itemCount: areas.length,
                          itemBuilder: (context, index) {
                            final area = areas[index];

                            return ListTile(
                              title: Text(area.name.toString()),
                              subtitle: Text('Users: ${area.usersCount}'),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () {
                                      _showAddAreaDialog(
                                        areaName: area.name,
                                        areaId: area.id,
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () {
                                      // Handle delete area
                                      // _areasCubit.deleteArea(area.id!);
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ElevatedButton.icon(
                      onPressed: _showAddAreaDialog,
                      icon: const Icon(Icons.add),
                      label: const Text('Add New Area'),
                    ),
                  ],
                );
              }

              return const Center(child: Text('Failed to load areas.'));
            },
          ),
        ),
      ),
    );
  }
}
