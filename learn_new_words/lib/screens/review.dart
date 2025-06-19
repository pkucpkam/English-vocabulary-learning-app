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
      _randomizeReviewType();
    });
  }

  void _randomizeReviewType() {
    setState(() {
      reviewType = random.nextInt(4); // Random từ 0 đến 3
    });
  }

  void _nextQuestion() {
    setState(() {
      if (currentIndex < dayVocabularies.length - 1) {
        currentIndex++;
        _randomizeReviewType();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã ôn tập hết từ của ngày này!')),
        );
        currentIndex = 0;
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

    Widget reviewWidget;
    // Chuyển Vocabulary thành Map để tương thích với widget con
    final vocabMap =
        dayVocabularies
            .map(
              (vocab) => {
                'word': vocab.word,
                'meaning': vocab.meanings.isNotEmpty ? vocab.meanings[0] : '',
              },
            )
            .toList();

    switch (reviewType) {
      case 0:
        reviewWidget = EnglishToVietnameseWidget(
          word: dayVocabularies[currentIndex].word,
          correctMeaning:
              dayVocabularies[currentIndex].meanings.isNotEmpty
                  ? dayVocabularies[currentIndex].meanings[0]
                  : '',
          vocabulary: vocabMap,
          onNext: _nextQuestion,
        );
        break;
      case 1:
        reviewWidget = VietnameseToEnglishWidget(
          meaning:
              dayVocabularies[currentIndex].meanings.isNotEmpty
                  ? dayVocabularies[currentIndex].meanings[0]
                  : '',
          correctWord: dayVocabularies[currentIndex].word,
          vocabulary: vocabMap,
          onNext: _nextQuestion,
        );
        break;
      case 2:
        reviewWidget = VietnameseToEnglishInputWidget(
          meaning:
              dayVocabularies[currentIndex].meanings.isNotEmpty
                  ? dayVocabularies[currentIndex].meanings[0]
                  : '',
          correctWord: dayVocabularies[currentIndex].word,
          onNext: _nextQuestion,
        );
        break;
      case 3:
        reviewWidget = MatchingWidget(
          vocabulary: vocabMap,
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
