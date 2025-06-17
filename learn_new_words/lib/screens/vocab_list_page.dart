import 'package:flutter/material.dart';
import 'package:learn_new_words/screens/vocab_detail_page.dart';
import 'package:learn_new_words/models/vocab.dart';
import 'package:learn_new_words/services/data_service.dart';

class VocabListPage extends StatefulWidget {
  const VocabListPage({super.key});

  @override
  State<VocabListPage> createState() => _VocabListPageState();
}

class _VocabListPageState extends State<VocabListPage> {
  late Future<List<Vocabulary>> _vocabFuture;

  @override
  void initState() {
    super.initState();
    _vocabFuture = DataService.getAllVocabularies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vocabulary list'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),

      body: FutureBuilder<List<Vocabulary>>(
        future: _vocabFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          }

          final vocabList = snapshot.data ?? [];

          if (vocabList.isEmpty) {
            return const Center(child: Text('Không có từ vựng nào.'));
          }

          return ListView.builder(
            itemCount: vocabList.length,
            itemBuilder: (context, index) {
              final word = vocabList[index].word;
              final meaning = vocabList[index].meanings.join(', ');

              return ListTile(
                title: Text(
                  word,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(meaning),
                leading: const Icon(Icons.bookmark_border),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => VocabDetailPage(word: word, meaning: meaning),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
