import 'package:flutter/material.dart';
import 'package:time_picker_sheet/widget/sheet.dart';
import 'package:time_picker_sheet/widget/time_picker.dart';

class NumberPickerField extends StatefulWidget {
  final String label;
  final TextEditingController? controller;

  const NumberPickerField({
    super.key,
    required this.label,
    this.controller,
  });

  @override
  State<NumberPickerField> createState() => _NumberPickerFieldState();
}

class _NumberPickerFieldState extends State<NumberPickerField> {
  int _currentValue = 3;
  String _curenntTimeUnit = 'min';

  Future<void> showTimePickerSlider() async {
    final result = await TimePicker.show<DateTime?>(
      context: context,
      sheet: TimePickerSheet(
        sheetTitle: 'Set time to arrive',
        hourTitle: 'Hour',
        minuteTitle: 'Minute',
        saveButtonText: 'Save',
        sheetCloseIconColor: Colors.black,
        saveButtonColor: const Color(0xFF7BB442),

      ),
    );
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
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 3),
          GestureDetector(
            onTap: showTimePickerSlider,
            child: TextField(
              enabled: false,
              controller: widget.controller,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                hintText: 'Select Time',
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: Color(0xFFE7E7E7)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: Color(0xFFE7E7E7)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: Color(0xFFE7E7E7)),
                ),
                fillColor: Color(0xFFE7E7E7),
                filled: true,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
