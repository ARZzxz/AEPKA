import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LeaderboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Leaderboard'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .orderBy('exp', descending: true)
            .limit(50)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final users = snapshot.data!.docs;
          final filteredUsers = users.where((doc) => (doc.data() as Map<String, dynamic>).containsKey('nickname')).toList();

          return ListView.builder(
            itemCount: filteredUsers.length,
            itemBuilder: (context, index) {
              final user = filteredUsers[index].data() as Map<String, dynamic>;
              final String nickname = user.containsKey('nickname') ? user['nickname'] : 'Unknown';
              final int exp = user.containsKey('exp') ? (user['exp'] as num).toInt() : 0;

              return Container(
                margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
                padding: EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: index == 0
                      ? Colors.amber[100]
                      : index == 1
                          ? Colors.grey[300]
                          : index == 2
                              ? Colors.brown[200]
                              : Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4.0,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Stack(
                  clipBehavior: Clip.none, // Allow badge to overflow
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        radius: 18.0, // Adjust radius to fit badge and number
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 14.0,
                          ),
                        ),
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                      title: Text(
                        nickname,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      trailing: Text(
                        '$exp pts',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                    if (index == 0) // Peringkat 1
                      Positioned(
                        top: 15, // Posisi badge di atas nomor peringkat
                        left: -10, // Horizontal positioning
                        child: Icon(
                          Icons.star, // Badge icon
                          color: Colors.amber,
                          size: 24.0,
                        ),
                      ),
                    if (index == 1) // Peringkat 2
                      Positioned(
                        top: 30, // Posisi badge di atas nomor peringkat
                        left: -10, // Horizontal positioning
                        child: Icon(
                          Icons.star, // Badge icon
                          color: Colors.grey,
                          size: 24.0,
                        ),
                      ),
                    if (index == 2) // Peringkat 3
                      Positioned(
                         top: 15, // Posisi badge di atas nomor peringkat
                        left: -10, // Horizontal positioning
                        child: Icon(
                          Icons.star, // Badge icon
                          color: Colors.brown, // Use appropriate color
                          size: 24.0,
                        ),
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
