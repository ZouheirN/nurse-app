import 'package:flutter/material.dart';
import 'package:nurse_app/utilities/helper_functions.dart';

class LabeledDateField extends StatefulWidget {
  final String label;
  final DateTime currentDate;
  final TimeOfDay currentTime;
  final Function onPicked;

  const LabeledDateField({
    super.key,
    required this.label,
    required this.currentDate,
    required this.onPicked,
    required this.currentTime,
  });

  @override
  _LabeledDateFieldState createState() => _LabeledDateFieldState();
}

class _LabeledDateFieldState extends State<LabeledDateField> {
  late bool _isFocused;
  DateTime? _selectedDate;

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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: widget.currentDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (date == null) return;

    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: widget.currentTime,
    );
    if (time == null) return;

    final newDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    setState(() {
      _selectedDate = newDateTime;
    });

    widget.onPicked(newDateTime);
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
                color: Color(0xFF7BB442)),
          ),
          const SizedBox(height: 3),
          Expanded(
            child: Focus(
              onFocusChange: _onFocusChange,
              child: GestureDetector(
                onTap: () => _selectDate(context),
                child: AbsorbPointer(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: _selectedDate == null
                          ? 'mm/dd/yyyy'
                          : formatDateTimeForRequestDetails(_selectedDate!),
                      // : "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}@${_selectedDate!.hour}:${_selectedDate!.minute}",
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
                          horizontal: 10, vertical: 10),
                    ),
                    style: TextStyle(
                      color: _selectedDate != null ? Colors.black : Colors.grey,
                    ),
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
