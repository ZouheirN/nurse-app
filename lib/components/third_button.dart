import 'package:flutter/material.dart';

class MyThirdButton extends StatelessWidget {
  final Function()? onTap;
  final String buttonText;
  final bool isLoading;
  final Color? color;
  final EdgeInsets? margin;

  const MyThirdButton({
    super.key,
    required this.onTap,
    required this.buttonText,
    this.isLoading = false,
    this.color,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        height: 40,
        margin: margin ?? const EdgeInsets.symmetric(horizontal: 120),
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
        child: Center(
          child: isLoading
              ? const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
              : Text(
                  buttonText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
        ),
      ),
    );
  }
}
