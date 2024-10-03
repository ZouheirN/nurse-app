import 'package:flutter/material.dart';
import 'package:nurse_app/components/pending_button.dart';

class PendingPage extends StatelessWidget {
  final Function(String) setValue;

  const PendingPage({super.key, required this.setValue});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        setValue('home');
      },
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PendingButton(
              onTap: () {
                setValue('home');
              },
              buttonText: 'Pending',
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 15),
            const Center(
              child: Text(
                'Your Request has been\nsubmitted!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF7BB442),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
