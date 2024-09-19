import 'package:flutter/material.dart';

class GenderSelectionController {
  String? selectedGender;

  void selectGender(String gender) {
    selectedGender = gender.toLowerCase();
  }

  String? getGender() {
    return selectedGender;
  }
}

class GenderSelectionField extends StatefulWidget {
  final GenderSelectionController controller;

  const GenderSelectionField({
    super.key,
    required this.controller,
  });

  @override
  State<GenderSelectionField> createState() => _GenderSelectionFieldState();
}

class _GenderSelectionFieldState extends State<GenderSelectionField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select Nurse Gender',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildGenderOption("Male"),
              _buildGenderOption("Female"),
            ],
          ),
        ],
      ),
    );
  }

  String _capitalize(String gender) {
    return gender[0].toUpperCase() + gender.substring(1).toLowerCase();
  }

  Widget _buildGenderOption(String gender) {
    bool isSelected = widget.controller.selectedGender == gender.toLowerCase();
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.controller.selectGender(gender);
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
            _capitalize(gender),
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
