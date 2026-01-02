import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quotemytrade/theme/app_colors.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.darkBackground,
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 32),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [_buildBrandInfo(), _buildFooterLinks()],
          ),
          const SizedBox(height: 40),
          Text(
            '© 2026 QuoteMyTrade. All rights reserved.',
            style: TextStyle(color: Colors.white.withOpacity(0.6)),
          ),
        ],
      ),
    );
  }

  Widget _buildBrandInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'QuoteMyTrade',
          style: GoogleFonts.inter(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'AI-powered quotes that save time & win jobs.',
          style: TextStyle(color: Colors.white.withOpacity(0.8)),
        ),
      ],
    );
  }

  Widget _buildFooterLinks() {
    return Row(
      children: [
        TextButton(
          onPressed: () {},
          child: const Text(
            'Privacy Policy',
            style: TextStyle(color: Colors.white),
          ),
        ),
        const SizedBox(width: 32),
        TextButton(
          onPressed: () {},
          child: const Text(
            'Terms of Service',
            style: TextStyle(color: Colors.white),
          ),
        ),
        const SizedBox(width: 32),
        TextButton(
          onPressed: () {},
          child: const Text('Contact', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
