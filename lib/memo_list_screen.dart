import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart'; 
import 'theme.dart';
import 'training_history.dart';

final memoFilterProvider = StateProvider<String>((ref) => 'すべて');

class MemoListScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allHistory = ref.watch(trainingHistoryProvider);
    final selectedType = ref.watch(memoFilterProvider);
    
    final memos = allHistory.where((item) {
      final hasMemo = item.memo.isNotEmpty;
      final matchesType = (selectedType == 'すべて' || item.menu.title == selectedType);
      return hasMemo && matchesType;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("トレーニングメモ一覧"),
      ),
      body: Column(
        children: [
          _buildFilterChips(context, ref),
          Expanded(
            child: memos.isEmpty
                ? Center(
                    child: Text(
                      "該当するメモはありません",
                      style: TextStyle(color: kTextDarkSecondary),
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.all(16.0),
                    itemCount: memos.length,
                    itemBuilder: (context, index) {
                      final item = memos[index];
                      return Card(
                        margin: EdgeInsets.only(bottom: 16),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    item.menu.title,
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    DateFormat('yyyy/MM/dd HH:mm').format(item.date),
                                    style: TextStyle(color: kTextDarkSecondary, fontSize: 12),
                                  ),
                                ],
                              ),
                              Divider(height: 24),
                              Text(
                                item.memo,
                                style: TextStyle(height: 1.6, color: Theme.of(context).textTheme.bodyLarge?.color),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips(BuildContext context, WidgetRef ref) {
    final allHistory = ref.watch(trainingHistoryProvider);
    final types = {"すべて", ...allHistory.where((item) => item.memo.isNotEmpty).map((item) => item.menu.title)}.toList();
    final selectedType = ref.watch(memoFilterProvider);

    return Container(
      height: 40,
      margin: EdgeInsets.only(top: 16, bottom: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16),
        itemCount: types.length,
        itemBuilder: (context, index) {
          final type = types[index];
          final isSelected = selectedType == type;
          return Container(
            margin: EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(type),
              selected: isSelected,
              onSelected: (selected) {
                ref.read(memoFilterProvider.notifier).state = type;
              },
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Theme.of(context).textTheme.bodyMedium?.color,
                fontWeight: FontWeight.w500,
              ),
              backgroundColor: (Theme.of(context).brightness == Brightness.dark ? Colors.grey[800] : Colors.grey[200]),
              selectedColor: kPrimaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: Colors.transparent),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16),
            ),
          );
        },
      ),
    );
  }
}

