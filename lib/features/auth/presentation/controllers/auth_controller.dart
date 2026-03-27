import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/auth_repository.dart';
import '../../domain/user_model.dart';

final authControllerProvider = StateNotifierProvider<AuthController, AsyncValue<void>>((ref) {
  return AuthController(ref.watch(authRepositoryProvider));
});

class AuthController extends StateNotifier<AsyncValue<void>> {
  final AuthRepository _authRepository;

  AuthController(this._authRepository) : super(const AsyncValue.data(null));

  Future<void> signUp({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String role,
    Map<String, dynamic>? additionalData, // Accept extra fields
  }) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      // 1. Create Auth User
      final credential = await _authRepository.signUpWithEmail(email: email, password: password);
      final user = credential.user;

      if (user != null) {
        await user.updateDisplayName(name);

        // 2. Create User Model (Basic Info)
        final newUser = UserModel(
          uid: user.uid,
          email: email,
          name: name,
          role: role,
          phone: phone,
          createdAt: DateTime.now(),
        );

        // 3. Save to Firestore with any extra data
        await _authRepository.saveUserData(newUser, additionalData);
      }
    });
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _authRepository.signInWithEmail(email: email, password: password);
    });
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _authRepository.signOut());
  }
}