import 'package:flutter/material.dart';
import '../models/vocab.dart';

class VietnameseToEnglishInputWidget extends StatefulWidget {
  final Vocabulary vocabulary;
  final Meaning correctMeaning;
  final Function({bool isCorrect}) onNext;

  const VietnameseToEnglishInputWidget({
    super.key,
    required this.vocabulary,
    required this.correctMeaning,
    required this.onNext,
  });

  @override
  State<VietnameseToEnglishInputWidget> createState() =>
      _VietnameseToEnglishInputWidgetState();
}

class _VietnameseToEnglishInputWidgetState
    extends State<VietnameseToEnglishInputWidget> {
  final TextEditingController _controller = TextEditingController();
  bool? isCorrect;

  void _checkAnswer() {
    setState(() {
      isCorrect =
          _controller.text.trim().toLowerCase() ==
          widget.vocabulary.word.toLowerCase();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardSize = screenWidth * 0.85;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: cardSize,
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
            ),
          ),
          child: Column(
            children: [
              Text(
                widget.correctMeaning.meaning,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        TextField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: 'Nhập từ tiếng Anh',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: Colors.grey[100],
            errorText: isCorrect == false ? 'Sai! Thử lại.' : null,
          ),
          textAlign: TextAlign.center,
          onSubmitted: (_) => _checkAnswer(),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: _checkAnswer,
          style: ElevatedButton.styleFrom(
            backgroundColor:
                isCorrect == null
                    ? Theme.of(context).colorScheme.primary
                    : Colors.green,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text('Kiểm tra', style: TextStyle(fontSize: 16)),
        ),
        if (isCorrect != null)
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: ElevatedButton(
              onPressed: () => widget.onNext(isCorrect: isCorrect ?? false),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Tiếp theo', style: TextStyle(fontSize: 16)),
            ),
          ),
      ],
    );
  }
}
