import 'package:flutter/material.dart';

class LabeledMiniTextfieldOrder extends StatefulWidget {
  final String label;
  final TextInputType keyboardType;
  final TextEditingController? controller;
  final String? hintText;
  final TextAlign? textAlign;

  const LabeledMiniTextfieldOrder({
    super.key,
    required this.label,
    this.keyboardType = TextInputType.text,
    this.controller,
    this.hintText,
    this.textAlign,
  });

  @override
  _LabeledMiniTextfieldOrderState createState() =>
      _LabeledMiniTextfieldOrderState();
}

class _LabeledMiniTextfieldOrderState extends State<LabeledMiniTextfieldOrder> {
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
      // height: 70,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Focus(
        onFocusChange: _onFocusChange,
        child: TextField(
          enabled: false,
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          textAlign: widget.textAlign ?? TextAlign.start,
          decoration: InputDecoration(
            hintText: widget.hintText,

            disabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(color: Color(0xFFE7E7E7)),
            ),
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
    );
  }
}
