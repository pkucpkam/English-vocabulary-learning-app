import 'package:flutter/material.dart';
import 'dart:math';
import 'package:intl/intl.dart';
import '../models/vocab.dart';
import '../services/data_service.dart';
import '../widgets/english_to_vietnamese_widget.dart';
import '../widgets/matching_widget.dart';
import '../widgets/vietnamese_to_english_input_widget.dart';
import '../widgets/vietnamese_to_english_widget.dart';

class ReviewPage extends StatefulWidget {
  final DateTime selectedDay;

  const ReviewPage({super.key, required this.selectedDay});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  List<Vocabulary> dayVocabularies = [];
  int currentIndex = 0;
  int reviewType =
      0; // 0: Eng->Viet, 1: Viet->Eng, 2: Viet->Eng Input, 3: Matching
  int correctAnswers = 0;
  bool isLoading = true;
  final Random random = Random();

  @override
  void initState() {
    super.initState();
    _loadDayVocabularies();
  }

  Future<void> _loadDayVocabularies() async {
    setState(() {
      isLoading = true;
    });
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
    setState(() {
      reviewType = random.nextInt(4);
    });
  }

  void _nextQuestion({bool isCorrect = false}) {
    setState(() {
      if (isCorrect) correctAnswers++;
      if (currentIndex < dayVocabularies.length - 1) {
        currentIndex++;
        _randomizeReviewType();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Hoàn thành ôn tập! Đúng: $correctAnswers/${dayVocabularies.length}',
            ),
          ),
        );
        currentIndex = 0;
        correctAnswers = 0;
        _randomizeReviewType();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Ôn tập ngày ${DateFormat('dd/MM/yyyy').format(widget.selectedDay)}',
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          centerTitle: true,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (dayVocabularies.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Ôn tập ngày ${DateFormat('dd/MM/yyyy').format(widget.selectedDay)}',
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          centerTitle: true,
        ),
        body: const Center(child: Text('Không có từ vựng nào để ôn tập!')),
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
        title: Text(
          'Ôn tập ngày ${DateFormat('dd/MM/yyyy').format(widget.selectedDay)}',
        ),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: reviewWidget,
        ),
      ),
    );
  }
}
