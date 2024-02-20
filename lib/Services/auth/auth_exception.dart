// login exception

class UserNotFoundAuthException implements Exception {}

class WrongPasswordAuthException implements Exception {}

// Register exception
class WeakPasswordAuthException implements Exception {}

class EmailAllreadyInUseAuthException implements Exception {}

class InvalidEmailAuthException implements Exception {}

// Generic Exception
class GenericAuthException implements Exception {}

class UserNotLoggedInAuthException implements Exception {}
