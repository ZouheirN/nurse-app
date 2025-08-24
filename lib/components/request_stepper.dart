import 'package:flutter/material.dart';

class RequestStepper extends StatelessWidget {
  final int currentStep;

  const RequestStepper({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildStep(
          1,
          Icons.check,
        ),
        _buildLine(1, currentStep),
        _buildLine(2, currentStep),
        _buildStep(
          2,
          Icons.local_hospital,
        ),
        _buildLine(2, currentStep),
        _buildLine(3, currentStep),
        _buildStep(
          3,
          Icons.home,
        ),
        _buildLine(3, currentStep),
        _buildLine(4, currentStep),
        _buildStep(
          4,
          Icons.home,
        ),
      ],
    );
  }

  Widget _buildStep(int step, IconData icon) {
    final isActive = currentStep >= step;

    return Column(
      children: [
        Container(
          height: 56,
          width: 56,
          decoration: BoxDecoration(
            color:
                isActive ? const Color.fromRGBO(127, 255, 0, 1) : Colors.white,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 24,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildLine(int step, int currentStep) {
    final isActive = currentStep >= step;

    return Expanded(
      child: Container(
        height: 4,
        color: isActive ? const Color.fromRGBO(127, 255, 0, 1) : Colors.white,
      ),
    );
  }
}
