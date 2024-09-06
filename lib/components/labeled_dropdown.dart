import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class LabeledDropdown extends StatefulWidget {
  final String label;
  final List<String> services;
  final String? initialValue;
  final void Function(String?)? onChanged;
  final String? Function(String?)? validator;

  const LabeledDropdown({
    super.key,
    required this.label,
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
              child: DropdownButtonFormField2<String>(
                value: selectedValue,
                isExpanded: true,
                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(3)),
                    borderSide: BorderSide(color: Color(0xFF7BB442), width: 2),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(3)),
                    borderSide: BorderSide(color: Color(0xFF7BB442), width: 2),
                  ),
                  fillColor: _isFocused ? Colors.white : Colors.white,
                  filled: true,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                ),
                items: widget.services
                    .map((item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            style: TextStyle(
                              fontSize: 16,
                              color: item == selectedValue
                                  ? Colors.black
                                  : Colors.white,
                            ),
                          ),
                        ))
                    .toList(),
                dropdownStyleData: DropdownStyleData(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: const Color(0xFF7BB442),
                  ),
                  scrollbarTheme: const ScrollbarThemeData(
                    radius: Radius.circular(40),
                  ),
                ),
                menuItemStyleData: const MenuItemStyleData(
                  height: 40,
                  padding: EdgeInsets.only(left: 10, right: 10),
                ),
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
