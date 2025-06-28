import 'package:flutter/material.dart';
import 'dart:math';
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
  List<String> letters = [];

  @override
  void initState() {
    super.initState();
    _generateLetters();
  }

  void _generateLetters() {
    final random = Random();
    final word = widget.vocabulary.word.toLowerCase().replaceAll(RegExp(r'[^a-z]'), '');
    letters = word.split('');
    const String alphabet = 'abcdefghijklmnopqrstuvwxyz';
    while (letters.length < 12) {
      final randomLetter = alphabet[random.nextInt(alphabet.length)];
      if (!letters.contains(randomLetter)) {
        letters.add(randomLetter);
      }
    }
    letters.shuffle();
  }

  void _addLetter(String letter) {
    setState(() {
      _controller.text += letter;
      isCorrect = null;
    });
  }

  void _removeLastLetter() {
    setState(() {
      if (_controller.text.isNotEmpty) {
        _controller.text = _controller.text.substring(
          0,
          _controller.text.length - 1,
        );
        isCorrect = null; 
      }
    });
  }

  void _checkAnswer() {
    setState(() {
      isCorrect =
          _controller.text.trim().toLowerCase() ==
          widget.vocabulary.word.toLowerCase();
    });
  }

  void _resetState() {
    setState(() {
      _controller.clear();
      isCorrect = null;
      _generateLetters();
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
          child: Text(
            widget.correctMeaning.meaning,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 24),
        TextField(
          controller: _controller,
          readOnly: true, // Ngăn nhập từ bàn phím
          decoration: InputDecoration(
            hintText: 'Chọn chữ cái để ghép từ',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color:
                    isCorrect == null
                        ? Theme.of(context).colorScheme.primary.withOpacity(0.4)
                        : (isCorrect == true ? Colors.green : Colors.red),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color:
                    isCorrect == null
                        ? Theme.of(context).colorScheme.primary.withOpacity(0.4)
                        : (isCorrect == true ? Colors.green : Colors.red),
                width: 2,
              ),
            ),
            filled: true,
            fillColor: Colors.grey[100],
            errorText:
                isCorrect == false
                    ? 'Sai! Đáp án đúng: ${widget.vocabulary.word}'
                    : null,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          alignment: WrapAlignment.center,
          children:
              letters
                  .map(
                    (letter) => SizedBox(
                      width: 40,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () => _addLetter(letter),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primary.withOpacity(0.4),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          letter.toUpperCase(),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  )
                  .toList()
                ..add(
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: _removeLastLetter,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[400],
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Icon(Icons.backspace, size: 16),
                    ),
                  ),
                ),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: _checkAnswer,
          style: ElevatedButton.styleFrom(
            backgroundColor:
                isCorrect == null
                    ? Theme.of(context).colorScheme.primary.withOpacity(0.4)
                    : (isCorrect == true ? Colors.green : Colors.red),
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: isCorrect != null ? 6 : 2,
          ),
          child: const Text('Kiểm tra', style: TextStyle(fontSize: 16)),
        ),
        if (isCorrect != null)
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: ElevatedButton(
              onPressed: () {
                widget.onNext(isCorrect: isCorrect ?? false);
                _resetState();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
              ),
              child: const Text('Tiếp theo', style: TextStyle(fontSize: 16)),
            ),
          ),
      ],
    );
  }
}
