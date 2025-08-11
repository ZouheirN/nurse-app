import 'package:cached_network_image/cached_network_image.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';

import '../features/home/cubit/home_cubit.dart';
import 'loader.dart';

class HomeScreenSliders extends StatefulWidget {
  const HomeScreenSliders({super.key});

  @override
  State<HomeScreenSliders> createState() => _HomeScreenSlidersState();
}

class _HomeScreenSlidersState extends State<HomeScreenSliders> {
  int dotIndex = 0;

  final HomeCubit homeCubit = HomeCubit();

  @override
  void initState() {
    homeCubit.getSliders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      bloc: homeCubit,
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

          if (items.isEmpty) {
            return const SizedBox.shrink();
          }

          return Column(
            children: [
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
          );
        }

        return const Center(child: Text('Failed to get images.'));
      },
    );
  }
}
