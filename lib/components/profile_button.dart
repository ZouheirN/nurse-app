import 'package:flutter/material.dart';
import 'package:nurse_app/extensions/context_extension.dart';

class ProfileButton extends StatelessWidget {
  final ImageProvider iconImage;
  final String buttonText;
  final Function? onTap;

  const ProfileButton({
    super.key,
    required this.iconImage,
    required this.buttonText,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap!();
        }
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color.fromRGBO(19, 27, 10, 1),
              Color.fromRGBO(101, 148, 54, 1),
            ],
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image(
                image: iconImage,
                height: 30,
                width: 30,
              ),
            ),
            Padding(
              padding: context.localizations.localeName == 'en'
                  ? const EdgeInsets.only(
                      right: 8.0,
                    )
                  : const EdgeInsets.only(
                      left: 4.0,
                    ),
              child: Text(
                buttonText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
