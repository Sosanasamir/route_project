import 'package:firebase_auth/firebase_auth.dart';

class ProfileRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  Future<void> updateProfile({required String name, String? avatarPath}) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await user.updateDisplayName(name);
        if (avatarPath != null) {
          await user.updatePhotoURL(avatarPath);
        }
        await user.reload();
      }
    } catch (e) {
      throw Exception("Failed to update profile: $e");
    }
  }

  Future<void> sendPasswordReset(String email) async {
    try {
      final email = _auth.currentUser?.email;
      if (email != null) {
        await _auth.sendPasswordResetEmail(email: email);
      } else {
        throw Exception("No email address found for this user.");
      }
    } catch (e) {
      throw Exception("Failed to send reset email: $e");
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<void> deleteUserAccount() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await user.delete();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        throw Exception(
          "For security, please log out and log back in before deleting your account.",
        );
      }
      throw Exception(e.message ?? "An error occurred during deletion.");
    } catch (e) {
      throw Exception("Failed to delete account: $e");
    }
  }
}
