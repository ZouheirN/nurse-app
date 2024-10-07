import 'package:flutter/material.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class PhoneNumberField extends StatefulWidget {
  final String initialCountryCode;
  final TextEditingController? controller;
  final void Function(String number)? setCompleteNumber;
  final EdgeInsets? padding;
  final bool? showLabel;
  final Color? fillColor;
  final Color? outlineColor;
  final Color? focusedColor;
  final bool? showHintText;
  final bool? isNurse;

  const PhoneNumberField({
    super.key,
    this.initialCountryCode = 'LB',
    this.controller,
    this.setCompleteNumber,
    this.padding,
    this.showLabel = true,
    this.fillColor,
    this.outlineColor,
    this.focusedColor,
    this.showHintText = false,
    this.isNurse = false,
  });

  @override
  _PhoneNumberFieldState createState() => _PhoneNumberFieldState();
}

class _PhoneNumberFieldState extends State<PhoneNumberField> {
  late bool _isFocused;
  List<Country> preferredCountries = List.from(countries)
    ..removeWhere(
      (element) {
        return element.code == 'IL';
      },
    );

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
      // height: 90,
      width: double.infinity,
      padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.showLabel!)
            const Text(
              'Phone Number',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          if (widget.isNurse!)
            const Text(
              'Nurse Phone Number',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          if (widget.showLabel! || widget.isNurse!) const SizedBox(height: 3),
          Focus(
            onFocusChange: _onFocusChange,
            child: IntlPhoneField(
              onChanged: (phone) {
                widget.setCompleteNumber!(phone.completeNumber);
              },
              countries: preferredCountries,
              disableLengthCheck: false,
              controller: widget.controller,
              initialCountryCode: widget.initialCountryCode,
              flagsButtonMargin: const EdgeInsets.only(right: 10),
              decoration: InputDecoration(
                hintText: widget.showHintText! ? 'Phone Number' : null,
                hintStyle: widget.showHintText!
                    ? TextStyle(
                        color: Colors.grey[500], fontWeight: FontWeight.w300)
                    : null,
                enabledBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(
                      color: widget.outlineColor ?? const Color(0xFFE7E7E7)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(
                      color: widget.outlineColor ?? const Color(0xFFE7E7E7)),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(
                      color: widget.outlineColor ?? const Color(0xFFE7E7E7)),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(
                      color: widget.outlineColor ?? const Color(0xFFE7E7E7)),
                ),
                fillColor: _isFocused
                    ? widget.focusedColor ??
                        widget.fillColor ??
                        const Color.fromARGB(255, 245, 245, 245)
                    : widget.fillColor ?? const Color(0xFFE7E7E7),
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
                    ? widget.focusedColor ??
                        widget.fillColor ??
                        const Color.fromARGB(255, 245, 245, 245)
                    : widget.fillColor ?? const Color(0xFFE7E7E7),
                border: Border.all(
                  color: widget.outlineColor ?? const Color(0xFFE7E7E7),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
