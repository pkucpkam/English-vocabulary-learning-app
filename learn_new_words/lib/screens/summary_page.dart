import 'package:flutter/material.dart';
import '../models/vocab.dart';

class SummaryPage extends StatefulWidget {
  final List<Vocabulary> incorrectWords;
  final int total;

  const SummaryPage({
    super.key,
    required this.incorrectWords,
    required this.total,
  });

  @override
  State<SummaryPage> createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage> {
  bool showIncorrect = false;

  @override
  Widget build(BuildContext context) {
    final correctCount = widget.total - widget.incorrectWords.length;
    final percent = (correctCount / widget.total * 100).round();

    return Scaffold(
      appBar: AppBar(
        title: const Text('🎯 Kết quả kiểm tra'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 12),

            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Text(
                      'Tổng số từ: ${widget.total}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Chính xác: $correctCount',
                      style: const TextStyle(fontSize: 16, color: Colors.green),
                    ),
                    Text(
                      'Chưa chính xác: ${widget.incorrectWords.length}',
                      style: const TextStyle(fontSize: 16, color: Colors.red),
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: correctCount / widget.total,
                      backgroundColor: Colors.grey[300],
                      color: Colors.green,
                      minHeight: 10,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tỉ lệ đúng: $percent%',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (widget.incorrectWords.isNotEmpty)
              ElevatedButton(
                onPressed: () => setState(() => showIncorrect = !showIncorrect),
                style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
                child: Text(
                  showIncorrect ? 'Ẩn các từ chưa thuộc' : 'Xem các từ chưa thuộc',
                ),
              ),
            const SizedBox(height: 12),
            if (showIncorrect)
              Expanded(
                child: ListView.builder(
                  itemCount: widget.incorrectWords.length,
                  itemBuilder: (context, index) {
                    final vocab = widget.incorrectWords[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        vertical: 6,
                        horizontal: 4,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: const Icon(Icons.close, color: Colors.red),
                        title: Text(
                          vocab.word,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          vocab.meanings.isNotEmpty
                              ? vocab.meanings[0].meaning
                              : 'Không có nghĩa',
                        ),
                      ),
                    );
                  },
                ),
              ),
            if (widget.incorrectWords.isEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 32.0),
                child: Text(
                  '🎉 Bạn đã trả lời đúng tất cả các từ!',
                  style: TextStyle(fontSize: 18),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
