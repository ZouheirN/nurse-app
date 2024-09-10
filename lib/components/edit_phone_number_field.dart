import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class EditPhoneNumberField extends StatefulWidget {
  final String initialCountryCode;
  final TextEditingController? controller;

  const EditPhoneNumberField({
    super.key,
    this.initialCountryCode = 'LB',
    this.controller,
  });

  @override
  _EditPhoneNumberFieldState createState() => _EditPhoneNumberFieldState();
}

class _EditPhoneNumberFieldState extends State<EditPhoneNumberField> {
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
      height: 90,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Phone Number',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 3),
          Expanded(
            child: Focus(
              onFocusChange: _onFocusChange,
              child: IntlPhoneField(
                controller: widget.controller,
                initialCountryCode: widget.initialCountryCode,
                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Color(0xFFC2C2C2)),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Color(0xFFC2C2C2)),
                  ),
                  fillColor: _isFocused
                      ? const Color.fromARGB(255, 185, 185, 185)
                      : const Color(0xFFC2C2C2),
                  filled: true,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                ),
                style: const TextStyle(
                  fontSize: 16,
                ),
                dropdownTextStyle: const TextStyle(
                  fontSize: 16,
                ),
                dropdownDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: _isFocused
                      ? const Color.fromARGB(255, 185, 185, 185)
                      : const Color(0xFFC2C2C2),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
