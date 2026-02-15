import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:quotemytrade/core/providers/chat_provider.dart';
import 'package:quotemytrade/theme/app_colors.dart';

class ChatInputWidget extends ConsumerWidget {
  final bool isDisabled;

  const ChatInputWidget({super.key, this.isDisabled = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(chatTextControllerProvider);
    final isLoading = ref.watch(isLoadingProvider);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.add_photo_alternate,
              color: AppColors.primary,
            ),
            onPressed: isDisabled ? null : () => _pickImage(ref),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              enabled: !isDisabled,
              decoration: InputDecoration(
                hintText: 'Describe the work...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
              maxLines: null,
              onSubmitted: (_) => _sendMessage(ref),
            ),
          ),
          const SizedBox(width: 8),
          FloatingActionButton(
            onPressed: isDisabled ? null : () => _sendMessage(ref),
            backgroundColor: AppColors.primary,
            mini: true,
            child: const Icon(Icons.send, color: Colors.white),
          ),
        ],
      ),
    );
  }

  void _sendMessage(WidgetRef ref) {
    final controller = ref.read(chatTextControllerProvider);
    final text = controller.text.trim();

    if (text.isEmpty) return;

    controller.clear();
    ref.read(chatMessagesProvider.notifier).sendTextMessage(text);
  }

  Future<void> _pickImage(WidgetRef ref) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );

    if (result != null && result.files.isNotEmpty) {
      final imageBytes = result.files.first.bytes;
      if (imageBytes != null) {
        ref.read(chatMessagesProvider.notifier).sendImageMessage(imageBytes);
      }
    }
  }
}
