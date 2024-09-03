import 'package:flutter/material.dart';

class LogoutButton extends StatelessWidget {
  final Icon icon;
  final String buttonText;
  final Function()? onTap;

  const LogoutButton({
    super.key,
    required this.icon,
    required this.buttonText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon.icon,
              size: 30,
              color: Colors.red,
            ),
            const SizedBox(width: 10),
            Text(
              buttonText,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
