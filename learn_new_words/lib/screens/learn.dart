import 'package:flutter/material.dart';
import '../models/vocab.dart';
import '../services/data_service.dart';

class LearnPage extends StatefulWidget {
  const LearnPage({super.key});

  @override
  State<LearnPage> createState() => _LearnPageState();
}

class _LearnPageState extends State<LearnPage> {
  List<Vocabulary> unlearnedVocabularies = [];
  int currentIndex = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUnlearnedVocabularies();
  }

  Future<void> _loadUnlearnedVocabularies() async {
    setState(() {
      isLoading = true;
    });
    final vocabList = await DataService.getUnlearnedVocabularies();
    setState(() {
      unlearnedVocabularies = vocabList;
      isLoading = false;
    });
  }

  void _markAsKnown() {
    if (unlearnedVocabularies.isEmpty) return;

    setState(() {
      final vocab = unlearnedVocabularies[currentIndex];
      DataService.updateVocabularyLearnedStatus(vocab, true).then((_) {
        if (currentIndex < unlearnedVocabularies.length - 1) {
          currentIndex++;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Đã học hết từ chưa học!')),
          );
          _loadUnlearnedVocabularies(); // Tải lại danh sách từ chưa học
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (unlearnedVocabularies.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
        ),
        body: const Center(child: Text('Không còn từ nào để học!')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: Center(
        child: LearnWordWidget(
          word: unlearnedVocabularies[currentIndex].word,
          meaning: unlearnedVocabularies[currentIndex].meanings.join('; '),
          onKnownPressed: _markAsKnown,
        ),
      ),
    );
  }
}

class LearnWordWidget extends StatelessWidget {
  final String word;
  final String meaning;
  final VoidCallback onKnownPressed;

  const LearnWordWidget({
    super.key,
    required this.word,
    required this.meaning,
    required this.onKnownPressed,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double cardSize = screenWidth * 0.9; // Chiếm 90% chiều rộng màn hình

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: cardSize,
            height: cardSize, // Hình vuông
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      word,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      meaning,
                      style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                      textAlign: TextAlign.center,
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: onKnownPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              minimumSize: const Size(300, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Already Know',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
