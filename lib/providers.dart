import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'repositories.dart';
import 'mock_repositories.dart';


final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return MockAuthRepository();
});


final userRepositoryProvider = Provider<UserRepository>((ref) {
  return MockUserRepository();
});


final trainingRepositoryProvider = Provider<TrainingRepository>((ref) {
  return MockTrainingRepository();
});


final authStateProvider = StreamProvider<String?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
});


