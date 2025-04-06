import 'package:flutter/material.dart';

class Faq extends StatelessWidget {
  const Faq({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'FAQS',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontStyle: FontStyle.italic,
            fontSize: 20,
          ),
        ),
        _buildTile('How should I safely shower an elderly person?',
            '''• Ensure the bathroom is warm and slip-resistant mats are in place.
• Use a shower chair for extra support if needed.
• Check the water temperature to prevent burns.
• Use a handheld showerhead for better control.
• Gently wash the person, paying attention to hygiene and comfort.
• Dry them completely to prevent skin irritation.'''),
        _buildTile('How often should I change an elderly person\'s diaper?',
            '''• Diapers should be changed every 3-4 hours or whenever soiled.
• Wash your hands and wear gloves before starting.
• Gently roll the person to their side and remove the soiled diaper.
• Clean the area with mild soap or wipes, ensuring it’s dry before putting on a new diaper.
• Apply barrier cream to prevent rashes.
• Secure the new diaper snugly but not too tight to allow comfort.'''),
        _buildTile(
            'What does travel assistance for elderly individuals include?',
            '''• Help with booking transportation suited to their mobility needs.
• Assistance with luggage, boarding, and disembarking.
• Ensuring they have medications and necessary documents.
• Providing wheelchair or walking aid support if required.
• Accompanying them to medical appointments, vacations, or family visits.'''),
      ],
    );
  }

  _buildTile(String title, String body) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      child: ListTileTheme(
        tileColor: const Color(0xFF7BB442),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: ExpansionTile(
          iconColor: Colors.white,
          collapsedIconColor: Colors.white,
          collapsedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          children: [
            Container(
              margin: const EdgeInsets.only(left: 10, right: 10),
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                color: Color.fromARGB(255, 209, 209, 209),
              ),
              child: SizedBox(
                width: double.infinity,
                child: Text(
                  body,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
