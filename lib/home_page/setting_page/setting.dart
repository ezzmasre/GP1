// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:wibsite/home_page/account_page/Edit.dart';
import 'package:wibsite/home_page/account_page/account.dart';
import 'package:wibsite/home_page/account_page/displayuservedios.dart';
import 'package:wibsite/home_page/setting_page/HelpSupport.dart';
import 'package:wibsite/home_page/setting_page/waternotifction.dart';
import 'package:wibsite/home_page/setting_page/media.dart';
import 'package:wibsite/home_page/setting_page/notification.dart';
import 'package:wibsite/home_page/setting_page/privcy.dart';
import 'package:wibsite/sign_inmoblie/auth.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
   final Authservce auth = Authservce();
    String? currentUserEmail;
    String? currentname;
   void initState() {
    super.initState();
    currentUserEmail = auth.getcurrentuser()?.email;
    if (currentUserEmail != null) {
      fetchUserVideos(currentUserEmail!);
    }
  }
   Future<void> fetchUserVideos(String email) async {
    final url = Uri.parse('https://fitnes-bakeend.onrender.com/pro/$email');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        String a=  data["name"] ?? "";
     

        setState(() {
          currentname = a;
        });
      } else {
        print('Failed to fetch data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color.fromARGB(255, 20, 18, 18)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Settings',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(
                      'https://i.pravatar.cc/150?img=12'), // Sample user image
                ),
                title: Text(
                  '$currentname',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
                subtitle: Text(
                  'No evidence say you try 😜',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              SizedBox(height: 20),
              _buildSettingsItem(
                Icons.person,
                'Account',
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AccountPage()),
                  );
                  print('Account pressed');
                },
              ),
              SizedBox(height: 10),
              _buildSettingsItem(
                Icons.edit,
                'Edit Profile',
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Edit()),
                  );
                  print('Edit Profile pressed');
                },
              ),
              SizedBox(height: 10),
              _buildSettingsItem(
                Icons.local_drink,
                'Water Notification',
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => WaterNotification()),
                  );
                },
              ),
              SizedBox(height: 10),
              _buildSettingsItem(
                Icons.photo,
                'My Vedios',
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DisplayUserVideos()),
                  );
                  print('Media pressed');
                },
              ),
              SizedBox(height: 10),
              _buildSettingsItem(
                Icons.notifications,
                'Notifications',
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NotificationsPage()),
                  );
                  print('Notifications pressed');
                },
              ),
              SizedBox(height: 10),
              _buildSettingsItem(
                Icons.lock,
                'Privacy',
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PrivacyPage()),
                  );
                  print('Privacy pressed');
                },
              ),
              SizedBox(height: 10),
              _buildSettingsItem(
                Icons.chat,
                'Help and support',
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HelpSupportPage()),
                  );
                  print('Help and Support pressed');
                },
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsItem(
      IconData icon, String title, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(color: Color(0xff1C1C1E)),
      child: ListTile(
        leading: Icon(icon, color: Colors.white),
        title: Text(
          title,
          style: TextStyle(color: Colors.white),
        ),
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
        onTap: onPressed,
      ),
    );
  }
}
