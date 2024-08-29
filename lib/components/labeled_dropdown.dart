import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class LabeledDropdown extends StatefulWidget {
  final List<String> services;
  final String? initialValue;
  final void Function(String?)? onChanged;
  final String? Function(String?)? validator;

  const LabeledDropdown({
    super.key,
    required this.services,
    this.initialValue,
    this.onChanged,
    this.validator,
  });

  @override
  _LabeledDropdownState createState() => _LabeledDropdownState();
}

class _LabeledDropdownState extends State<LabeledDropdown> {
  String? selectedValue;
  late bool _isFocused;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.initialValue;
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
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Services',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 3),
          Expanded(
            child: Focus(
              onFocusChange: _onFocusChange,
              child: DropdownButtonFormField2<String>(
                value: selectedValue,
                isExpanded: true,
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
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                ),
                items: widget.services
                    .map((item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedValue = value;
                  });
                  if (widget.onChanged != null) {
                    widget.onChanged!(value);
                  }
                },
                validator: widget.validator,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
