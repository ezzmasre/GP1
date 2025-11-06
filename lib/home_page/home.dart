// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, dead_code

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wibsite/chat/display_couch.dart';
import 'package:wibsite/home_page/account_page/account.dart';
import 'package:wibsite/home_page/account_page/displayuservedios.dart';
import 'package:wibsite/home_page/account_page/user_vedios.dart';
import 'package:wibsite/home_page/ai_chat/interface.dart';
import 'package:wibsite/home_page/food_page/meals.dart';
import 'package:wibsite/home_page/myHome.dart';
import 'package:wibsite/home_page/setting_page/setting.dart';
import 'package:wibsite/home_page/workout.dart/workouticon.dart';
import 'package:wibsite/notificationss/notifacationbody.dart';
import 'package:wibsite/saving_data/save_data.dart';
import 'package:wibsite/sign_inmoblie/auth.dart';
import 'package:wibsite/sign_inmoblie/signin_moblie.dart';

class Home_Page extends StatelessWidget {
  const Home_Page({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  final int initialIndex;
  const MainPage({super.key, this.initialIndex = 0});
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  //int _currentIndex = 0;
  late int _currentIndex;
  String? savedString;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex; // Use the passed initialIndex
    loadString();
    print("hello $savedString "); // Load the saved string when the page loads
  }

  Future<void> loadString() async {
    String? data = await getString(); // Get the string from SharedPreferences
    setState(() {
      savedString = data;
      // Update the UI with the retrieved data
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget createDrawerItem(
        {required IconData icon,
        required String text,
        required VoidCallback onTap,
        Color? color}) {
      return ListTile(
        leading: Icon(icon, color: color ?? Color(0xffD5FF5F)),
        title: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 20),
        onTap: onTap,
      );
    }

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 0, 0),
      appBar: AppBar(
        backgroundColor: Color(0xFF232121),
        title: Text('Home Page $savedString',
            style: TextStyle(color: Color(0xffD5FF5F))),
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(
              Icons.menu,
              color: Color(0xffD5FF5F),
            ), // Custom menu icon
            onPressed: () {
              Scaffold.of(context)
                  .openDrawer(); // Open the drawer using the right context
            },
          ),
        ),
      ),
      drawer: Drawer(
        backgroundColor: Color(0xff1F1F28), // Darker background for the drawer
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xff25252D), // Slightly lighter header background
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 10,
                  )
                ],
              ),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'Dabhne Fitness',
                  style: TextStyle(
                    color: Color(0xffD5FF5F),
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            createDrawerItem(
              icon: Icons.home_outlined,
              text: 'Home',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MainPage()),
                );
              },
            ),
            createDrawerItem(
              icon: Icons.account_circle_outlined,
              text: 'Account',
              onTap: () {
               Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AccountPage()),
                );
              },
            ),
            createDrawerItem(
              icon: Icons.settings_outlined,
              text: 'Settings',
              onTap: () {
                 Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Setting()),
                );
              },
            ),
            Divider(color: Colors.grey.shade600, thickness: 1),
            createDrawerItem(
              icon: Icons.fitness_center,
              text: 'Workout-GPT',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChatBotPage()),
                );
              },
            ),
            createDrawerItem(
              icon: Icons.chat_bubble,
              text: 'Chating-Hub',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DisplayCouch()),
                );
              },
            ),
            Divider(color: Colors.grey.shade600, thickness: 1),
            createDrawerItem(
              icon: Icons.video_collection_sharp,
              text: 'My Vedios',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DisplayUserVideos()),
                );
              },
            ),
            createDrawerItem(
              icon: Icons.feedback_outlined,
              text: 'Give Us Feedback',
              onTap: () {
                Navigator.pop(context);
              },
            ),
            createDrawerItem(
              icon: Icons.notification_add_outlined,
              text: 'Add-Notifacation',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Notifacationbody()),
                );
              },
            ),
            Divider(color: Colors.grey.shade600, thickness: 1),
            createDrawerItem(
              icon: Icons.logout,
              text: 'Log Out',
              color: Colors
                  .redAccent, // Red color for log out to make it stand out
              onTap: () {
                // Log out action here
                final Aut = Authservce();
                Aut.signout();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => signin_mobilState()),
                );
              },
            ),
          ],
        ),
      ),
      body: _getBody(),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(
            12.0), // Add some space around the BottomNavigationBar
        child: ClipRRect(
          borderRadius:
              BorderRadius.circular(30.0), // Makes the corners circular
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
                // if (_currentIndex == 4) {
                //   Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) =>
                //             Setting()), // Replace with your target page
                //   );
                // } // Update the selected index
              });
            },
            selectedItemColor: Color(0xffD5FF5F),
            unselectedItemColor: Colors.grey,
            backgroundColor:
                Color.fromARGB(255, 35, 33, 33), // Custom background color
            elevation: 0, // Removes the shadow/elevation
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.restaurant_menu),
                label: 'Meal',
              ),
              BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.dumbbell),
                label: 'Workout',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_circle),
                label: 'Account',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Setting',
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Method to return the current page widget
  Widget _getBody() {
    if (_currentIndex == 0) {
      return MyHome();
    } else if (_currentIndex == 1) {
      return MealPage();
    } else if (_currentIndex == 2) {
      return workout();
    } else if (_currentIndex == 3) {
      return AccountPage();
    } else if (_currentIndex == 4) {
      return Setting();
    } else {
      return Center(child: Text('Select a page'));
    }
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Welcome to the Home Page!'),
    );
  }
}

class ServicePage extends StatelessWidget {
  const ServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Welcome to the Service Page!'),
    );
  }
}
