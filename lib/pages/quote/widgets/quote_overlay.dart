import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quotemytrade/core/providers/app_providers.dart';
import 'package:quotemytrade/core/providers/chat_provider.dart';
import 'package:quotemytrade/theme/app_colors.dart';
import 'package:quotemytrade/widgets/chat/message_bubble_widget.dart';
import 'package:quotemytrade/widgets/chat/typing_indicator_widget.dart';
import 'package:quotemytrade/widgets/chat/chat_input_widget.dart';

// Provider for ScrollController
final scrollControllerProvider = Provider.autoDispose<ScrollController>((ref) {
  final controller = ScrollController();
  ref.onDispose(() => controller.dispose());
  return controller;
});

class QuoteOverlay extends ConsumerWidget {
  const QuoteOverlay({super.key});

  void _scrollToBottom(ScrollController controller) {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (controller.hasClients) {
        controller.animateTo(
          controller.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOpen = ref.watch(getQuoteOverlayProvider);
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;
    final messages = ref.watch(chatMessagesProvider);
    final isLoading = ref.watch(isLoadingProvider);
    final scrollController = ref.watch(scrollControllerProvider);

    // Auto-scroll when messages change
    ref.listen(chatMessagesProvider, (previous, next) {
      if (next.length != previous?.length) {
        _scrollToBottom(scrollController);
      }
    });

    // Also scroll when loading state changes (for typing indicator)
    ref.listen(isLoadingProvider, (previous, next) {
      if (next == true) {
        _scrollToBottom(scrollController);
      }
    });

    if (!isOpen) return const SizedBox.shrink();

    return Stack(
      children: [
        _buildBackdrop(ref),
        _buildPanel(
          context,
          ref,
          isMobile,
          messages,
          isLoading,
          scrollController,
        ),
      ],
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

  Widget _buildPanel(
    BuildContext context,
    WidgetRef ref,
    bool isMobile,
    List messages,
    bool isLoading,
    ScrollController scrollController,
  ) {
    final topPadding = MediaQuery.of(context).padding.top;
    final appBarHeight = 88.0;
    final totalTopOffset = topPadding + appBarHeight + 16;

    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.only(top: totalTopOffset),
        child: AnimatedSlide(
          offset: const Offset(0, 0),
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutCubic,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            height: isMobile
                ? MediaQuery.of(context).size.height - totalTopOffset
                : MediaQuery.of(context).size.height - totalTopOffset - 40,
            width: isMobile ? double.infinity : 900,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildDragHandle(),
                _buildHeader(ref),
                const Divider(height: 1),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: messages.length + (isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == messages.length) {
                        return const TypingIndicatorWidget();
                      }
                      return MessageBubbleWidget(message: messages[index]);
                    },
                  ),
                ),
                const ChatInputWidget(),
              ],
            ),
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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.accent.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.auto_awesome,
                  color: AppColors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'AI Quote Assistant',
                    style: GoogleFonts.inter(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    'Powered by Grok AI',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.refresh, size: 24),
                color: AppColors.textSecondary,
                onPressed: () {
                  ref.read(chatMessagesProvider.notifier).clearChat();
                },
                tooltip: 'Reset Chat',
              ),
              IconButton(
                icon: const Icon(Icons.close, size: 28),
                color: AppColors.textSecondary,
                onPressed: () {
                  ref.read(getQuoteOverlayProvider.notifier).state = false;
                },
                tooltip: 'Close',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
