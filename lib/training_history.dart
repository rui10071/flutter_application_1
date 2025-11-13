import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'training_model.dart';

// 1. トレーニング履歴のデータモデル
class TrainingHistoryItem {
  final String id;
  final TrainingMenu menu;
  final DateTime date;
  final String reps; // 例: "20回"
  final int score; // 例: 85
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

// 2. 履歴リストを管理するNotifier
class TrainingHistoryNotifier extends StateNotifier<List<TrainingHistoryItem>> {
  TrainingHistoryNotifier() : super([]); // 初期値は空のリスト

  // 履歴を追加するメソッド
  void addEntry({
    required TrainingMenu menu,
    required String reps,
    required int score,
    required String memo,
  }) {
    final newItem = TrainingHistoryItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(), // ユニークIDを生成
      menu: menu,
      date: DateTime.now(),
      reps: reps,
      score: score,
      memo: memo,
    );
    // 既存のリストの先頭に追加する
    state = [newItem, ...state];
  }
}

// 3. Providerの定義
final trainingHistoryProvider = StateNotifierProvider<TrainingHistoryNotifier, List<TrainingHistoryItem>>((ref) {
  return TrainingHistoryNotifier();
});

