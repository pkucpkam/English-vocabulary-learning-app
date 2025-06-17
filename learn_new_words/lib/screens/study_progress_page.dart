import 'package:flutter/material.dart';

class DailyVocabularyProgressPage extends StatelessWidget {
  final int totalDays = 100;
  final int currentDay = 6;
  final List<int> completedDays = [1, 2, 3, 4, 5];

  DailyVocabularyProgressPage({super.key});

  bool _isUnlocked(int day) {
    if (day == 1) return true;
    return completedDays.contains(day - 1);
  }

  void _showLockedDialog(BuildContext context, int day) {
    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.lock_outline,
                    size: 64,
                    color: Colors.orangeAccent,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Ngày $day chưa được mở khóa!',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Bạn cần hoàn thành ngày trước đó để tiếp tục học.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orangeAccent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.0,
                        vertical: 12,
                      ),
                      child: Text('OK', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  void _goToDay(BuildContext context, int day) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Đi tới Ngày $day')));
    // TODO: Navigate to learning page for day $day
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Learning Progress'), centerTitle: true),
      body: ListView.builder(
        itemCount: totalDays,
        itemBuilder: (context, index) {
          final day = index + 1;
          final isCompleted = completedDays.contains(day);
          final isToday = day == currentDay;
          final isUnlocked = _isUnlocked(day);

          Color tileColor;
          Widget? trailingIcon;

          if (isCompleted) {
            tileColor = Colors.green;
            trailingIcon = const Icon(Icons.check, color: Colors.white);
          } else if (isToday) {
            tileColor = Colors.amber;
          } else {
            tileColor =
                isUnlocked ? Colors.grey.shade300 : Colors.grey.shade200;
            if (!isUnlocked) {
              trailingIcon = const Icon(Icons.lock, color: Colors.grey);
            }
          }

          return Container(
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            decoration: BoxDecoration(
              color: tileColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              title: Text('Day $day'),
              trailing: trailingIcon,
              onTap: () {
                if (isUnlocked) {
                  _goToDay(context, day);
                } else {
                  _showLockedDialog(context, day);
                }
              },
            ),
          );
        },
      ),
    );
  }
}
