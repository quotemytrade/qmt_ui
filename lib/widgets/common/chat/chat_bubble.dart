import 'package:flutter/material.dart';
import 'package:quotemytrade/theme/app_colors.dart';

class ChatBubble extends StatelessWidget {
  final bool isBot;
  final String text;

  const ChatBubble({super.key, required this.isBot, required this.text});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isBot ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.all(16),
        constraints: const BoxConstraints(maxWidth: 500),
        decoration: BoxDecoration(
          color: isBot ? AppColors.chatBubbleBorder : AppColors.primary,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isBot ? AppColors.darkBackground : Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
