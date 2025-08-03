import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nurse_app/components/button.dart';
import 'package:nurse_app/components/loader.dart';
import 'package:nurse_app/components/phone_number_field.dart';
import 'package:nurse_app/components/textfield.dart';
import 'package:nurse_app/features/areas/cubit/areas_cubit.dart';
import 'package:nurse_app/utilities/dialogs.dart';

import '../../features/authentication/cubit/authentication_cubit.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmationController = TextEditingController();
  final dobController = TextEditingController();
  String completeNumber = '';

  int? selectedAreaId;

  final _formKey = GlobalKey<FormState>();

  final _authenticationCubit = AuthenticationCubit();

  final _areasCubit = AreasCubit();

  @override
  void initState() {
    _areasCubit.getAreas();
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    passwordController.dispose();
    passwordConfirmationController.dispose();
    dobController.dispose();
    super.dispose();
  }

  void signup() async {
    FocusManager.instance.primaryFocus?.unfocus();

    if (_formKey.currentState!.validate()) {
      _authenticationCubit.signUp(
        phoneNumber: completeNumber.trim(),
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text,
        passwordConfirmation: passwordConfirmationController.text,
        dateOfBirth: dobController.text.trim(),
        areaId: selectedAreaId!,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/header_background.png'),
                fit: BoxFit.cover,
                opacity: 0.32,
                colorFilter: ColorFilter.mode(
                  Colors.transparent,
                  BlendMode.hardLight,
                ),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 50),
                    const Center(
                      child: ColorFiltered(
                        colorFilter: ColorFilter.mode(
                          Colors.black,
                          BlendMode.srcIn,
                        ),
                        child: Image(
                          image: AssetImage('assets/images/square_logo.png'),
                          height: 150,
                          width: 300,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 27),
                      child: Text(
                        'Register',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 40,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 27),
                      child: Text(
                        'Please register to login',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    MyTextField(
                      controller: nameController,
                      icon: const Icon(Icons.person_outlined),
                      hintText: 'Username',
                      inputType: TextInputType.name,
                      obscureText: false,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your username';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),
                    PhoneNumberField(
                      controller: phoneNumberController,
                      padding: const EdgeInsets.symmetric(horizontal: 27),
                      showLabel: false,
                      showHintText: true,
                      fillColor: const Color(0xFFE8FFD1),
                      outlineColor: const Color(0xFF7BB442),
                      setCompleteNumber: (number) {
                        completeNumber = number;
                      },
                    ),
                    const SizedBox(height: 14),
                    GestureDetector(
                      onTap: () {
                        showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        ).then((selectedDate) {
                          if (selectedDate != null) {
                            dobController.text =
                                selectedDate.toLocal().toString().split(' ')[0];
                          }
                        });
                      },
                      child: MyTextField(
                        controller: dobController,
                        icon: const Icon(Icons.calendar_today_outlined),
                        hintText: 'Date of Birth',
                        inputType: TextInputType.datetime,
                        enabled: false,
                        obscureText: false,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your date of birth';
                          }

                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 14),
                    BlocBuilder<AreasCubit, AreasState>(
                      bloc: _areasCubit,
                      builder: (context, state) {
                        if (state is GetAreasLoading) {
                          return const Loader();
                        }

                        if (state is GetAreasFailure) {
                          return Text(
                            'Failed to load areas: ${state.message}',
                            style: const TextStyle(color: Colors.red),
                          );
                        }

                        if (state is GetAreasSuccess) {
                          final areas = state.areas.areas;

                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 27),
                            child: DropdownButtonFormField<int>(
                              decoration: InputDecoration(
                                labelText: 'Select Area',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  borderSide:
                                      BorderSide(color: Color(0xFF7BB442)),
                                ),
                                disabledBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  borderSide:
                                      BorderSide(color: Color(0xFF7BB442)),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  borderSide:
                                      BorderSide(color: Color(0xFF7BB442)),
                                ),
                                errorBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(color: Colors.red),
                                ),
                                focusedErrorBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(color: Colors.red),
                                ),
                                fillColor: const Color(0xFFE8FFD1),
                                filled: true,
                              ),
                              items: areas.map((area) {
                                return DropdownMenuItem<int>(
                                  value: area.id,
                                  child: Text(area.name.toString()),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedAreaId = value;
                                });
                              },
                              validator: (value) {
                                if (value == null) {
                                  return 'Please select an area';
                                }
                                return null;
                              },
                            ),
                          );
                        }

                        return const Text(
                          'No areas available',
                          style: TextStyle(color: Colors.red),
                        );
                      },
                    ),
                    const SizedBox(height: 14),
                    MyTextField(
                      controller: emailController,
                      icon: const Icon(Icons.mail_outline),
                      hintText: 'Email',
                      inputType: TextInputType.emailAddress,
                      obscureText: false,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }

                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                            .hasMatch(value)) {
                          return 'Please enter a valid email';
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 14),
                    MyTextField(
                      controller: passwordController,
                      icon: const Icon(Icons.lock_outline),
                      hintText: 'Password',
                      inputType: TextInputType.text,
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),
                    MyTextField(
                      controller: passwordConfirmationController,
                      icon: const Icon(Icons.lock_outline),
                      hintText: 'Confirm Password',
                      inputType: TextInputType.text,
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }

                        if (value != passwordController.text) {
                          return 'Passwords do not match';
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    BlocConsumer<AuthenticationCubit, AuthenticationState>(
                      bloc: _authenticationCubit,
                      listener: (context, state) {
                        if (state is AuthenticationSignUpSuccess) {
                          final phoneNumber = state.phoneNumber;
                          Navigator.pushNamed(
                            context,
                            '/verifySms',
                            arguments: {
                              'phoneNumber': phoneNumber,
                              'resend': false,
                            },
                          );
                        } else if (state is AuthenticationSignUpFailure) {
                          Dialogs.showErrorDialog(
                            context,
                            'Sign Up Failed',
                            state.message,
                          );
                        }
                      },
                      builder: (context, state) {
                        final isLoading = state is AuthenticationSignUpLoading;

                        return MyButton(
                          isLoading: isLoading,
                          onTap: () {
                            signup();
                          },
                          buttonText: 'Register',
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Already have account?',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 4),
                        InkWell(
                          onTap: () {
                            Navigator.pushReplacementNamed(context, '/login');
                          },
                          child: const Text(
                            'Login',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF7BB442),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
