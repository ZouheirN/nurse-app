import 'package:flutter/material.dart';

class LabeledExpandableTextFieldAdmin extends StatefulWidget {
  final String label;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  const LabeledExpandableTextFieldAdmin({
    super.key,
    required this.label,
    this.controller,
    this.validator,
  });

  @override
  State<LabeledExpandableTextFieldAdmin> createState() =>
      _LabeledExpandableTextFieldAdminState();
}

class _LabeledExpandableTextFieldAdminState
    extends State<LabeledExpandableTextFieldAdmin> {
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
      padding: const EdgeInsets.symmetric(horizontal: 40),
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
            child: SizedBox(
              height: 120,
              child: TextFormField(
                controller: widget.controller,
                keyboardType: TextInputType.multiline,
                expands: true,
                maxLines: null,
                minLines: null,
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
          ),
        ],
      ),
    );
  }
}
