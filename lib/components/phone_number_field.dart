import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class PhoneNumberField extends StatefulWidget {
  final String initialCountryCode;

  const PhoneNumberField({
    super.key,
    this.initialCountryCode = 'LB',
  });

  @override
  _PhoneNumberFieldState createState() => _PhoneNumberFieldState();
}

class _PhoneNumberFieldState extends State<PhoneNumberField> {
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
      padding: const EdgeInsets.symmetric(horizontal: 40),
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
                initialCountryCode: widget.initialCountryCode,
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
                style: const TextStyle(
                  fontSize: 16,
                ),
                dropdownTextStyle: const TextStyle(
                  fontSize: 16,
                ),
                dropdownDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: _isFocused
                      ? const Color.fromARGB(255, 245, 245, 245)
                      : const Color(0xFFE7E7E7),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}