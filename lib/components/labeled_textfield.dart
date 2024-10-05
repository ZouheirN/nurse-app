import 'package:flutter/material.dart';

class LabeledTextfield extends StatefulWidget {
  final String label;
  final TextInputType keyboardType;
  final TextEditingController? controller;
  final bool enabled;
  final EdgeInsetsGeometry? padding;
  final String? hintText;
  final bool? centerHintText;
  final Function? onTap;
  final String? Function(String?)? validator;
  final bool? expand;

  const LabeledTextfield({
    super.key,
    required this.label,
    this.keyboardType = TextInputType.text,
    this.controller,
    this.enabled = true,
    this.padding,
    this.hintText,
    this.centerHintText,
    this.onTap,
    this.validator,
    this.expand = false,
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
      // height: 70,
      // width: double.infinity,
      padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 40),
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
          GestureDetector(
            onTap: () {
              if (widget.onTap != null) {
                widget.onTap!();
              }
            },
            child: Focus(
              onFocusChange: _onFocusChange,
              child: SizedBox(
                height: widget.expand! ? 120 : null,
                child: TextFormField(
                  expands: widget.expand!,
                  maxLines: widget.expand! ? null : 1,
                  minLines: null,
                  validator: widget.validator,
                  enabled: widget.enabled,
                  controller: widget.controller,
                  keyboardType: widget.keyboardType,
                  textAlign: widget.centerHintText ?? false
                      ? TextAlign.center
                      : TextAlign.start,
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    errorBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(color: Colors.red),
                    ),
                    focusedErrorBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(color: Colors.red),
                    ),
                    hintStyle: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
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
            ),
          ),
        ],
      ),
    );
  }
}
