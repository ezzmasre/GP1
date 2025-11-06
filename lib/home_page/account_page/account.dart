import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart'; // Add this import
import 'package:wibsite/home_page/account_page/Edit.dart';
import 'package:wibsite/saving_data/save_data.dart';
import 'package:wibsite/sign_inmoblie/auth.dart';
import 'package:wibsite/sign_inmoblie/signin_moblie.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final Authservce auth = Authservce();
  String? savedString;
  String name = "";
  String email = "";
  String password = "";
  int age = 1;
  int weaight = 1;

  // List of avatar images
  final List<String> avatarImages = [
    'assets/avatar1.png',
    'assets/avatar2.png',
    'assets/avatar3.png',
    'assets/avatar4.png',
    'assets/avatar5.png',
    'assets/avatar6.png',
    'assets/avatar7.png',
      'assets/avatar8.png',
    'assets/avatar9.png',
    'assets/avatar10.png',
    'assets/avatar11.png',
    'assets/avatar12.png',
    'assets/avatar13.png',
    'assets/avatar14.png',
    'assets/avatar15.png'
  ];

  int selectedAvatarIndex = 0; // Index of the selected avatar

  @override
  void initState() {
    final currentUserEmail = auth.getcurrentuser()!.email;
    super.initState();
    loadString();
    searchById('$currentUserEmail'); // Automatically call searchById
    loadSelectedAvatarIndex().then((index) {
      setState(() {
        selectedAvatarIndex = index;
      });
    });
  }

  Future<void> loadString() async {
    String? data = await getString(); // Get the string from SharedPreferences
    setState(() {
      savedString = data;
    });
  }

  void searchById(String id) async {
    final url = Uri.parse('https://fitnes-bakeend.onrender.com/pro/$id');

    try {
      final response = await http.get(url);
      print('the save string $id');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(data);
        setState(() {
          name = data['name'] ?? 'No name';
          email = data['email'] ?? 'No email';
          password = data['password'] ?? 'No password';
          age = data['age'] ?? 0;
          weaight = data['weight'] ?? 0;
        });
      } else {
        print('Product not found!');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  // Save the selected avatar index
  Future<void> saveSelectedAvatarIndex(int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('selectedAvatarIndex', index);
  }

  // Load the selected avatar index
  Future<int> loadSelectedAvatarIndex() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('selectedAvatarIndex') ?? 0;
  }

  // Change the avatar
  void changeAvatar(int index) {
    setState(() {
      selectedAvatarIndex = index;
    });
    saveSelectedAvatarIndex(index); // Save the selected index
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color.fromARGB(255, 20, 18, 18)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        title: const Text(
          'Account',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  // Show a dialog to select an avatar
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Select Avatar'),
                        content: SizedBox(
                          width: double.maxFinite,
                          child: GridView.builder(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                            itemCount: avatarImages.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  changeAvatar(index);
                                  Navigator.pop(context);
                                },
                                child: CircleAvatar(
                                  backgroundImage: AssetImage(avatarImages[index]),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                  backgroundImage: AssetImage(avatarImages[selectedAvatarIndex]),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Icon(Icons.person, color: Colors.white),
                  const SizedBox(width: 10),
                  Text(
                    'Name: $name',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.email, color: Colors.grey),
                  const SizedBox(width: 10),
                  Text(
                    'Email: $email',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.lock, color: Colors.grey),
                  const SizedBox(width: 10),
                  Text(
                    'Password: $password',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.cake, color: Colors.grey),
                  const SizedBox(width: 10),
                  Text(
                    'Age: $age',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.monitor_weight, color: Colors.grey),
                  const SizedBox(width: 10),
                  Text(
                    'Weight: $weaight',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.height, color: Colors.grey),
                  const SizedBox(width: 10),
                  Text(
                    'Height: $weaight',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const signin_mobilState()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffD5FF5F),
                    ),
                    child: const Text(
                      'Log Out',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(width: 5),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Edit()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffD5FF5F),
                    ),
                    child: const Text(
                      'Edit Profile',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}