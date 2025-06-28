import 'package:flutter/material.dart';
import 'package:learn_new_words/screens/general_review.dart';
import 'package:learn_new_words/screens/learn.dart';
import 'package:learn_new_words/screens/list_test_page.dart';
import 'package:learn_new_words/screens/study_progress_page.dart';
import 'package:learn_new_words/services/data_service.dart';

class MyHomeContent extends StatefulWidget {
  const MyHomeContent({super.key});

  @override
  State<MyHomeContent> createState() => _MyHomeContentState();
}

class _MyHomeContentState extends State<MyHomeContent> {
  int totalWords = 0;
  int todayWords = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadWordStats();
  }

  Future<void> _loadWordStats() async {
    final allVocabs = await DataService.getLearnedVocabularies();
    final today = DateTime.now();

    final todayVocabs =
        allVocabs.where((vocab) {
          final learned = vocab.learnedDate;
          return learned != null &&
              learned.year == today.year &&
              learned.month == today.month &&
              learned.day == today.day;
        }).toList();

    setState(() {
      totalWords = allVocabs.length;
      todayWords = todayVocabs.length;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          const Text(
            'Tổng quan quá trình học',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatCard(
                context,
                'Số từ đã học',
                '$totalWords',
                Icons.book,
              ),
              _buildStatCard(context, 'Hôm nay', '$todayWords', Icons.today),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'Học và Luyện tập',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 24,
            mainAxisSpacing: 24,
            padding: const EdgeInsets.fromLTRB(24, 2, 24, 2),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildActionButton(
                context,
                'Học từ mới',
                Icons.add_circle_outline,
                Colors.blue,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => LearnPage()),
                  ).then((_) {
                    _loadWordStats();
                  });
                },
              ),
              _buildActionButton(
                context,
                'Ôn tập theo ngày',
                Icons.refresh,
                Colors.green,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DailyVocabularyProgressPage(),
                    ),
                  );
                },
              ),
              _buildActionButton(
                context,
                'Kiểm tra từ vựng',
                Icons.quiz,
                Colors.orange,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ListTestPage()),
                  );
                },
              ),
              _buildActionButton(
                context,
                'Ôn tập tổng quát',
                Icons.library_books,
                const Color.fromARGB(255, 235, 109, 157),
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const GeneralReviewPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
  ) {
    return SizedBox(
      width: 150,
      height: 150,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 28,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 6),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return SizedBox(
      width: 150,
      height: 150,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
