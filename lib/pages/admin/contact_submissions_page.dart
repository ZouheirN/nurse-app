import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nurse_app/components/third_button.dart';
import 'package:nurse_app/features/about_us/cubit/about_us_cubit.dart';
import 'package:nurse_app/features/about_us/models/get_contact_forms_model.dart';

import '../../components/loader.dart';

class ContactSubmissionsPage extends StatefulWidget {
  const ContactSubmissionsPage({super.key});

  @override
  State<ContactSubmissionsPage> createState() => _ContactSubmissionsPageState();
}

class _ContactSubmissionsPageState extends State<ContactSubmissionsPage> {
  final _contactFormsCubit = AboutUsCubit();

  @override
  void initState() {
    _contactFormsCubit.getContactForms();
    super.initState();
  }

  void showBottomSheet(Datum contactForm) {
    final contactFormsCubit2 = AboutUsCubit();

    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            shrinkWrap: true,
            children: [
              ListTile(
                title: const Text('Full Name'),
                subtitle: Text(contactForm.fullName ?? ''),
              ),
              ListTile(
                title: const Text('Address'),
                subtitle: Text(contactForm.address ?? ''),
              ),
              ListTile(
                title: const Text('Phone Number'),
                subtitle: Text(contactForm.phoneNumber ?? ''),
              ),
              ListTile(
                title: const Text('Description'),
                subtitle: Text(contactForm.description?.toString() ?? ''),
              ),
              BlocConsumer<AboutUsCubit, AboutUsState>(
                bloc: contactFormsCubit2,
                listener: (context, state) {
                  if (state is DeleteContactFormFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: ${state.message}')),
                    );
                  } else if (state is DeleteContactFormSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Contact form deleted successfully')),
                    );
                    Navigator.pop(context);
                    _contactFormsCubit.getContactForms();
                  }
                },
                builder: (context, state) {
                  final isLoading = state is DeleteContactFormLoading;

                  return MyThirdButton(
                    isLoading: isLoading,
                    onTap: () {
                      contactFormsCubit2.deleteContactForm(contactForm.id!);
                    },
                    buttonText: 'Delete',
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Submissions'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<AboutUsCubit, AboutUsState>(
            bloc: _contactFormsCubit,
            builder: (context, state) {
              if (state is GetContactFormsLoading) {
                return const Loader();
              }

              if (state is GetContactFormsFailure) {
                return Center(child: Text('Error: ${state.message}'));
              }

              if (state is GetContactFormsSuccess) {
                final contactForms = state.contactForms.data;

                if (contactForms.isEmpty) {
                  return const Center(child: Text('No contact submissions found.'));
                }

                return ListView.builder(
                  itemCount: contactForms.length,
                  itemBuilder: (context, index) {
                    final contactForm = contactForms[index];

                    return ListTile(
                      title: Text('${contactForm.fullName}'),
                      subtitle: Text('${contactForm.description}'),
                      onTap: () => showBottomSheet(contactForm),
                    );
                  },
                );
              }

              return const Center(
                  child: Text('Failed to load contact submissions.'));
            },
          ),
        ),
      ),
    );
  }
}
