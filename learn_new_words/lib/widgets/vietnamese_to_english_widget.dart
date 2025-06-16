import 'package:flutter/material.dart';
import 'dart:math';

class VietnameseToEnglishWidget extends StatefulWidget {
  final String meaning;
  final String correctWord;
  final List<Map<String, String>> vocabulary;
  final VoidCallback onNext;

  const VietnameseToEnglishWidget({
    super.key,
    required this.meaning,
    required this.correctWord,
    required this.vocabulary,
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
    options = [widget.correctWord];
    while (options.length < 4) {
      final randomIndex = random.nextInt(widget.vocabulary.length);
      final option = widget.vocabulary[randomIndex]['word']!;
      if (!options.contains(option)) {
        options.add(option);
      }
    }
    options.shuffle();
  }

  void _checkAnswer(String selected) {
    setState(() {
      selectedOption = selected;
      isCorrect = selected == widget.correctWord;
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
          child: Container(
            width:
                MediaQuery.of(context).size.width *
                0.9, // Chiếm 90% chiều ngang màn hình
            padding: const EdgeInsets.all(32.0),
            child: Text(
              widget.meaning,
              style: const TextStyle(fontSize: 32),
              textAlign: TextAlign.center,
              softWrap: true,
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
