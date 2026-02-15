import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quotemytrade/core/providers/quote_provider.dart';
import 'package:quotemytrade/theme/app_colors.dart';

class QuoteStepperWidget extends ConsumerWidget {
  const QuoteStepperWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentStep = ref.watch(
      quoteProvider.select((state) => state.currentStep),
    );
    final totalSteps = 2;

    return Row(
      children: List.generate(totalSteps, (index) {
        final isActive = index == currentStep;
        final isCompleted = index < currentStep;

        return Expanded(
          child: Row(
            children: [
              // Step circle
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isActive
                      ? AppColors.primary
                      : (isCompleted
                            ? AppColors.accent
                            : AppColors.accent.withOpacity(0.2)),
                ),
                child: isActive
                    ? const CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : Icon(
                        isCompleted
                            ? Icons.check
                            : Icons.radio_button_unchecked,
                        color: Colors.white,
                        size: 20,
                      ),
              ),

              const SizedBox(width: 16),

              // Step label
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getStepTitle(index),
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: isActive
                            ? FontWeight.bold
                            : FontWeight.w500,
                        color: isActive
                            ? AppColors.primary
                            : (isCompleted
                                  ? AppColors.accent
                                  : AppColors.textSecondary),
                      ),
                    ),
                    Text(
                      _getStepSubtitle(index),
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppColors.textSecondary.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  String _getStepTitle(int index) {
    const titles = ['Location', 'AI Quote'];
    return titles[index];
  }

  String _getStepSubtitle(int index) {
    const subtitles = ['Enter your location', 'Get instant estimate'];
    return subtitles[index];
  }
}
