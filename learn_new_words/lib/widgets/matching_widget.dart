import 'dart:math';

import 'package:flutter/material.dart';

class MatchingWidget extends StatefulWidget {
  final List<Map<String, String>> vocabulary;
  final VoidCallback onComplete;

  const MatchingWidget({
    super.key,
    required this.vocabulary,
    required this.onComplete,
  });

  @override
  State<MatchingWidget> createState() => _MatchingWidgetState();
}

class _MatchingWidgetState extends State<MatchingWidget> {
  List<String> words = [];
  List<String> meanings = [];
  String? selectedWord;
  String? selectedMeaning;
  List<Map<String, String>> matchedPairs = [];

  @override
  void initState() {
    super.initState();
    _resetGame();
  }

  void _resetGame() {
    words = widget.vocabulary.map((e) => e['word']!).toList()..shuffle();
    meanings = widget.vocabulary.map((e) => e['meaning']!).toList()..shuffle();
    matchedPairs.clear();
    selectedWord = null;
    selectedMeaning = null;
  }

  void _selectWord(String word) {
    setState(() {
      selectedWord = word;
      _checkMatch();
    });
  }

  void _selectMeaning(String meaning) {
    setState(() {
      selectedMeaning = meaning;
      _checkMatch();
    });
  }

  void _checkMatch() {
    if (selectedWord != null && selectedMeaning != null) {
      final pair = widget.vocabulary.firstWhere(
        (element) =>
            element['word'] == selectedWord &&
            element['meaning'] == selectedMeaning,
        orElse: () => {},
      );
      if (pair.isNotEmpty) {
        matchedPairs.add({'word': selectedWord!, 'meaning': selectedMeaning!});
        words.remove(selectedWord);
        meanings.remove(selectedMeaning);
        if (matchedPairs.length == widget.vocabulary.length) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Hoàn thành!')));
          Future.delayed(const Duration(seconds: 1), widget.onComplete);
        }
      }
      selectedWord = null;
      selectedMeaning = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Tính số lượng lớn nhất giữa words và meanings
    final int maxLength = max(words.length, meanings.length);

    // Bổ sung các ô trống nếu cần để cân bằng 2 cột
    final List<String?> paddedWords = List<String?>.from(words)
      ..addAll(List.filled(maxLength - words.length, null));
    final List<String?> paddedMeanings = List<String?>.from(meanings)
      ..addAll(List.filled(maxLength - meanings.length, null));

    return Row(
      children: [
        // CỘT TỪ VỰNG
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(maxLength, (index) {
              final word = paddedWords[index];
              final isMatched = matchedPairs.any(
                (pair) => pair['word'] == word,
              );

              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 6.0,
                  horizontal: 8.0,
                ),
                child: SizedBox(
                  height: 100,
                  child:
                      word == null
                          ? const SizedBox.shrink()
                          : GestureDetector(
                            onTap: isMatched ? null : () => _selectWord(word),
                            child: Card(
                              elevation: 4,
                              color:
                                  selectedWord == word
                                      ? Colors.blue[100]
                                      : Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Text(
                                    word,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ),
                ),
              );
            }),
          ),
        ),

        // CỘT NGHĨA
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(maxLength, (index) {
              final meaning = paddedMeanings[index];
              final isMatched = matchedPairs.any(
                (pair) => pair['meaning'] == meaning,
              );

              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 6.0,
                  horizontal: 8.0,
                ),
                child: SizedBox(
                  height: 100,
                  child:
                      meaning == null
                          ? const SizedBox.shrink()
                          : GestureDetector(
                            onTap:
                                isMatched
                                    ? null
                                    : () => _selectMeaning(meaning),
                            child: Card(
                              elevation: 4,
                              color:
                                  selectedMeaning == meaning
                                      ? Colors.blue[100]
                                      : Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Text(
                                    meaning,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
