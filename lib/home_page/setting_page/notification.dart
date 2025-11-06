import 'package:flutter/material.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  Color ezz = Colors.white;
  bool _pushNotifications = true;
  bool _sound = true;
  bool _vibration = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              color: Color.fromARGB(255, 255, 255, 255)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Notifications',
            style: TextStyle(
              color: Color.fromARGB(255, 255, 255, 255),
            )),
        backgroundColor: Colors.black,
      ),
      body: Container(
        color: Colors.black, // Black background
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'General Settings',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ezz, // Text color
              ),
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: Icon(Icons.notifications, color: ezz),
              title: Text(
                'Push Notifications',
                style: TextStyle(color: ezz),
              ),
              trailing: Switch(
                activeColor: Colors.blue,
                value: _pushNotifications,
                onChanged: (bool value) {
                  setState(() {
                    _pushNotifications = value;
                  });
                  // Add logic for enabling/disabling push notifications
                },
              ),
            ),
            ListTile(
              leading: Icon(Icons.volume_up, color: ezz),
              title: Text(
                'Sound',
                style: TextStyle(color: ezz),
              ),
              trailing: Switch(
                activeColor: Colors.blue,
                value: _sound,
                onChanged: (bool value) {
                  setState(() {
                    _sound = value;
                  });
                  // Add logic for enabling/disabling sound alerts
                },
              ),
            ),
            ListTile(
              leading: Icon(Icons.vibration, color: ezz),
              title: Text(
                'Vibration',
                style: TextStyle(color: ezz),
              ),
              trailing: Switch(
                activeColor: Colors.blue,
                value: _vibration,
                onChanged: (bool value) {
                  setState(() {
                    _vibration = value;
                  });
                  // Add logic for enabling/disabling vibration alerts
                },
              ),
            ),
            Divider(color: ezz),
            Text(
              'Notification Preferences',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ezz, // Text color
              ),
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: Icon(Icons.shopping_cart, color: ezz),
              title: Text(
                'Promotions',
                style: TextStyle(color: ezz),
              ),
              trailing: Switch(
                activeColor: Colors.blue,
                value: true,
                onChanged: (bool value) {
                  // Logic to enable/disable promotion notifications
                },
              ),
            ),
            ListTile(
              leading: Icon(Icons.account_circle, color: ezz),
              title: Text(
                'Account Activity',
                style: TextStyle(color: ezz),
              ),
              trailing: Switch(
                activeColor: Colors.blue,
                value: true,
                onChanged: (bool value) {
                  // Logic to enable/disable account activity notifications
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
