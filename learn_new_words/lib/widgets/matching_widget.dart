import 'package:flutter/material.dart';
import 'dart:math';
import '../models/vocab.dart';

class MatchingWidget extends StatefulWidget {
  final List<Vocabulary> vocabularies;
  final Function({bool isCorrect}) onComplete;

  const MatchingWidget({
    super.key,
    required this.vocabularies,
    required this.onComplete,
  });

  @override
  State<MatchingWidget> createState() => _MatchingWidgetState();
}

class _MatchingWidgetState extends State<MatchingWidget> {
  List<Map<String, dynamic>> pairs = [];
  String? selectedWord;
  String? selectedMeaning;
  List<Map<String, String>> matchedPairs = [];
  Set<String> incorrectWords = {};
  Set<String> incorrectMeanings = {};
  bool gameCompleted = false;
  bool isChecking = false;

  @override
  void initState() {
    super.initState();
    _resetGame();
  }

  void _resetGame() {
    final random = Random();
    final allPairs =
        widget.vocabularies
            .where((v) => v.meanings.isNotEmpty)
            .map(
              (v) => {
                'word': v.word,
                'meaning':
                    v.meanings[random.nextInt(v.meanings.length)].meaning,
              },
            )
            .toList();

    allPairs.shuffle();
    pairs = allPairs.take(4).toList();

    matchedPairs.clear();
    incorrectWords.clear();
    incorrectMeanings.clear();
    selectedWord = null;
    selectedMeaning = null;
    gameCompleted = false;
  }

  void _selectWord(String word) {
    if (selectedWord == word || gameCompleted) return;
    setState(() {
      selectedWord = word;
    });
    _checkMatch();
  }

  void _selectMeaning(String meaning) {
    if (selectedMeaning == meaning || gameCompleted) return;
    setState(() {
      selectedMeaning = meaning;
    });
    _checkMatch();
  }

  void _checkMatch() {
    if (selectedWord != null && selectedMeaning != null && !isChecking) {
      final isCorrect = pairs.any(
        (pair) =>
            pair['word'] == selectedWord && pair['meaning'] == selectedMeaning,
      );

      if (isCorrect) {
        setState(() {
          matchedPairs.add({
            'word': selectedWord!,
            'meaning': selectedMeaning!,
          });
          selectedWord = null;
          selectedMeaning = null;
        });

        if (matchedPairs.length == pairs.length) {
          Future.delayed(const Duration(milliseconds: 300), () {
            setState(() {
              gameCompleted = true;
            });
          });
        }
      } else {
        setState(() {
          isChecking = true; // 👉 Chặn click khi đang xử lý sai
          incorrectWords.add(selectedWord!);
          incorrectMeanings.add(selectedMeaning!);
        });

        Future.delayed(const Duration(seconds: 1), () {
          setState(() {
            incorrectWords.remove(selectedWord!);
            incorrectMeanings.remove(selectedMeaning!);
            selectedWord = null;
            selectedMeaning = null;
            isChecking = false; // 👉 Mở lại tương tác
          });
        });
      }
    }
  }

  Color _getCardColor(String text, bool isWord) {
    if ((isWord && incorrectWords.contains(text)) ||
        (!isWord && incorrectMeanings.contains(text))) {
      return Colors.red[200]!;
    }

    final isSelected =
        (isWord && selectedWord == text) ||
        (!isWord && selectedMeaning == text);
    if (isSelected) return Colors.blue[200]!;

    final isMatched = matchedPairs.any(
      (p) => (isWord && p['word'] == text) || (!isWord && p['meaning'] == text),
    );
    if (isMatched) return Colors.green[200]!;

    return Colors.white;
  }

  bool _isDisabled(String text, bool isWord) {
    return matchedPairs.any(
      (p) => (isWord && p['word'] == text) || (!isWord && p['meaning'] == text),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            '🎯 Ghép từ với nghĩa',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: [
              // Render riêng các từ
              ...pairs.map((pair) => pair['word'] as String).toSet().map((
                word,
              ) {
                return GestureDetector(
                  onTap:
                      (_isDisabled(word, true) || isChecking) ? null : () => _selectWord(word),
                  child: Card(
                    color: _getCardColor(word, true),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: SizedBox(
                      width: 160,
                      height: 70,
                      child: Center(
                        child: Text(
                          word,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                );
              }),

              ...pairs.map((pair) => pair['meaning'] as String).toSet().map((
                meaning,
              ) {
                return GestureDetector(
                  onTap:
                      (_isDisabled(meaning, false) || isChecking) ? null : () => _selectMeaning(meaning),
                  child: Card(
                    color: _getCardColor(meaning, false),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: SizedBox(
                      width: 160,
                      height: 70,
                      child: Center(
                        child: Text(
                          meaning,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),

          const SizedBox(height: 24),

          // Nút tiếp theo khi hoàn thành
          if (gameCompleted)
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  widget.onComplete(isCorrect: true);
                  _resetGame();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
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
      ),
    );
  }
}
