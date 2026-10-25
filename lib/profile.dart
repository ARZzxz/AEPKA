import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nes_ui/nes_ui.dart';
import 'changepassword.dart'; // Import halaman ChangePasswordPage

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Profil'),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFBB11B9),
                  Color(0xFF0018BC),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),
        body: Center(
          child: Text('Pengguna belum masuk'),
        ),
      );
    }

    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('users').doc(user.uid).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Profil'),
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFBB11B9),
                      Color(0xFF0018BC),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Profil'),
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFBB11B9),
                      Color(0xFF0018BC),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
            body: Center(child: Text('Data pengguna tidak ditemukan')),
          );
        }

        var userData = snapshot.data!.data() as Map<String, dynamic>;
        double currentExp = (userData['exp'] ?? 0).toDouble();
        double nextRankExp = _getNextRankExp(userData['rank'] ?? 'Bronze');

        // Tentukan kata sambutan berdasarkan peringkat
        String welcomeMessage = _getWelcomeMessage(userData['rank'] ?? 'Bronze');
        
        // Debug prints
        print('User Data: $userData');
        print('Current EXP: $currentExp');
        print('Next Rank EXP: $nextRankExp');
        print('Welcome Message: $welcomeMessage');

        return Scaffold(
          appBar: AppBar(
            title: Text('Profil'),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFBB11B9),
                    Color(0xFF0018BC),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center, // Mengatur posisi Container ke kanan
                  child: Container(
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 248, 198, 251), // Warna latar belakang kotak
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromARGB(255, 97, 7, 187).withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 10,
                          offset: Offset(0, 3), // posisi bayangan
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nickname:${userData['nickname'] ?? 'N/A'}',
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Level:${userData['level'] ?? 'N/A'}',
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Rank:${userData['rank'] ?? 'N/A'}',
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                if (welcomeMessage.isNotEmpty) ...[
                  Center(
                    child: Text(
                      welcomeMessage,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 242, 41, 209)),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 20),
                ],
                NesButton(
                  type: NesButtonType.primary,
                  child: Text('Change Password'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChangePasswordPage()),
                    );
                  },
                ),
                SizedBox(height: 20),
                Text(
                  'History:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          title: Text('Riwayat Item 1'),
                          subtitle: Text('Detail dari Riwayat Item 1'),
                        ),
                        ListTile(
                          title: Text('Riwayat Item 2'),
                          subtitle: Text('Detail dari Riwayat Item 2'),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'EXP Progres',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                LinearProgressIndicator(
                  value: nextRankExp > 0 ? currentExp / nextRankExp : 0.0,
                  backgroundColor: Colors.grey[300],
                  color: Colors.deepPurple,
                  minHeight: 8,
                ),
                SizedBox(height: 10),
                Text(
                  'EXP: ${currentExp.toStringAsFixed(0)} / ${nextRankExp.toStringAsFixed(0)}',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 20),
                NesButton(
                  type: NesButtonType.error,
                  child: Text('Logout'),
                  onPressed: () {
                    _showLogoutDialog(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  double _getNextRankExp(String rank) {
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
      case 'Herrscherr':
        return 10000000;
      default:
        return double.infinity;
    }
  }

  String _getWelcomeMessage(String rank) {
    switch (rank) {
      case 'Legend':
        return 'Selamat Datang Wahai Tuan yang Menjadi Legenda';
      case 'Ancestor':
        return 'Kejayaan Bagi Sang Ancestor!';
      case 'Herrscher':
        return 'Selamat Datang Yang Mulia Herrscher Sang Penguasa Game!';
      default:
        return '';
    }
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Apakah Anda yakin ingin Logout?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
              },
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                _logout(context);
              },
              child: Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }
}
