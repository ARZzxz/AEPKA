import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ExpCalculator {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  final CollectionReference _firestoreUsers = FirebaseFirestore.instance.collection('users');

  Future<void> updateUserExp(String userId, int additionalExp, int additionalPlayingTime) async {
    try {
      DatabaseReference userRef = _database.child('users').child(userId);
      DatabaseEvent event = await userRef.once();
      if (event.snapshot.exists) {
        int currentExp = event.snapshot.child('exp').value as int? ?? 0;
        int newExp = currentExp + additionalExp;

        int currentPlayingTime = event.snapshot.child('playingTime').value as int? ?? 0;
        int newPlayingTime = currentPlayingTime + additionalPlayingTime;

        // Update user's exp and playing time in the Realtime Database
        await userRef.update({
          'exp': newExp,
          'playingTime': newPlayingTime,
        });

        // Update the same fields in Firestore
        await _firestoreUsers.doc(userId).update({
          'exp': newExp,
          'playing_time': newPlayingTime,
        });

        // Check if the user should level up or rank up
        await _checkLevelUp(userId, newExp);
      } else {
        // If user data does not exist, initialize it
        await userRef.set({
          'exp': additionalExp,
          'playingTime': additionalPlayingTime,
          'level': 1,
          'rank': 'Bronze',
        });

        await _firestoreUsers.doc(userId).set({
          'exp': additionalExp,
          'playing_time': additionalPlayingTime,
          'level': 1,
          'rank': 'Bronze',
        });
      }
    } catch (e) {
      print('Error updating user exp: $e');
    }
  }

  Future<void> _checkLevelUp(String userId, int exp) async {
    DatabaseReference userRef = _database.child('users').child(userId);
    DatabaseEvent event = await userRef.once();

    if (event.snapshot.exists) {
      int level = event.snapshot.child('level').value as int? ?? 1;
      String rank = event.snapshot.child('rank').value as String? ?? 'Bronze';
      int requiredExpForLevelUp = _calculateExpForNextLevel(level);
      int requiredExpForRankUp = _calculateExpForNextRank(rank);

      if (exp >= requiredExpForLevelUp) {
        await userRef.update({'level': level + 1});
        await _firestoreUsers.doc(userId).update({'level': level + 1});
      }

      if (exp >= requiredExpForRankUp) {
        String newRank = _getNextRank(rank);
        await userRef.update({'rank': newRank});
        await _firestoreUsers.doc(userId).update({'rank': newRank});
      }
    }
  }

  int _calculateExpForNextLevel(int level) {
    return 2000 * (level + 1);
  }

  int _calculateExpForNextRank(String rank) {
    switch (rank) {
      case 'Bronze':
        return 2000;
      case 'Silver':
        return 4000;
      case 'Gold':
        return 8000;
      case 'Platinum':
        return 16000;
      case 'Diamond':
        return 32000;
      case 'Mythril':
        return 70000;
      case 'Adamantium':
        return 5000000;
      case 'Legend':
        return 6000000;
      case 'Ancestor':
        return 8000000;
      default:
        return double.infinity.toInt();
    }
  }

  String _getNextRank(String currentRank) {
    switch (currentRank) {
      case 'Bronze':
        return 'Silver';
      case 'Silver':
        return 'Gold';
      case 'Gold':
        return 'Platinum';
      case 'Platinum':
        return 'Diamond';
      case 'Diamond':
        return 'Mythril';
      case 'Mythril':
        return 'Adamantium';
      case 'Adamantium':
        return 'Legend';
      case 'Legend':
        return 'Ancestor';
      case 'Ancestor':
        return 'Herrscher';
      default:
        return currentRank;
    }
  }
}
