import 'dart:typed_data';
import 'package:quotemytrade/core/models/estimation.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final Uint8List? imageBytes;
  final Estimation? estimation;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.imageBytes,
    this.estimation,
  });
}
