import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis_auth/googleapis_auth.dart';

class AuthService extends ChangeNotifier {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'profile',
      'https://www.googleapis.com/auth/drive.file',
    ],
  );

  bool _isSignedIn = false;
  bool _isLoading = false;
  String? _errorMessage;
  GoogleSignInAccount? _currentUser;
  AuthClient? _authClient;

  bool get isSignedIn => _isSignedIn;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  GoogleSignInAccount? get currentUser => _currentUser;
  AuthClient? get authClient => _authClient;

  Future<void> signInWithGoogle() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        _isLoading = false;
        notifyListeners();
        return;
      }

      _currentUser = googleUser;
      _isSignedIn = true;
      
      // Get authentication client for Google APIs
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      _authClient = await clientViaUserConsent(
        ClientId('', ''), // These will be configured in production
        [DriveApi.driveFileScope],
        (url) async {
          // Handle OAuth consent flow
          if (kDebugMode) {
            print('Please visit this URL to authorize the application: $url');
          }
        },
      );

      if (kDebugMode) {
        print('Signed in as: ${googleUser.email}');
      }
    } catch (error) {
      _errorMessage = 'Failed to sign in: ${error.toString()}';
      if (kDebugMode) {
        print('Sign in error: $error');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _googleSignIn.signOut();
      _isSignedIn = false;
      _currentUser = null;
      _authClient = null;
      _errorMessage = null;
      
      if (kDebugMode) {
        print('Signed out successfully');
      }
    } catch (error) {
      _errorMessage = 'Failed to sign out: ${error.toString()}';
      if (kDebugMode) {
        print('Sign out error: $error');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> checkSignInStatus() async {
    _isLoading = true;
    notifyListeners();

    try {
      final GoogleSignInAccount? currentUser = await _googleSignIn.signInSilently();
      
      if (currentUser != null) {
        _currentUser = currentUser;
        _isSignedIn = true;
        
        // Re-authenticate to get fresh auth client
        final GoogleSignInAuthentication googleAuth = await currentUser.authentication;
        _authClient = await clientViaUserConsent(
          ClientId('', ''), // These will be configured in production
          [DriveApi.driveFileScope],
          (url) async {
            // Handle OAuth consent flow
            if (kDebugMode) {
              print('Please visit this URL to authorize the application: $url');
            }
          },
        );
      } else {
        _isSignedIn = false;
        _currentUser = null;
        _authClient = null;
      }
    } catch (error) {
      _errorMessage = 'Failed to check sign in status: ${error.toString()}';
      if (kDebugMode) {
        print('Check sign in status error: $error');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
