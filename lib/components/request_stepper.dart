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
          Image.asset(
            'assets/images/mobile_friendly.png',
            width: 24,
            height: 24,
          ),
        ),
        _buildLine(1, currentStep),
        _buildLine(2, currentStep),
        _buildStep(
          2,
          Image.asset(
            'assets/images/clipboard.png',
            width: 24,
            height: 24,
          ),
        ),
        _buildLine(2, currentStep),
        _buildLine(3, currentStep),
        _buildStep(
            3,
            Image.asset(
              'assets/images/fast-delivery.png',
              width: 30,
              height: 30,
            )),
        _buildLine(3, currentStep),
        _buildLine(4, currentStep),
        _buildStep(
            4,
            Image.asset(
              'assets/images/delivery-truck.png',
              width: 25,
              height: 25,
            )),
      ],
    );
  }

  Widget _buildStep(int step, Widget image) {
    final isActive = currentStep >= step;

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 56,
          width: 56,
          decoration: BoxDecoration(
            color:
                isActive ? const Color.fromRGBO(127, 255, 0, 1) : Colors.white,
            shape: BoxShape.circle,
          ),
        ),
        image,
        // Icon(
        //   icon,
        //   size: 24,
        //   color: Colors.black,
        // ),
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
