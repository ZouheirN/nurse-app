import 'package:flutter/material.dart';

class TimeTypeSelectionController {
  String? selectedTimeType;

  void selectTimeType(String timeType) {
    selectedTimeType = timeType.toLowerCase();
  }

  String? getTimeType() {
    if (selectedTimeType == 'full time') {
      selectedTimeType = "full-time";
    } else if (selectedTimeType == 'part time') {
      selectedTimeType = "part-time";
    }

    return selectedTimeType;
  }
}

class TimeTypeSelectionField extends StatefulWidget {
  final TimeTypeSelectionController controller;

  const TimeTypeSelectionField({
    super.key,
    required this.controller,
  });

  @override
  State<TimeTypeSelectionField> createState() => _TimeTypeSelectionFieldState();
}

class _TimeTypeSelectionFieldState extends State<TimeTypeSelectionField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select Time Type',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildTimeTypeOption("Full Time"),
              _buildTimeTypeOption("Part Time"),
            ],
          ),
        ],
      ),
    );
  }

  String _capitalize(String timeType) {
    return timeType[0].toUpperCase() + timeType.substring(1).toLowerCase();
  }

  Widget _buildTimeTypeOption(String timeType) {
    bool isSelected =
        widget.controller.selectedTimeType == timeType.toLowerCase();
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.controller.selectTimeType(timeType);
        });
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.35,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFE7E7E7),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? Colors.green : Colors.transparent,
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            _capitalize(timeType),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
