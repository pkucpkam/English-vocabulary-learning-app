import 'package:flutter/material.dart';
import 'dart:math';
import '../models/vocab.dart';
import '../services/data_service.dart';
import '../widgets/english_to_vietnamese_widget.dart';
import '../widgets/matching_widget.dart';
import '../widgets/vietnamese_to_english_input_widget.dart';
import '../widgets/vietnamese_to_english_widget.dart';
import 'summary_page.dart';

class TestPage extends StatefulWidget {
  final DateTime selectedDay;

  const TestPage({super.key, required this.selectedDay});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  List<Vocabulary> dayVocabularies = [];
  List<Vocabulary> incorrectWords = [];
  int currentIndex = 0;
  int reviewType = 0;
  bool isLoading = true;
  final Random random = Random();

  @override
  void initState() {
    super.initState();
    _loadDayVocabularies();
  }

  Future<void> _loadDayVocabularies() async {
    setState(() => isLoading = true);
    final vocabList = await DataService.getLearnedVocabularies();
    final dayVocabs =
        vocabList
            .where(
              (vocab) =>
                  vocab.learnedDate != null &&
                  vocab.learnedDate!.year == widget.selectedDay.year &&
                  vocab.learnedDate!.month == widget.selectedDay.month &&
                  vocab.learnedDate!.day == widget.selectedDay.day,
            )
            .toList();

    setState(() {
      dayVocabularies = dayVocabs;
      isLoading = false;
      if (dayVocabularies.isNotEmpty) _randomizeReviewType();
    });
  }

  void _randomizeReviewType() {
    setState(() => reviewType = random.nextInt(4));
  }

  void _nextQuestion({bool isCorrect = false}) {
    final currentVocab = dayVocabularies[currentIndex];
    if (!isCorrect && !incorrectWords.contains(currentVocab)) {
      incorrectWords.add(currentVocab);
    }

    if (currentIndex < dayVocabularies.length - 1) {
      setState(() {
        currentIndex++;
        _randomizeReviewType();
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (context) => SummaryPage(
                incorrectWords: incorrectWords,
                total: dayVocabularies.length,
              ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (dayVocabularies.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('Không có từ vựng nào để kiểm tra!')),
      );
    }

    final currentVocab = dayVocabularies[currentIndex];
    final selectedMeaning =
        currentVocab.meanings.isNotEmpty
            ? currentVocab.meanings[random.nextInt(
              currentVocab.meanings.length,
            )]
            : Meaning(meaning: '', example: '');

    Widget reviewWidget;
    switch (reviewType) {
      case 0:
        reviewWidget = EnglishToVietnameseWidget(
          vocabulary: currentVocab,
          correctMeaning: selectedMeaning,
          vocabularies: dayVocabularies,
          onNext: _nextQuestion,
        );
        break;
      case 1:
        reviewWidget = VietnameseToEnglishWidget(
          vocabulary: currentVocab,
          correctMeaning: selectedMeaning,
          vocabularies: dayVocabularies,
          onNext: _nextQuestion,
        );
        break;
      case 2:
        reviewWidget = VietnameseToEnglishInputWidget(
          vocabulary: currentVocab,
          correctMeaning: selectedMeaning,
          onNext: _nextQuestion,
        );
        break;
      case 3:
        reviewWidget = MatchingWidget(
          vocabularies: dayVocabularies,
          onComplete: _nextQuestion,
        );
        break;
      default:
        reviewWidget = const SizedBox.shrink();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Kiểm tra từ vựng'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Text(
                '${currentIndex + 1}/${dayVocabularies.length}',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(padding: const EdgeInsets.all(16.0), child: reviewWidget),
    );
  }
}
