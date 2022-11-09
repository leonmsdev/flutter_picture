import 'auth_user.dart';

abstract class AuthProvider {
  AuthUser? get currentUser;

  String? get email;

  Future<void> initialize();

  Future<AuthUser> signIn({
    required String email,
    required String password,
  });

  Future<AuthUser> createUser({
    required String email,
    required String password,
  });

  Future<void> signOut();

  Future<void> sendEmailVerification();
}
