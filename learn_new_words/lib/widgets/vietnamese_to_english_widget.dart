import 'package:flutter/material.dart';
import 'dart:math';
import '../models/vocab.dart';

class VietnameseToEnglishWidget extends StatefulWidget {
  final Vocabulary vocabulary;
  final Meaning correctMeaning;
  final List<Vocabulary> vocabularies;
  final Function({bool isCorrect}) onNext;

  const VietnameseToEnglishWidget({
    super.key,
    required this.vocabulary,
    required this.correctMeaning,
    required this.vocabularies,
    required this.onNext,
  });

  @override
  State<VietnameseToEnglishWidget> createState() =>
      _VietnameseToEnglishWidgetState();
}

class _VietnameseToEnglishWidgetState extends State<VietnameseToEnglishWidget> {
  List<String> options = [];
  String? selectedOption;
  bool? isCorrect;

  @override
  void initState() {
    super.initState();
    _generateOptions();
  }

  void _generateOptions() {
    final random = Random();
    options = [widget.vocabulary.word];
    while (options.length < 4 && widget.vocabularies.length > 1) {
      final randomVocab =
          widget.vocabularies[random.nextInt(widget.vocabularies.length)];
      if (randomVocab.word != widget.vocabulary.word &&
          !options.contains(randomVocab.word)) {
        options.add(randomVocab.word);
      }
    }
    options.shuffle();
  }

  void _checkAnswer(String selected) {
    setState(() {
      selectedOption = selected;
      isCorrect = selected == widget.vocabulary.word;
    });
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
              if (widget.vocabulary.pronunciation_uk != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    '/${widget.vocabulary.pronunciation_uk}/',
                    style: TextStyle(
                      fontSize: 20,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey[700],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        ...options.map(
          (option) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ElevatedButton(
              onPressed: () => _checkAnswer(option),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    selectedOption == option
                        ? (isCorrect == true ? Colors.green : Colors.red)
                        : Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(option, style: const TextStyle(fontSize: 16)),
            ),
          ),
        ),
        if (selectedOption != null)
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
