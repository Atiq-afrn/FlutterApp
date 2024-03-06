import 'package:myfrstapp/Services/auth/auth_user.dart';
import 'package:myfrstapp/Services/auth_provider.dart';
import 'package:myfrstapp/Services/firebase_auth_provider.dart';

class AuthService implements AuthProvider {
  final AuthProvider provider;

  const AuthService({required this.provider});
  factory AuthService.firebase() => AuthService(
        provider: FirebaseAuthProvider(),
      );

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) =>
      provider.createUser(
        email: email,
        password: password,
      );

  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) =>
      provider.logIn(email: email, password: password);

  @override
  Future<void> logOut() => provider.logOut();

  @override
  Future<void> sendEmailVerification() => provider.sendEmailVerification();

  @override
  Future<void> initialize() => provider.initialize();
}
