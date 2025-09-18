import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:nurse_app/components/loader.dart';
import 'package:nurse_app/features/home/cubit/home_cubit.dart';

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
                      onPressed: () {
                        // Handle save changes logic here
                      },
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
