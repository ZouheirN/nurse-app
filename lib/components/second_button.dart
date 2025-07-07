import 'package:flutter/material.dart';

class MySecondButton extends StatelessWidget {
  final Function()? onTap;
  final String buttonText;
  final Icon? icon;

  const MySecondButton({
    super.key,
    required this.onTap,
    required this.buttonText,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        margin: const EdgeInsets.symmetric(horizontal: 30),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color.fromRGBO(19, 27, 10, 1),
              Color.fromRGBO(101, 148, 54, 1),
            ],
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            if (icon != null) Row(
              children: [
                const SizedBox(width: 10),
                icon!,
              ],
            ),
            const Spacer(),
            Text(
              buttonText,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 20,
                fontStyle: FontStyle.italic,
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
