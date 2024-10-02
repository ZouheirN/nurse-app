import 'package:flutter/material.dart';

class StatusButton extends StatefulWidget {
  final Function()? onTap;
  final String buttonText;
  final Color color;
  final bool isLoading;

  const StatusButton({
    super.key,
    this.onTap,
    required this.buttonText,
    required this.color,
    this.isLoading = false,
  });

  @override
  State<StatusButton> createState() => _StatusButtonState();
}

class _StatusButtonState extends State<StatusButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.isLoading ? null : widget.onTap,
      child: Container(
        width: 120,
        height: 40,
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: widget.isLoading
              ? const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
              : Text(
                  widget.buttonText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }
}
