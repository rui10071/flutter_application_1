import 'dart:async';
import 'models.dart';
import 'repositories.dart';


class MockAuthRepository implements AuthRepository {
  final _authStateController = StreamController<String?>.broadcast();
  
  String? _currentUserId;


  MockAuthRepository() {
    _currentUserId = null;
  }


  @override
  Stream<String?> get authStateChanges async* {
    yield _currentUserId;
    yield* _authStateController.stream;
  }


  @override
  String? get currentUserId => _currentUserId;


  @override
  Future<void> signInWithEmail(String email, String password) async {
    await Future.delayed(Duration(seconds: 1));


    if (password == "error") {
      throw Exception("意図的なエラー");
    }


    _currentUserId = "mock_user_id";
    _authStateController.add(_currentUserId);
  }


  @override
  Future<void> signUpWithEmail(String email, String password) async {
    await Future.delayed(Duration(seconds: 1));
    _currentUserId = "mock_user_id";
    _authStateController.add(_currentUserId);
  }


  @override
  Future<void> signOut() async {
    await Future.delayed(Duration(milliseconds: 500));
    _currentUserId = null;
    _authStateController.add(null);
  }


  @override
  Future<void> deleteAccount() async {
    await Future.delayed(Duration(seconds: 2));
    _currentUserId = null;
    _authStateController.add(null);
  }
}


class MockUserRepository implements UserRepository {
  @override
  Future<void> saveProfile(UserProfile profile) async {
    await Future.delayed(Duration(seconds: 1));
  }


  @override
  Future<UserProfile?> getProfile(String userId) async {
    await Future.delayed(Duration(milliseconds: 500));
    return UserProfile(
      id: userId,
      name: "田中 健太 (Mock)",
      email: "mock@example.com",
      height: 175.0,
      weight: 68.0,
      age: 28,
      goal: "フォーム改善",
    );
  }


  @override
  Stream<UserProfile?> watchProfile(String userId) {
    return Stream.value(UserProfile(
      id: userId,
      name: "田中 健太 (Mock Stream)",
      email: "mock@example.com",
      height: 175.0,
      weight: 68.0,
      age: 28,
      goal: "フォーム改善",
    ));
  }
}


class MockTrainingRepository implements TrainingRepository {
  @override
  Future<void> addLog(String userId, TrainingLog log) async {
    await Future.delayed(Duration(seconds: 1));
  }


  @override
  Future<List<TrainingLog>> getLogs(String userId) async {
    await Future.delayed(Duration(seconds: 1));
    return [
      TrainingLog(
        id: "1",
        menuId: "squat",
        menuTitle: "スクワット",
        date: DateTime.now().subtract(Duration(days: 1)),
        score: 85,
        duration: "10分",
        calories: 50,
        memo: "膝に違和感あり",
      )
    ];
  }


  @override
  Stream<List<TrainingLog>> watchLogs(String userId) {
     return Stream.value([
      TrainingLog(
        id: "1",
        menuId: "squat",
        menuTitle: "スクワット",
        date: DateTime.now().subtract(Duration(days: 1)),
        score: 85,
        duration: "10分",
        calories: 50,
        memo: "膝に違和感あり",
      )
    ]);
  }
}


