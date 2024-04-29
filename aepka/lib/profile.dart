import 'package:flutter/material.dart';
import 'package:nes_ui/nes_ui.dart'; // Import library NES UI

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
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
            // Username
            Text(
              'Username: JohnDoe',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            // Status
            Text(
              'Status: Active',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            // Change Password Button
            NesButton(
              type: NesButtonType.primary,
              child: Text('Change Password'),
              onPressed: () {
                // Handle change password action
              },
            ),
            SizedBox(height: 10),
            // History
            Text(
              'History:',
              style: TextStyle(fontSize: 18),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: Text('History Item 1'),
                      subtitle: Text('Details of History Item 1'),
                    ),
                    ListTile(
                      title: Text('History Item 2'),
                      subtitle: Text('Details of History Item 2'),
                    ),
                    // Add more history items as needed
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            // Highest Score
            Text(
              'Highest Score: 1000',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            // Button to logout
            NesButton(
              type: NesButtonType.error,
              child: Text('Logout'),
              onPressed: () {
                // Show confirmation dialog before logging out
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Logout'),
                      content: Text('Apakah Anda yakin ingin logout?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                          child: Text('Batal'),
                        ),
                        TextButton(
                          onPressed: () {
                            // Handle logout action
                            // For example, navigate back to login page
                            Navigator.pushReplacementNamed(context, '/login'); // Go back to the login page
                          },
                          child: Text('Logout'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
