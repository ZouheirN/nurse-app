import 'package:flutter/material.dart';

class StarRating extends StatefulWidget {
  final int starCount;
  final double rating;
  final Color color;
  final double size;
  final Function(double) onRatingChanged;

  const StarRating({
    super.key,
    this.starCount = 5,
    this.rating = 0.0,
    this.color = Colors.amber,
    this.size = 24,
    required this.onRatingChanged,
  });

  @override
  State<StarRating> createState() => _StarRatingState();
}

class _StarRatingState extends State<StarRating> {
  late double _currentRating;

  @override
  void initState() {
    super.initState();
    _currentRating = widget.rating;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: List.generate(widget.starCount, (index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                _currentRating = index + 1.0;
                widget.onRatingChanged(_currentRating);
              });
            },
            child: Icon(
              index < _currentRating ? Icons.star : Icons.star_border,
              color: widget.color,
              size: widget.size,
            ),
          );
        }),
      ),
    );
  }
}
