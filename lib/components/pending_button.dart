import 'package:flutter/material.dart';

class PendingButton extends StatelessWidget {
  final Function()? onTap;
  final String buttonText;
  final Icon? icon;

  const PendingButton({super.key, required this.onTap, required this.buttonText, required this.icon});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        margin: const EdgeInsets.symmetric(horizontal: 120),
        decoration: BoxDecoration(
          color: const Color(0xFF8E8E8E),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child:  Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (icon != null) icon!,
              Text(
                buttonText,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),

        ),
      ),
    );
  }
}
