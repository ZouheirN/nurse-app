import 'package:flutter/material.dart';

class LabeledTextFieldAdmin extends StatefulWidget {
  final String label;
  final TextInputType keyboardType;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool? hasPadding;
  final Function? onChanged;

  const LabeledTextFieldAdmin({
    super.key,
    required this.label,
    this.keyboardType = TextInputType.text,
    this.controller,
    this.validator,
    this.hasPadding = true,
    this.onChanged,
  });

  @override
  State<LabeledTextFieldAdmin> createState() => _LabeledTextFieldAdminState();
}

class _LabeledTextFieldAdminState extends State<LabeledTextFieldAdmin> {
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
      padding: widget.hasPadding == true
          ? const EdgeInsets.symmetric(horizontal: 40)
          : EdgeInsets.zero,
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
          Focus(
            onFocusChange: _onFocusChange,
            child: TextFormField(
              onChanged: (value) {
                if (widget.onChanged != null) {
                  widget.onChanged!(value);
                }
              },
              controller: widget.controller,
              keyboardType: widget.keyboardType,
              decoration: InputDecoration(
                enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: Color(0xFF7BB442)),
                ),
                errorBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: Colors.red),
                ),
                focusedErrorBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: Colors.red),
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
              validator: widget.validator,
            ),
          ),
        ],
      ),
    );
  }
}
