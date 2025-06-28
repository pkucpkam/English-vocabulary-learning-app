import 'package:flutter/material.dart';
import 'package:learn_new_words/screens/vocab_detail_page.dart';
import 'package:learn_new_words/models/vocab.dart';
import 'package:learn_new_words/services/data_service.dart';
import 'dart:async';

class VocabListPage extends StatefulWidget {
  const VocabListPage({super.key});

  @override
  State<VocabListPage> createState() => _VocabListPageState();
}

class _VocabListPageState extends State<VocabListPage> {
  late Future<List<Vocabulary>> _vocabFuture;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _vocabFuture = DataService.getAllVocabularies();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  List<Vocabulary> _filterVocabularies(List<Vocabulary> vocabList) {
    if (_searchQuery.isEmpty) return vocabList;
    return vocabList.where((vocab) {
      final word = vocab.word.toLowerCase();
      final meanings =
          vocab.meanings.map((m) => m.meaning).join(' ').toLowerCase();
      final examples =
          vocab.meanings.map((m) => m.example).join(' ').toLowerCase();
      final pronunciation = vocab.pronunciation_uk?.toLowerCase() ?? '';
      return word.contains(_searchQuery) ||
          meanings.contains(_searchQuery) ||
          examples.contains(_searchQuery) ||
          pronunciation.contains(_searchQuery);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách từ vựng'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Tìm kiếm từ vựng...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon:
                    _searchQuery.isNotEmpty
                        ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _searchQuery = '';
                            });
                          },
                        )
                        : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceContainer,
              ),
              onChanged: (value) {},
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Vocabulary>>(
              future: _vocabFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Lỗi: ${snapshot.error}'));
                }

                final vocabList = snapshot.data ?? [];
                final filteredVocabList = _filterVocabularies(vocabList);

                if (filteredVocabList.isEmpty) {
                  return const Center(
                    child: Text('Không tìm thấy từ vựng nào.'),
                  );
                }

                return ListView.builder(
                  itemCount: filteredVocabList.length,
                  itemBuilder: (context, index) {
                    final vocab = filteredVocabList[index];
                    final meaning = vocab.meanings
                        .map((m) => m.meaning)
                        .join(', ');

                    return ListTile(
                      title: Text(
                        vocab.word,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        meaning,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      leading: const Icon(Icons.bookmark_border),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => VocabDetailPage(vocabulary: vocab),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
