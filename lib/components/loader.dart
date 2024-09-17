import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  final Color color;

  const Loader({
    super.key,
    this.color = const Color(0xFF7BB442),
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }
}
