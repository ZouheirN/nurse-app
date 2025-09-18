import 'package:flutter/material.dart';
import 'package:nurse_app/utilities/helper_functions.dart';

class UneditableLabeledDate extends StatefulWidget {
  final String label;
  final DateTime date;

  const UneditableLabeledDate({
    super.key,
    required this.label,
    required this.date,
  });

  @override
  _UneditableLabeledDateState createState() => _UneditableLabeledDateState();
}

class _UneditableLabeledDateState extends State<UneditableLabeledDate> {
  late bool _isFocused;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _isFocused = false;
    _selectedDate = widget.date; // Pre-populate with initial date
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
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF7BB442),
            ),
          ),
          const SizedBox(height: 3),
          Expanded(
            child: Focus(
              onFocusChange: _onFocusChange,
              child: AbsorbPointer(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: _selectedDate == null
                        ? 'mm/dd/yyyy'
                        : formatDateTimeForRequestDetails(_selectedDate!),
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(3)),
                      borderSide:
                          BorderSide(color: Color(0xFF7BB442), width: 2),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(3)),
                      borderSide:
                          BorderSide(color: Color(0xFF7BB442), width: 2),
                    ),
                    fillColor: _isFocused
                        ? const Color.fromARGB(255, 245, 245, 245)
                        : const Color(0xFFE7E7E7),
                    filled: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                  ),
                  style: TextStyle(
                    color: _selectedDate != null ? Colors.black : Colors.grey,
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
