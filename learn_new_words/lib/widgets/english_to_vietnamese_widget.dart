import 'package:flutter/material.dart';
import 'dart:math';

class EnglishToVietnameseWidget extends StatefulWidget {
  final String word;
  final String correctMeaning;
  final List<Map<String, String>> vocabulary;
  final VoidCallback onNext;

  const EnglishToVietnameseWidget({
    super.key,
    required this.word,
    required this.correctMeaning,
    required this.vocabulary,
    required this.onNext,
  });

  @override
  State<EnglishToVietnameseWidget> createState() =>
      _EnglishToVietnameseWidgetState();
}

class _EnglishToVietnameseWidgetState extends State<EnglishToVietnameseWidget> {
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
    options = [widget.correctMeaning];
    while (options.length < 4) {
      final randomIndex = random.nextInt(widget.vocabulary.length);
      final option = widget.vocabulary[randomIndex]['meaning']!;
      if (!options.contains(option)) {
        options.add(option);
      }
    }
    options.shuffle();
  }

  void _checkAnswer(String selected) {
    setState(() {
      selectedOption = selected;
      isCorrect = selected == widget.correctMeaning;
    });
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
              widget.word,
              style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const SizedBox(height: 24),
        Column(
          children:
              options.map((option) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ElevatedButton(
                    onPressed:
                        selectedOption == null
                            ? () => _checkAnswer(option)
                            : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          selectedOption == option
                              ? (isCorrect == true ? Colors.green : Colors.red)
                              : Colors.blue,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(option, style: const TextStyle(fontSize: 16)),
                  ),
                );
              }).toList(),
        ),
        const SizedBox(height: 24),
        if (selectedOption != null)
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
