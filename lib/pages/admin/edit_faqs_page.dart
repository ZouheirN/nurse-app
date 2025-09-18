import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:nurse_app/components/loader.dart';
import 'package:nurse_app/features/home/cubit/home_cubit.dart';

import '../../components/labeled_textfield_admin.dart';

class EditFaqsPage extends StatefulWidget {
  const EditFaqsPage({super.key});

  @override
  State<EditFaqsPage> createState() => _EditFaqsPageState();
}

class _EditFaqsPageState extends State<EditFaqsPage> {
  final _faqsCubit = HomeCubit();
  final _faqsCubitBtn = HomeCubit();
  final _faqsCubitDelete = HomeCubit();

  @override
  void initState() {
    _faqsCubit.getFaqs(isAdmin: true);
    super.initState();
  }

  _showAddFaqDialog(int order) {
    showDialog(
      context: context,
      builder: (context) {
        String question = '';
        String answer = '';

        return AlertDialog(
          title: const Text('Add FAQ'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LabeledTextFieldAdmin(
                hasPadding: false,
                label: 'Question',
                onChanged: (value) {
                  question = value;
                },
                keyboardType: TextInputType.text,
              ),
              LabeledTextFieldAdmin(
                hasPadding: false,
                label: 'Answer',
                onChanged: (value) {
                  answer = value;
                },
                keyboardType: TextInputType.text,
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
              bloc: _faqsCubitBtn,
              listener: (context, state) {
                if (state is AddFaqSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('FAQ added successfully')),
                  );
                  _faqsCubit.getFaqs(isAdmin: true);
                  Navigator.of(context).pop();
                } else if (state is AddFaqFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: ${state.message}')),
                  );
                  Navigator.of(context).pop();
                }
              },
              builder: (context, state) {
                final isLoading = state is AddFaqLoading;

                return ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          _faqsCubitBtn.addFaq(
                            question: question,
                            answer: answer,
                            order: order,
                          );
                        },
                  child: Text(isLoading ? 'Adding...' : 'Add'),
                );
              },
            ),
          ],
        );
      },
    );
  }

  _showEditFaqDialog(
    int id,
    String question,
    String answer,
    int order,
    bool isActive,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController questionController =
            TextEditingController(text: question);
        TextEditingController answerController =
            TextEditingController(text: answer);

        ValueNotifier<bool> isActiveNotifier = ValueNotifier(isActive);

        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Edit FAQ'),
              ValueListenableBuilder(
                valueListenable: isActiveNotifier,
                builder: (context, newIsActive, _) {
                  return InkWell(
                    onTap: () {
                      isActiveNotifier.value = !isActiveNotifier.value;
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: newIsActive ? Colors.green : Colors.red,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        newIsActive ? 'Active' : 'Inactive',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LabeledTextFieldAdmin(
                controller: questionController,
                hasPadding: false,
                label: 'Question',
                keyboardType: TextInputType.text,
              ),
              LabeledTextFieldAdmin(
                controller: answerController,
                hasPadding: false,
                label: 'Answer',
                keyboardType: TextInputType.text,
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
              bloc: _faqsCubitBtn,
              listener: (context, state) {
                if (state is EditFaqSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('FAQ updated successfully')),
                  );
                  _faqsCubit.getFaqs(isAdmin: true);
                  Navigator.of(context).pop();
                } else if (state is EditFaqFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: ${state.message}')),
                  );
                  Navigator.of(context).pop();
                }
              },
              builder: (context, state) {
                final isLoading = state is EditFaqLoading;

                return ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          _faqsCubitBtn.editFaq(
                            id: id,
                            question: questionController.text,
                            answer: answerController.text,
                            isActive: isActiveNotifier.value,
                            order: order,
                          );
                        },
                  child: Text(
                    isLoading ? 'Saving...' : 'Save',
                  ),
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
        title: const Text('Edit FAQs'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: BlocBuilder<HomeCubit, HomeState>(
          bloc: _faqsCubit,
          builder: (context, state) {
            if (state is GetFaqsLoading) {
              return const Loader();
            } else if (state is GetFaqsFailure) {
              return Center(child: Text(state.message));
            } else if (state is GetFaqsSuccess) {
              final faqs = state.faqs;

              // if (faqs.data.isEmpty) {
              //   return Column(
              //     children: [
              //       const Expanded(
              //           child: Center(child: Text('No FAQs available.'))),
              //       ElevatedButton.icon(
              //         onPressed: () => _showAddFaqDialog(1),
              //         label: const Text('Add FAQ'),
              //         icon: const Icon(Icons.add),
              //       ),
              //     ],
              //   );
              // }

              return Column(
                children: [
                  Expanded(
                    child: ReorderableListView(
                      onReorder: (int oldIndex, int newIndex) {
                        // get list of all index after reorder
                        if (newIndex > oldIndex) {
                          newIndex -= 1;
                        }
                        final item = faqs.data.removeAt(oldIndex);
                        faqs.data.insert(newIndex, item);
                        setState(() {});

                        // Get list of ids in new order
                        final newOrder =
                            faqs.data.map((faq) => faq.id!).toList();

                        HomeCubit().reorderFaq(newOrder);
                      },
                      children: [
                        for (final faq in faqs.data)
                          BlocListener<HomeCubit, HomeState>(
                            key: ValueKey('listener_${faq.id}'),
                            bloc: _faqsCubitDelete,
                            listener: (context, state) {
                              if (state is DeleteFaqSuccess) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text('FAQ deleted successfully')),
                                );
                                _faqsCubit.getFaqs(isAdmin: true);
                              } else if (state is DeleteFaqFailure) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text('Error: ${state.message}')),
                                );
                              }
                            },
                            child: Slidable(
                              key: ValueKey(faq.id),
                              endActionPane: ActionPane(
                                motion: const DrawerMotion(),
                                children: [
                                  SlidableAction(
                                    onPressed: (context) {
                                      _faqsCubitDelete.deleteFaq(faq.id!);
                                    },
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                    icon: Icons.delete,
                                    label: 'Delete',
                                    padding: EdgeInsets.zero,
                                  ),
                                ],
                              ),
                              child: ListTile(
                                onTap: () => _showEditFaqDialog(
                                  faq.id!,
                                  faq.question.toString(),
                                  faq.answer.toString(),
                                  faq.order!.toInt(),
                                  faq.isActive ?? true,
                                ),
                                key: ValueKey(faq.id),
                                title: Text(faq.question.toString()),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      faq.answer.toString(),
                                      textAlign: TextAlign.left,
                                    ),
                                    const SizedBox(height: 4),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: faq.isActive == true
                                              ? Colors.green
                                              : Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          faq.isActive == true
                                              ? 'Active'
                                              : 'Inactive',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: const Icon(Icons.drag_handle),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _showAddFaqDialog(faqs.data.length + 1),
                    label: const Text('Add FAQ'),
                    icon: const Icon(Icons.add),
                  ),
                ],
              );
            }

            return const Center(child: Text('An error occurred.'));
          },
        ),
      ),
    );
  }
}
