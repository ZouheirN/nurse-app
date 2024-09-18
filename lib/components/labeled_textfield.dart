import 'package:flutter/material.dart';

class LabeledTextfield extends StatefulWidget {
  final String label;
  final TextInputType keyboardType;
  final TextEditingController? controller;

  const LabeledTextfield({
    super.key,
    required this.label,
    this.keyboardType = TextInputType.text,
    this.controller,
  });

  @override
  State<LabeledTextfield> createState() => _LabeledTextfieldState();
}

class _LabeledTextfieldState extends State<LabeledTextfield> {
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
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label,
            style: const TextStyle(
              fontSize: 14,
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
                    borderSide: BorderSide(color: Color(0xFFE7E7E7)),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Color(0xFFE7E7E7)),
                  ),
                  fillColor: _isFocused
                      ? const Color.fromARGB(255, 245, 245, 245)
                      : const Color(0xFFE7E7E7),
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
