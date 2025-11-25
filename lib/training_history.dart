import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'training_model.dart';

class TrainingHistoryItem {
  final String id;
  final TrainingMenu menu;
  final DateTime date;
  final String reps; 
  final int score; 
  final String memo;

  TrainingHistoryItem({
    required this.id,
    required this.menu,
    required this.date,
    required this.reps,
    required this.score,
    required this.memo,
  });
}

class TrainingHistoryNotifier extends StateNotifier<List<TrainingHistoryItem>> {
  TrainingHistoryNotifier() : super([]); 

  void addEntry({
    required TrainingMenu menu,
    required String reps,
    required int score,
    required String memo,
  }) {
    final newItem = TrainingHistoryItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(), 
      menu: menu,
      date: DateTime.now(),
      reps: reps,
      score: score,
      memo: memo,
    );
    state = [newItem, ...state];
  }
}

final trainingHistoryProvider = StateNotifierProvider<TrainingHistoryNotifier, List<TrainingHistoryItem>>((ref) {
  return TrainingHistoryNotifier();
});

