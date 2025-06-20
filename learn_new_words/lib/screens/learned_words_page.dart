import 'package:flutter/material.dart';
import '../models/vocab.dart';
import '../services/data_service.dart';
import 'package:intl/intl.dart';
import 'vocab_detail_page.dart';

class LearnedWordsPage extends StatefulWidget {
  final DateTime selectedDay;

  const LearnedWordsPage({super.key, required this.selectedDay});

  @override
  State<LearnedWordsPage> createState() => _LearnedWordsPageState();
}

class _LearnedWordsPageState extends State<LearnedWordsPage> {
  List<Vocabulary> dayVocabularies = [];
  bool isLoading = true;

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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Từ vựng học ngày ${DateFormat('dd/MM/yyyy').format(widget.selectedDay)}',
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : dayVocabularies.isEmpty
              ? const Center(
                child: Text('Không có từ vựng nào được học trong ngày này.'),
              )
              : ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: dayVocabularies.length,
                itemBuilder: (context, index) {
                  final vocab = dayVocabularies[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      vertical: 4.0,
                      horizontal: 8.0,
                    ),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      title: Text(
                        vocab.word,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        vocab.meanings.map((m) => m.meaning).join(', '),
                        style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => VocabDetailPage(vocabulary: vocab),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
    );
  }
}
