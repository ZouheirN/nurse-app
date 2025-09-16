import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:nurse_app/components/header.dart';
import 'package:nurse_app/components/home_screen_sliders.dart';
import 'package:nurse_app/components/loader.dart';
import 'package:nurse_app/extensions/context_extension.dart';
import 'package:nurse_app/pages/user/pending_page.dart';

import '../../components/faq.dart';
import '../../features/home/cubit/home_cubit.dart';
import 'make_appointment_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ValueNotifier<String?> _selectedOption = ValueNotifier(null);

  final _homeCubit = HomeCubit();

  @override
  void initState() {
    _homeCubit.getCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: _selectedOption,
          builder: (context, value, child) {
            return Column(
              children: [
                const Header(
                  showLocation: true,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (value == null) ...[
                          const HomeScreenSliders(),
                          Center(
                            child: Text(
                              context.localizations.ourCategories,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          BlocBuilder<HomeCubit, HomeState>(
                            bloc: _homeCubit,
                            builder: (context, state) {
                              if (state is GetCategoriesLoading) {
                                return const Loader();
                              } else if (state is GetCategoriesFailure) {
                                return Center(
                                  child: Text(state.message),
                                );
                              } else if (state is GetCategoriesSuccess) {
                                final categories = state.categories.categories;

                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  child: Wrap(
                                    runSpacing: 10,
                                    spacing: 10,
                                    children: [
                                      for (final category in categories)
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () {
                                              _selectedOption.value =
                                                  category.name;
                                            },
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: // todo fix
                                                    CachedNetworkImage(
                                                        imageUrl:
                                                            'https://i.ibb.co/d0KcQgdz/category1.jpg')),
                                          ),
                                        ),
                                    ],
                                  ),
                                );
                              }

                              return const SizedBox.shrink();
                            },
                          ),
                          const SizedBox(height: 16),
                          Center(
                            child: Text(
                              context.localizations.trustedBy,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                          Builder(
                            builder: (context) {
                              final controller = FlutterCarouselController();

                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        controller.previousPage();
                                      },
                                      child: const CircleAvatar(
                                        backgroundColor:
                                            Color.fromRGBO(90, 135, 35, 1),
                                        radius: 15,
                                        child: Icon(
                                          Icons.chevron_left,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: FlutterCarousel(
                                        options: FlutterCarouselOptions(
                                          controller: controller,
                                          showIndicator: false,
                                          autoPlay: true,
                                          autoPlayInterval:
                                              const Duration(seconds: 5),
                                          enlargeCenterPage: false,
                                          enableInfiniteScroll: true,
                                          pauseAutoPlayOnTouch: true,
                                          height: 128,
                                          scrollDirection: Axis.horizontal,
                                          viewportFraction: 0.3,
                                        ),
                                        items: List.generate(
                                          6,
                                          (index) => Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 4),
                                            child: Image.asset(
                                              'assets/images/iso.png',
                                              height: 128,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        controller.nextPage();
                                      },
                                      child: const CircleAvatar(
                                        backgroundColor:
                                            Color.fromRGBO(90, 135, 35, 1),
                                        radius: 15,
                                        child: Icon(
                                          Icons.chevron_right,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          const Faq(),
                        ],
                        if (value != null && value != 'success')
                          MakeAppointmentPage(
                            setValue: (newValue) {
                              _selectedOption.value = newValue;
                            },
                            category: value,
                          ),
                        if (value == 'success')
                          PendingPage(
                            setValue: (newValue) {
                              _selectedOption.value = newValue;
                            },
                          )
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// Builder(
//   builder: (context) {
//     if (value == 'immediate') {
//       return MakeAppointmentPage(
//         category: 'guard request',
//         setValue: (value) {
//           _selectedOption.value = value;
//         },
//       );
//     } else if (value == 'appointment') {
//       return MakeAppointmentPage(
//         category: 'service request',
//         setValue: (value) {
//           _selectedOption.value = value;
//         },
//       );
//     } else if (value == 'success') {
//       return PendingPage(
//         setValue: (value) {
//           _selectedOption.value = value;
//         },
//       );
//     }
//
//     return Column(
//       children: [
//         Text(
//           context.localizations.ourCategories,
//           style: const TextStyle(
//             fontSize: 20,
//             fontWeight: FontWeight.w800,
//             fontStyle: FontStyle.italic,
//           ),
//         ),
//         const SizedBox(height: 12),
//         Padding(
//           padding: const EdgeInsets.symmetric(
//             horizontal: 16,
//           ),
//           child: Row(
//             children: [
//               Expanded(
//                 child: GestureDetector(
//                   onTap: () {
//                     _selectedOption.value = 'immediate';
//                   },
//                   child: ClipRRect(
//                     borderRadius:
//                         BorderRadius.circular(10),
//                     child: Image.asset(
//                       'assets/images/category1.png',
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 10),
//               Expanded(
//                 child: GestureDetector(
//                   onTap: () {
//                     _selectedOption.value =
//                         'appointment';
//                   },
//                   child: ClipRRect(
//                     borderRadius:
//                         BorderRadius.circular(10),
//                     child: Image.asset(
//                       'assets/images/category2.png',
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(height: 16),
//         Text(
//           context.localizations.trustedBy,
//           style: const TextStyle(
//             fontSize: 20,
//             fontWeight: FontWeight.w800,
//             fontStyle: FontStyle.italic,
//           ),
//         ),
//         Builder(
//           builder: (context) {
//             final controller =
//                 FlutterCarouselController();
//
//             return Padding(
//               padding: const EdgeInsets.symmetric(
//                 horizontal: 8,
//               ),
//               child: Row(
//                 children: [
//                   GestureDetector(
//                     onTap: () {
//                       controller.previousPage();
//                     },
//                     child: const CircleAvatar(
//                       backgroundColor: Color.fromRGBO(
//                           90, 135, 35, 1),
//                       radius: 15,
//                       child: Icon(
//                         Icons.chevron_left,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     child: FlutterCarousel(
//                       options: FlutterCarouselOptions(
//                         controller: controller,
//                         showIndicator: false,
//                         autoPlay: true,
//                         autoPlayInterval:
//                             const Duration(seconds: 5),
//                         enlargeCenterPage: false,
//                         enableInfiniteScroll: true,
//                         pauseAutoPlayOnTouch: true,
//                         height: 128,
//                         scrollDirection:
//                             Axis.horizontal,
//                         viewportFraction: 0.3,
//                       ),
//                       items: List.generate(
//                         6,
//                         (index) => Padding(
//                           padding: const EdgeInsets
//                               .symmetric(horizontal: 4),
//                           child: Image.asset(
//                             'assets/images/iso.png',
//                             height: 128,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   GestureDetector(
//                     onTap: () {
//                       controller.nextPage();
//                     },
//                     child: const CircleAvatar(
//                       backgroundColor: Color.fromRGBO(
//                           90, 135, 35, 1),
//                       radius: 15,
//                       child: Icon(
//                         Icons.chevron_right,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         ),
//         const Faq(),
//         // const Center(
//         //   child: Image(
//         //     image: AssetImage('assets/images/logo.png'),
//         //     height: 150,
//         //     width: 300,
//         //   ),
//         // ),
//       ],
//     );
//   },
// ),
