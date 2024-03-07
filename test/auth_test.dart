import 'package:myfrstapp/Services/auth/auth_exception.dart';
import 'package:myfrstapp/Services/auth/auth_user.dart';
import 'package:myfrstapp/Services/auth_provider.dart';
import 'package:test/test.dart';

void main() {
  group('Mock Authentication', () {
    final provider = MockAuthprovider();

    test('should not initialized to begin with', () {
      expect(provider.isInitialized, false);
    });
    test('can not logout if not initializes', () {
      expect(
        provider.logOut(),
        throwsA(
          const TypeMatcher<NotInitializedException>(),
        ),
      );
    });
    test(
      'should be able to initialize',
      () async {
        await provider.initialize();
        expect(provider.isInitialized, true);
      },
    );
    test('user should null after initialization', () {
      expect(provider.currentUser, null);
    });
    test('should be initialize with in 2 second ', () async {
      await provider.initialize();
      expect(provider.isInitialized, true);
    }, timeout: const Timeout(Duration(seconds: 2)));
    test('Creat user should deligate with login function', () async {
      final badEmailUser = provider.createUser(
        email: 'atiq@.com',
        password: 'anypassword',
      );
      expect(badEmailUser,
          throwsA(const TypeMatcher<UserNotFoundAuthException>()));
      final badPassword = provider.createUser(
        email: 'atiq@.com',
        password: 'atiqkhan',
      );
      expect(badPassword,
          throwsA(const TypeMatcher<WrongPasswordAuthException>()));
      final user = await provider.createUser(email: 'atiq', password: 'khan');
      expect(provider.currentUser, user);
      expect(user.isEmailVerified, false);
    });
    test('logged in user should be abble to get verified', () {
      provider.sendEmailVerification();
      final user = provider.currentUser;
      expect(user, isNotNull);
      expect(user!.isEmailVerified, true);
    });
    test('should be able to login and logout again', () async {
      await provider.logOut();
      await provider.logIn(email: 'email', password: 'password');
      final user = provider.currentUser;
      expect(user, isNotNull);
    });
  });
}

class NotInitializedException implements Exception {}

class MockAuthprovider implements AuthProvider {
  AuthUser? _user;
  var _isInitialized = false;
  bool get isInitialized => _isInitialized;

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    if (!isInitialized) {
      throw NotInitializedException();
    }
    await Future.delayed(const Duration(seconds: 2));
    return logIn(
      email: email,
      password: password,
    );
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
  }

  @override
  Future<AuthUser> logIn({required String email, required String password}) {
    if (!isInitialized) {
      throw NotInitializedException();
    }
    if (email == 'zrnkhan@.com') {
      throw UserNotFoundAuthException();
    }
    if (password == 'atiq') {
      throw WeakPasswordAuthException();
    }

    const user = AuthUser(email: 'atiqkhan@.com', isEmailVerified: false);
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logOut() async {
    if (!isInitialized) {
      throw NotInitializedException();
    }
    if (_user == null) {
      throw UserNotFoundAuthException();
    }
    await Future.delayed(
      const Duration(seconds: 1),
    );
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInitialized) {
      throw NotInitializedException();
    }
    final user = _user;
    if (user == null) {
      throw UserNotFoundAuthException();
    }
    const newUser = AuthUser(email: 'atiqkhan@.com', isEmailVerified: true);
    _user = newUser;
  }
}
