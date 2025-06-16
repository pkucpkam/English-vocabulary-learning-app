import 'package:flutter/material.dart';

class VietnameseToEnglishInputWidget extends StatefulWidget {
  final String meaning;
  final String correctWord;
  final VoidCallback onNext;

  const VietnameseToEnglishInputWidget({
    super.key,
    required this.meaning,
    required this.correctWord,
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
          widget.correctWord.toLowerCase();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 164.0,
              vertical: 128.0,
            ),
            child: Text(
              widget.meaning,
              style: const TextStyle(fontSize: 32),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const SizedBox(height: 24),
        TextField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: 'Enter the English word',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: Colors.grey[100],
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: isCorrect == null ? _checkAnswer : null,
          style: ElevatedButton.styleFrom(
            backgroundColor:
                isCorrect == null
                    ? Colors.blue
                    : (isCorrect! ? Colors.green : Colors.red),
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text('Check', style: TextStyle(fontSize: 16)),
        ),
        const SizedBox(height: 16),
        if (isCorrect != null)
          ElevatedButton(
            onPressed: widget.onNext,
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
      ],
    );
  }
}
