import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:nurse_app/features/nurse/cubit/nurse_cubit.dart';

class StarRating extends StatefulWidget {
  final num nurseId;
  final double initialRating;

  const StarRating({
    super.key,
    this.initialRating = 0.0,
    required this.nurseId,
  });

  @override
  State<StarRating> createState() => _StarRatingState();
}

class _StarRatingState extends State<StarRating> {
  late double _currentRating;

  final _nurseCubit = NurseCubit();

  @override
  void initState() {
    super.initState();
    _currentRating = widget.initialRating;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NurseCubit, NurseState>(
      bloc: _nurseCubit,
      builder: (context, state) {
        return RatingBar(
          initialRating: _currentRating,
          minRating: 1,
          maxRating: 5,
          allowHalfRating: true,
          onRatingUpdate: (rating) {
            _nurseCubit.setRating(widget.nurseId, rating);
          },
          ratingWidget: RatingWidget(
            full: const Icon(Icons.star, color: Colors.amber),
            half: const Icon(Icons.star_half, color: Colors.amber),
            empty: const Icon(Icons.star_border, color: Colors.amber),
          ),
          glow: false,
        );
      },
    );
  }
}
