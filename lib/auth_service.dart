import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> registerUser(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      if (e is FirebaseAuthException) {
        String message;
        switch (e.code) {
          case 'invalid-email':
            message = "Please enter a valid Email Address";
            break;
          case 'too-many-requests':
            message = "Too many attempts. Please try again";
            break;
          case 'email-already-in-use':
            message = "An account already exists with this email.";
            break;
          case 'weak-password':
            message = "Password must be at least 6 characters.";
            break;

          default:
            message = "Something went wrong. Please try again.";
        }
        return Future.error(message);
      }
      return Future.error('Something went wrong. Please try again.');
    }
  }

  Future<User?> loginUser(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      if (e is FirebaseAuthException) {
        String message;
        switch (e.code) {
          case 'user-not-found':
            message = "No account found.";
            break;
          case 'wrong-password':
            message = "Incorrect password.";
            break;
          
          case 'invalid-email':
            message = "Please enter a valid Email address.";
            break;
          
          default:
            message = "Something went wrong. Please try again.";
        }
        return Future.error(message);
      }
      return Future.error('Something went wrong. Please try again.');
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  User? get currentUser => _auth.currentUser;
}
