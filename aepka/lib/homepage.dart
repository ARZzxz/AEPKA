import 'package:flutter/material.dart';
import 'moral_page.dart'; // Import file MoralPage
import 'profile.dart'; // Import file profile.dart

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( 
        title: Text('Home'),
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
      body: Stack(
        children: <Widget>[
          // Background image
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/background/background_image.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // Content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              UserProfile(),
              SizedBox(height: 20),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    children: <Widget>[
                      // Menu items
                      MenuItem(
                        icon: Icons.school,
                        label: 'Edukasi Moral',
                        onTap: () {
                          // Navigasi ke MoralPage saat menu "Edukasi Moral" ditekan
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => MoralPage()),
                          );
                        },
                      ),
                      MenuItem(
                        icon: Icons.favorite,
                        label: 'Edukasi Etika',
                        onTap: () {
                          // Action when menu is tapped
                        },
                      ),
                      // Add more menu items here
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.purple[200]!,
              Colors.purple[600]!,
            ],
          ),
        ),
        child: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Cari',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profil',
            ),
          ],
          currentIndex: 0,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.white,
          backgroundColor: Colors.transparent,
          onTap: (int index) {
            // Handle navigation bar item taps
            if (index == 2) {
              // Navigasi ke halaman profil saat item "Profil" ditekan
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            }
          },
        ),
      ),
    );
  }
}

// Widget untuk menu item
class MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50),
            SizedBox(height: 10),
            Text(
              label,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// Widget untuk profil user
class UserProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(Icons.account_circle, size: 50),
          SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nama User', style: TextStyle(fontSize: 18)),
              Text('Level: 10', style: TextStyle(fontSize: 16)),
              Text('Rank: Diamond', style: TextStyle(fontSize: 16)),
            ],
          ),
        ],
      ),
    );
  }
}
