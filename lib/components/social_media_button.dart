import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialMediaButton extends StatelessWidget {
  final String? logoPath;
  final Icon? icon;
  final String? accountName;
  final String url;
  final bool? addPadding;

  const SocialMediaButton({
    super.key,
    this.logoPath,
    this.accountName,
    required this.url,
    this.icon,
    this.addPadding = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        launchUrl(Uri.parse(url));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Container(
          // width: 300,
          padding: addPadding == true
              ? const EdgeInsets.symmetric(vertical: 15, horizontal: 15)
              : null,
          decoration: BoxDecoration(
            color: const Color(0xFF7BB442),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (logoPath != null) ...[
                Image.asset(
                  logoPath!,
                  width: 30,
                  height: 30,
                ),
                const SizedBox(width: 10),
              ],
              if (icon != null) ...[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: icon!,
                ),
              ],
              if (accountName != null) ...[
                Text(
                  accountName!,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
