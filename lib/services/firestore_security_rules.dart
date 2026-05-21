/// Firestore security rules for SafMeh.
/// Deploy these rules in the Firebase Console under Firestore > Rules.
///
/// These rules ensure:
/// - Users can only read/write their own data
/// - No user can access another user's data
/// - Audio evidence is write-only (users can upload but not read others')
class FirestoreSecurityRules {
  static const String rules = '''
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    // Users can only access their own profile and config
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;

      // Trusted contacts — owner only
      match /trusted_contacts/{contactId} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }

      // Safe walk sessions — owner only
      match /safe_walk_sessions/{sessionId} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }

      // SOS events — owner only
      match /sos_events/{eventId} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }

      // Route share sessions — owner only
      match /route_share_sessions/{sessionId} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }

      // Comfort notes — owner only
      match /comfort_notes/{noteId} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
    }

    // Deny all other access
    match /{document=**} {
      allow read, write: if false;
    }
  }
}
''';
}
