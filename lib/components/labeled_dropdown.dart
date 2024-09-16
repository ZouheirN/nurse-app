import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class LabeledDropdown extends StatefulWidget {
  final String label;
  final List<Map<String, dynamic>> services;
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
  State<LabeledDropdown> createState() => _LabeledDropdownState();
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

  Widget _buildImage(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return Image.asset(
        'assets/images/default_profile.png',
        width: 35,
        height: 35,
        fit: BoxFit.cover,
      );
    } else if (imagePath.startsWith('http') || imagePath.startsWith('https')) {
      return Image.network(
        imagePath,
        width: 35,
        height: 35,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(
            'assets/images/default_profile.png',
            width: 35,
            height: 35,
            fit: BoxFit.cover,
          );
        },
      );
    } else {
      return Image.asset(
        imagePath,
        width: 35,
        height: 35,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(
            'assets/images/default_profile.png',
            width: 35,
            height: 35,
            fit: BoxFit.cover,
          );
        },
      );
    }
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
                          value: item['name'].toString(),
                          child: Row(
                            children: [
                              _buildImage(item['profile_picture']),
                              const SizedBox(width: 10),
                              Text(
                                item['name'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ],
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
                selectedItemBuilder: (BuildContext context) {
                  return widget.services.map((item) {
                    return Text(
                      item['name'],
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                    );
                  }).toList();
                },
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
