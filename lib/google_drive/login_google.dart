import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:googleapis/drive/v3.dart' as drive;

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      drive.DriveApi.driveFileScope,
      drive.DriveApi.driveScope,
    ],
  );
  final storage = const FlutterSecureStorage();

  Future<bool> isSignedIn() async => await _googleSignIn.isSignedIn();

  Future<User?> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final googleAuth = await googleUser.authentication;
      await storage.write(key: 'googleAccessToken', value: googleAuth.accessToken);
      await storage.write(key: 'googleIdToken', value: googleAuth.idToken);

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      await storage.write(key: "signedIn", value: "true");
      return userCredential.user;
    } catch (e) {
      debugPrint('Google sign-in error: $e');
      await signOut();
      return null;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
    await storage.deleteAll();
  }
}