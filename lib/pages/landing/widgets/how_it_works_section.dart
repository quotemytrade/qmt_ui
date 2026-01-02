import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quotemytrade/widgets/cards/step_card.dart';

class HowItWorksSection extends StatelessWidget {
  const HowItWorksSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 32),
      child: Column(
        children: [
          Text(
            'How It Works',
            style: GoogleFonts.inter(fontSize: 40, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 60),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              StepCard(
                number: '1',
                title: 'Select Trade & Location',
                icon: Icons.category,
              ),
              StepCard(
                number: '2',
                title: 'Enter Job Details',
                icon: Icons.edit_note,
              ),
              StepCard(
                number: '3',
                title: 'Get Instant AI Quote',
                icon: Icons.flash_on,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
