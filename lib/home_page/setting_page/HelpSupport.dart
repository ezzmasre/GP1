import 'package:flutter/material.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              color: Color.fromARGB(255, 255, 255, 255)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Help & Support',
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: Container(
        color: Colors.black,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading:
                  const Icon(Icons.help, color: Colors.white), // Changed to white
              title: const Text('FAQs',
                  style: TextStyle(color: Colors.white)), // Changed to white
              trailing: const Icon(Icons.arrow_forward_ios,
                  color: Colors.white), // Changed to white
              onTap: () {
                // Navigate to FAQ page
              },
            ),
            const Divider(color: Colors.white), // Changed to white
            ListTile(
              leading: const Icon(Icons.contact_support,
                  color: Colors.white), // Changed to white
              title: const Text('Contact Support',
                  style: TextStyle(color: Colors.white)), // Changed to white
              trailing: const Icon(Icons.arrow_forward_ios,
                  color: Colors.white), // Changed to white
              onTap: () {
                // Navigate to contact support page
              },
            ),
            const Divider(color: Colors.white), // Changed to white
            ListTile(
              leading:
                  const Icon(Icons.info, color: Colors.white), // Changed to white
              title: const Text('App Info',
                  style: TextStyle(color: Colors.white)), // Changed to white
              trailing: const Icon(Icons.arrow_forward_ios,
                  color: Colors.white), // Changed to white
              onTap: () {
                // Navigate to app info page
              },
            ),
          ],
        ),
      ),
    );
  }
}
