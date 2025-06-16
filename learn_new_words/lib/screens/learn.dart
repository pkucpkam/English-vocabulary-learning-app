import 'package:flutter/material.dart';

class LearnPage extends StatefulWidget {
  const LearnPage({super.key});

  @override
  State<LearnPage> createState() => _LearnPageState();
}

class _LearnPageState extends State<LearnPage> {
  final List<Map<String, String>> vocabulary = [
    {'word': 'Apple', 'meaning': 'Quả táo'},
    {'word': 'Book', 'meaning': 'Cuốn sách'},
    {'word': 'Cat', 'meaning': 'Con mèo'},
    {
      'word': 'Responsibility',
      'meaning': 'Trách nhiệm, nghĩa vụ hoặc sự chịu trách nhiệm về điều gì đó',
    },
  ];

  int currentIndex = 0;

  void _markAsKnown() {
    setState(() {
      if (currentIndex < vocabulary.length - 1) {
        currentIndex++;
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Đã học hết từ!')));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: Center(
        child: LearnWordWidget(
          word: vocabulary[currentIndex]['word']!,
          meaning: vocabulary[currentIndex]['meaning']!,
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
              'Next',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
