import 'package:flutter/material.dart';

class LabeledEditTextfield extends StatefulWidget {
  final String label;
  final TextInputType keyboardType;

  const LabeledEditTextfield({
    super.key,
    required this.label,
    this.keyboardType = TextInputType.text,
  });

  @override
  _LabeledEditTextfieldState createState() => _LabeledEditTextfieldState();
}

class _LabeledEditTextfieldState extends State<LabeledEditTextfield> {
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
      height: 65,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20),
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
                keyboardType: widget.keyboardType,
                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Color(0xFFC2C2C2)),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Color(0xFFC2C2C2)),
                  ),
                  fillColor:
                      _isFocused ? const Color.fromARGB(255, 185, 185, 185) : const Color(0xFFC2C2C2),
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
