import 'package:flutter/material.dart';
import 'package:nurse_app/components/pending_button.dart';
import 'package:nurse_app/extensions/context_extension.dart';

class PendingPage extends StatelessWidget {
  final Function(String?) setValue;

  const PendingPage({super.key, required this.setValue});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        setValue(null);
      },
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PendingButton(
              onTap: () {
                setValue(null);
              },
              buttonText: context.localizations.goBack,
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 15),
            Center(
              child: Text(
                context.localizations.yourRequestHasBeenSubmitted,
                style: const TextStyle(
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
