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

  @override
  void initState() {
    super.initState();
    _resetGame();
  }

  void _resetGame() {
    final random = Random();
    pairs =
        widget.vocabularies
            .where((v) => v.meanings.isNotEmpty)
            .map(
              (v) => {
                'word': v.word,
                'meaning':
                    v.meanings[random.nextInt(v.meanings.length)].meaning,
              },
            )
            .toList()
          ..shuffle();
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
      final pair = pairs.firstWhere(
        (element) =>
            element['word'] == selectedWord &&
            element['meaning'] == selectedMeaning,
        orElse: () => {},
      );
      if (pair.isNotEmpty) {
        matchedPairs.add({'word': selectedWord!, 'meaning': selectedMeaning!});
        pairs.removeWhere(
          (element) =>
              element['word'] == selectedWord ||
              element['meaning'] == selectedMeaning,
        );
        if (pairs.isEmpty) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Hoàn thành!')));
          Future.delayed(
            const Duration(seconds: 1),
            () => widget.onComplete(isCorrect: true),
          );
        }
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Sai! Thử lại.')));
      }
      selectedWord = null;
      selectedMeaning = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Ghép từ với nghĩa',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          alignment: WrapAlignment.center,
          children: [
            ...pairs.map((pair) {
              final word = pair['word'] as String;
              final isMatched = matchedPairs.any((p) => p['word'] == word);
              return SizedBox(
                width: 150,
                height: 80,
                child: GestureDetector(
                  onTap: isMatched ? null : () => _selectWord(word),
                  child: Card(
                    elevation: 4,
                    color:
                        selectedWord == word ? Colors.blue[100] : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          word,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
            ...pairs.map((pair) {
              final meaning = pair['meaning'] as String;
              final isMatched = matchedPairs.any(
                (p) => p['meaning'] == meaning,
              );
              return SizedBox(
                width: 150,
                height: 80,
                child: GestureDetector(
                  onTap: isMatched ? null : () => _selectMeaning(meaning),
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
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          meaning,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ],
    );
  }
}
