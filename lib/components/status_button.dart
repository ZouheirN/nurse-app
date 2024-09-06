import 'package:flutter/material.dart';

class StatusButton extends StatefulWidget {
  final Function()? onTap;
  final String buttonText;
  final Color color;

  const StatusButton({
    super.key,
    required this.onTap,
    required this.buttonText,
    required this.color,
  });

  @override
  State<StatusButton> createState() => _StatusButtonState();
}

class _StatusButtonState extends State<StatusButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 40,
      child: TextButton(
        onPressed: widget.onTap,
        style: TextButton.styleFrom(
          backgroundColor: widget.color,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
        child: Text(
          widget.buttonText,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
