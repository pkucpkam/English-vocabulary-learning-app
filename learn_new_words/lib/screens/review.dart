import 'package:flutter/material.dart';
import 'dart:math';

import 'package:learn_new_words/widgets/english_to_vietnamese_widget.dart';
import 'package:learn_new_words/widgets/matching_widget.dart';
import 'package:learn_new_words/widgets/vietnamese_to_english_input_widget.dart';
import 'package:learn_new_words/widgets/vietnamese_to_english_widget.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({super.key});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  final List<Map<String, String>> vocabulary = [
    {'word': 'Apple', 'meaning': 'Quả táo'},
    {'word': 'Book', 'meaning': 'Cuốn sách'},
    {'word': 'Cat', 'meaning': 'Con mèo'},
    {'word': 'Dog', 'meaning': 'Con chó'},
  ];
  int currentIndex = 0;
  int reviewType =
      0; // 0: Eng->Viet, 1: Viet->Eng, 2: Viet->Eng Input, 3: Matching
  final Random random = Random();

  @override
  void initState() {
    super.initState();
    _randomizeReviewType();
  }

  void _randomizeReviewType() {
    setState(() {
      reviewType = 3; // Random từ 0 đến 3
      // reviewType = random.nextInt(4); // Random từ 0 đến 3
    });
  }

  void _nextQuestion() {
    setState(() {
      if (currentIndex < vocabulary.length - 1) {
        currentIndex++;
        _randomizeReviewType();
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Đã ôn tập hết từ!')));
        currentIndex = 0;
        _randomizeReviewType();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget reviewWidget;
    switch (reviewType) {
      case 0:
        reviewWidget = EnglishToVietnameseWidget(
          word: vocabulary[currentIndex]['word']!,
          correctMeaning: vocabulary[currentIndex]['meaning']!,
          vocabulary: vocabulary,
          onNext: _nextQuestion,
        );
        break;
      case 1:
        reviewWidget = VietnameseToEnglishWidget(
          meaning: vocabulary[currentIndex]['meaning']!,
          correctWord: vocabulary[currentIndex]['word']!,
          vocabulary: vocabulary,
          onNext: _nextQuestion,
        );
        break;
      case 2:
        reviewWidget = VietnameseToEnglishInputWidget(
          meaning: vocabulary[currentIndex]['meaning']!,
          correctWord: vocabulary[currentIndex]['word']!,
          onNext: _nextQuestion,
        );
        break;
      case 3:
        reviewWidget = MatchingWidget(
          vocabulary: vocabulary,
          onComplete: _nextQuestion,
        );
        break;
      default:
        reviewWidget = const SizedBox.shrink();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Review'),
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
