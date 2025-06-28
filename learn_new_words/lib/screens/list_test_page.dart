import 'package:flutter/material.dart';
import 'package:learn_new_words/screens/learned_words_page.dart';
import 'package:learn_new_words/screens/test_page.dart';
import '../services/data_service.dart';
import 'package:intl/intl.dart';

class ListTestPage extends StatefulWidget {
  const ListTestPage({super.key});

  @override
  State<ListTestPage> createState() => _ListTestPageState();
}

class _ListTestPageState extends State<ListTestPage> {
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
          ..sort((a, b) => b.compareTo(a));
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

  void _goToTest(BuildContext context, DateTime day) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TestPage(selectedDay: day)),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Quá trình học'),
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (learnedDays.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Quá trình học'),
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Center(
              child: Text(
                'Bạn chưa học ngày nào!',
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quá trình học'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
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
              title: Text('Ngày $formattedDate'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.list, color: Colors.blue),
                    onPressed: () => _showDayDetails(context, day),
                    tooltip: 'Show details',
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit_square, color: Colors.orange),
                    onPressed: () => _goToTest(context, day),
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
