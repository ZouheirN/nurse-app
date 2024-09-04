import 'package:flutter/material.dart';

class TextData extends StatelessWidget {
  final String label;
  final String data;

  const TextData({super.key, required this.label, required this.data});

  @override
  Widget build(BuildContext context) {
    final Color labelColor = label == "Request Date: "
        ? const Color(0xFF8E8E8E)
        : const Color(0xFF7BB442);
    final Color dataColor = label == "Request Date: "
        ? const Color(0xFF8E8E8E)
        : const Color(0xFF000000);

    return Container(
      padding: const EdgeInsets.only(right: 40, left: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 22,
                color: labelColor,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Expanded(
            child: Text(
              data,
              style: TextStyle(
                fontSize: 22,
                color: dataColor,
                fontWeight: FontWeight.w400,
              ),
              overflow: TextOverflow.visible,
            ),
          ),
        ],
      ),
    );
  }
}
