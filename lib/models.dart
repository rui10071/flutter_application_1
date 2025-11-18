import 'package:flutter/foundation.dart';


@immutable
class UserProfile {
  final String id;
  final String name;
  final String email;
  final double height;
  final double weight;
  final int age;
  final String goal;


  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.height,
    required this.weight,
    required this.age,
    required this.goal,
  });


  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'height': height,
      'weight': weight,
      'age': age,
      'goal': goal,
    };
  }


  factory UserProfile.fromMap(String id, Map<String, dynamic> map) {
    return UserProfile(
      id: id,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      height: (map['height'] ?? 0.0).toDouble(),
      weight: (map['weight'] ?? 0.0).toDouble(),
      age: map['age'] ?? 0,
      goal: map['goal'] ?? '',
    );
  }
}


@immutable
class TrainingLog {
  final String id;
  final String menuId;
  final String menuTitle;
  final DateTime date;
  final int score;
  final String duration;
  final double calories;
  final String memo;


  const TrainingLog({
    required this.id,
    required this.menuId,
    required this.menuTitle,
    required this.date,
    required this.score,
    required this.duration,
    required this.calories,
    required this.memo,
  });


  Map<String, dynamic> toMap() {
    return {
      'menuId': menuId,
      'menuTitle': menuTitle,
      'date': date.toIso8601String(),
      'score': score,
      'duration': duration,
      'calories': calories,
      'memo': memo,
    };
  }


  factory TrainingLog.fromMap(String id, Map<String, dynamic> map) {
    return TrainingLog(
      id: id,
      menuId: map['menuId'] ?? '',
      menuTitle: map['menuTitle'] ?? '',
      date: DateTime.parse(map['date']),
      score: map['score'] ?? 0,
      duration: map['duration'] ?? '',
      calories: (map['calories'] ?? 0.0).toDouble(),
      memo: map['memo'] ?? '',
    );
  }
}


