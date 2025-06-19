import 'package:flutter/material.dart';
import 'package:learn_new_words/screens/learned_words_page.dart';
import 'package:learn_new_words/screens/review.dart';
import '../services/data_service.dart';
import 'package:intl/intl.dart';

class DailyVocabularyProgressPage extends StatefulWidget {
  const DailyVocabularyProgressPage({super.key});

  @override
  State<DailyVocabularyProgressPage> createState() =>
      _DailyVocabularyProgressPageState();
}

class _DailyVocabularyProgressPageState
    extends State<DailyVocabularyProgressPage> {
  List<DateTime> learnedDays = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLearnedDays();
  }

  Future<void> _loadLearnedDays() async {
    setState(() {
      isLoading = true;
    });
    final vocabList = await DataService.getLearnedVocabularies();
    final days =
        vocabList
            .where((vocab) => vocab.learnedDate != null)
            .map(
              (vocab) => DateTime(
                vocab.learnedDate!.year,
                vocab.learnedDate!.month,
                vocab.learnedDate!.day,
              ),
            )
            .toSet()
            .toList()
          ..sort((a, b) => b.compareTo(a)); // Sắp xếp từ mới nhất đến cũ nhất
    setState(() {
      learnedDays = days;
      isLoading = false;
    });
  }

  void _showDayDetails(BuildContext context, DateTime day) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LearnedWordsPage(selectedDay: day),
      ),
    );
  }

  void _goToReview(BuildContext context, DateTime day) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ReviewPage(selectedDay: day)),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Study progress'), centerTitle: true),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (learnedDays.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Study progress'), centerTitle: true),
        body: const Center(child: Text('Haven\'t studied a day yet')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Study progress'), centerTitle: true),
      body: ListView.builder(
        itemCount: learnedDays.length,
        itemBuilder: (context, index) {
          final day = learnedDays[index];
          final formattedDate = DateFormat('dd/MM/yyyy').format(day);
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              title: Text('Day $formattedDate'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.list, color: Colors.blue),
                    onPressed: () => _showDayDetails(context, day),
                    tooltip: 'Show details',
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh, color: Colors.orange),
                    onPressed: () => _goToReview(context, day),
                    tooltip: 'Review words',
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
