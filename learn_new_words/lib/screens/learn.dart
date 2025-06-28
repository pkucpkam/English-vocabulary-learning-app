import 'package:flutter/material.dart';
import '../models/vocab.dart';
import '../services/data_service.dart';
import '../services/audio_service.dart';

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

    final vocab = unlearnedVocabularies[currentIndex];
    DataService.updateVocabularyLearnedStatus(
      vocab,
      true,
      learnedDate: DateTime.now(),
    ).then((_) {
      setState(() {
        if (currentIndex < unlearnedVocabularies.length - 1) {
          currentIndex++;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Đã học hết từ chưa học!')),
          );
          _loadUnlearnedVocabularies();
        }
      });
    });
  }

  void _skipWord() {
    setState(() {
      if (currentIndex < unlearnedVocabularies.length - 1) {
        currentIndex++;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã xem hết từ chưa học!')),
        );
        _loadUnlearnedVocabularies();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          centerTitle: true,
          title: const Text('Học từ mới'),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (unlearnedVocabularies.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          centerTitle: true,
          title: const Text('Học từ mới'),
        ),
        body: const Center(child: Text('Không còn từ nào để học!')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        centerTitle: true,
        title: const Text('Học từ mới'),
      ),
      body: LearnWordWidget(
        vocabulary: unlearnedVocabularies[currentIndex],
        onKnownPressed: _markAsKnown,
        onSkipPressed: _skipWord,
      ),
    );
  }
}

class LearnWordWidget extends StatelessWidget {
  final Vocabulary vocabulary;
  final VoidCallback onKnownPressed;
  final VoidCallback onSkipPressed;

  const LearnWordWidget({
    super.key,
    required this.vocabulary,
    required this.onKnownPressed,
    required this.onSkipPressed,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double cardSize = screenWidth * 0.85;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Stack(
              children: [
                Container(
                  width: cardSize,
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.2),
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        vocabulary.word,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      if (vocabulary.pronunciation_uk != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            '/${vocabulary.pronunciation_uk}/',
                            style: TextStyle(
                              fontSize: 20,
                              fontStyle: FontStyle.italic,
                              color: Colors.grey[700],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                    ],
                  ),
                ),
                // Nút loa ở góc trên bên phải
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    icon: const Icon(
                      Icons.volume_up,
                      size: 24,
                      color: Colors.blue,
                    ),
                    onPressed: () {
                      AudioService.playAudio(vocabulary); 
                    },
                    splashRadius: 20,
                    tooltip: 'Phát âm thanh',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Phần ý nghĩa
          Text(
            'Nghĩa:',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child:
                vocabulary.meanings.isEmpty
                    ? const Center(child: Text('Không có nghĩa nào.'))
                    : ListView.builder(
                      itemCount: vocabulary.meanings.length,
                      itemBuilder: (context, index) {
                        final meaning = vocabulary.meanings[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 4.0),
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  meaning.meaning,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Ví dụ: ${meaning.example}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: onSkipPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    foregroundColor: Colors.black87,
                    minimumSize: const Size(140, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Chưa thuộc',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                ElevatedButton(
                  onPressed: onKnownPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(140, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Đã thuộc',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
