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
    final availableVocabs =
        widget.vocabularies.where((v) => v != widget.vocabulary).toList();
    while (options.length < 4 && availableVocabs.isNotEmpty) {
      final randomVocab =
          availableVocabs[random.nextInt(availableVocabs.length)];
      if (!options.contains(randomVocab.word)) {
        options.add(randomVocab.word);
        availableVocabs.remove(randomVocab);
      }
    }
    // Nếu không đủ 4 options, thêm option giả
    while (options.length < 4) {
      options.add('Word ${options.length + 1}');
    }
    options.shuffle();
  }

  void _checkAnswer(String selected) {
    setState(() {
      selectedOption = selected;
      isCorrect = selected == widget.vocabulary.word;
    });
  }

  void _resetState() {
    setState(() {
      selectedOption = null;
      isCorrect = null;
      _generateOptions();
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
        ...options.map(
          (option) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ElevatedButton(
              onPressed: () => _checkAnswer(option),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    selectedOption != null
                        ? (option == widget.vocabulary.word
                            ? Colors
                                .green // Đáp án đúng: xanh
                            : (selectedOption == option && isCorrect == false
                                ? Colors.red
                                : Theme.of(
                                  context,
                                ).colorScheme.primary.withOpacity(0.5)))
                        : Theme.of(
                          context,
                        ).colorScheme.primary.withOpacity(0.4),
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
        const SizedBox(height: 16),
        if (selectedOption != null)
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: ElevatedButton(
              onPressed: () {
                widget.onNext(isCorrect: isCorrect ?? false);
                _resetState();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
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
