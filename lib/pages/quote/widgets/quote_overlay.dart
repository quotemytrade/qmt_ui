import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quotemytrade/core/providers/app_providers.dart';
import 'package:quotemytrade/theme/app_colors.dart';
import 'package:quotemytrade/widgets/common/chat/chat_bubble.dart';

class QuoteOverlay extends ConsumerWidget {
  const QuoteOverlay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOpen = ref.watch(getQuoteOverlayProvider);
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;

    if (!isOpen) return const SizedBox.shrink();

    return Stack(
      children: [_buildBackdrop(ref), _buildPanel(context, ref, isMobile)],
    );
  }

  Widget _buildBackdrop(WidgetRef ref) {
    return GestureDetector(
      onTap: () => ref.read(getQuoteOverlayProvider.notifier).state = false,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(color: Colors.black.withOpacity(0.4)),
      ),
    );
  }

  Widget _buildPanel(BuildContext context, WidgetRef ref, bool isMobile) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: AnimatedSlide(
        offset: const Offset(0, 0),
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          height: isMobile ? MediaQuery.of(context).size.height * 0.92 : 640,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: Column(
            children: [
              _buildDragHandle(),
              _buildHeader(ref),
              const Divider(height: 1),
              _buildChatContent(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDragHandle() {
    return Column(
      children: [
        const SizedBox(height: 12),
        Container(
          width: 60,
          height: 6,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'AI Quote Assistant',
            style: GoogleFonts.inter(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          // Close Button
          IconButton(
            icon: const Icon(Icons.close, size: 28),
            color: AppColors.textSecondary,
            onPressed: () {
              ref.read(getQuoteOverlayProvider.notifier).state = false;
            },
            tooltip: 'Close',
            splashRadius: 24,
          ),
        ],
      ),
    );
  }

  Widget _buildChatContent() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: const [
                  ChatBubble(
                    isBot: true,
                    text:
                        'Hi 👋 Im your AI Quote Assistant.\nWhat trade do you need help with?',
                  ),
                  SizedBox(height: 16),
                  ChatBubble(isBot: false, text: 'Electrician'),
                  SizedBox(height: 16),
                  ChatBubble(
                    isBot: true,
                    text:
                        'Great! ⚡ Please share your location and job details.',
                  ),
                ],
              ),
            ),
            _buildInputBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 12),
        ],
      ),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'Type your response…',
              style: TextStyle(color: AppColors.textMuted, fontSize: 16),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.send, color: Colors.white, size: 20),
          ),
        ],
      ),
    );
  }
}
