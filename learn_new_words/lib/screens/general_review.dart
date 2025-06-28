import 'package:flutter/material.dart';
import 'dart:math';
import '../models/vocab.dart';
import '../services/data_service.dart';
import '../widgets/english_to_vietnamese_widget.dart';
import '../widgets/matching_widget.dart';
import '../widgets/vietnamese_to_english_input_widget.dart';
import '../widgets/vietnamese_to_english_widget.dart';

class GeneralReviewPage extends StatefulWidget {
  const GeneralReviewPage({super.key});

  @override
  State<GeneralReviewPage> createState() => _GeneralReviewPageState();
}

class _GeneralReviewPageState extends State<GeneralReviewPage> {
  List<Vocabulary> learnedVocabularies = [];
  int currentIndex = 0;
  int reviewType = 0;
  int correctAnswers = 0;
  bool isLoading = true;
  final Random random = Random();

  @override
  void initState() {
    super.initState();
    _loadLearnedVocabularies();
  }

  Future<void> _loadLearnedVocabularies() async {
    setState(() {
      isLoading = true;
    });
    final vocabList = await DataService.getLearnedVocabularies();
    setState(() {
      learnedVocabularies = vocabList;
      isLoading = false;
      if (learnedVocabularies.isNotEmpty) _randomizeReviewType();
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
      if (currentIndex < learnedVocabularies.length - 1) {
        currentIndex++;
        _randomizeReviewType();
      } else {
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
          title: const Text('Ôn tập từ vựng'),
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (learnedVocabularies.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Ôn tập từ vựng'),
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Center(
              child: Text(
                'Chưa có từ vựng để ôn tập!',
                style: TextStyle(fontSize: 24),
              ),
            ),
            const SizedBox(height: 24),
            const Center(
              child: Text(
                'Hãy học từ mới để bắt đầu!',
                style: TextStyle(fontSize: 24),
              ),
            ),
            const SizedBox(height: 24),
            const Icon(
              Icons.psychology_alt_rounded,
              size: 128,
              color: Colors.grey,
            ),
          ],
        ),
      );
    }

    final currentVocab = learnedVocabularies[currentIndex];
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
          vocabularies: learnedVocabularies,
          onNext: _nextQuestion,
        );
        break;
      case 1:
        reviewWidget = VietnameseToEnglishWidget(
          vocabulary: currentVocab,
          correctMeaning: selectedMeaning,
          vocabularies: learnedVocabularies,
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
          vocabularies: learnedVocabularies,
          onComplete: _nextQuestion,
        );
        break;
      default:
        reviewWidget = const SizedBox.shrink();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ôn tập tổng quát'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
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
