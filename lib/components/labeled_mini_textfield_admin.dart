import 'package:flutter/material.dart';

class LabeledMiniTextfieldAdmin extends StatefulWidget {
  final String label;
  final TextInputType keyboardType;
  final TextEditingController? controller;

  const LabeledMiniTextfieldAdmin({
    super.key,
    required this.label,
    this.keyboardType = TextInputType.text,
    this.controller,
  });

  @override
  _LabeledMiniTextfieldAdminState createState() =>
      _LabeledMiniTextfieldAdminState();
}

class _LabeledMiniTextfieldAdminState extends State<LabeledMiniTextfieldAdmin> {
  late bool _isFocused;

  @override
  void initState() {
    super.initState();
    _isFocused = false;
  }

  void _onFocusChange(bool hasFocus) {
    setState(() {
      _isFocused = hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 3),
          Expanded(
            child: Focus(
              onFocusChange: _onFocusChange,
              child: TextField(
                controller: widget.controller,
                keyboardType: widget.keyboardType,
                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Color(0xFF7BB442)),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Color(0xFF7BB442)),
                  ),
                  fillColor: _isFocused
                      ? const Color(0xFFE8FFD1)
                      : const Color(0xFFE8FFD1),
                  filled: true,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
