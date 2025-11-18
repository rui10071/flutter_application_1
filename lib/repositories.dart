import 'models.dart';


abstract class AuthRepository {
  Stream<String?> get authStateChanges;
  Future<void> signInWithEmail(String email, String password);
  Future<void> signUpWithEmail(String email, String password);
  Future<void> signOut();
  Future<void> deleteAccount(); // 追加: アカウント削除
  String? get currentUserId;
}


abstract class UserRepository {
  Future<void> saveProfile(UserProfile profile);
  Future<UserProfile?> getProfile(String userId);
  Stream<UserProfile?> watchProfile(String userId);
}


abstract class TrainingRepository {
  Future<void> addLog(String userId, TrainingLog log);
  Future<List<TrainingLog>> getLogs(String userId);
  Stream<List<TrainingLog>> watchLogs(String userId);
}


