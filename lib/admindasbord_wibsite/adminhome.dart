import 'package:flutter/material.dart';
import 'package:wibsite/admindasbord_wibsite/coutch.dart';
import 'package:wibsite/admindasbord_wibsite/doctor.dart';
import 'package:wibsite/admindasbord_wibsite/user.dart';
import 'package:wibsite/admindasbord_wibsite/vedios/ChestVideosPage.dart';
import 'package:wibsite/admindasbord_wibsite/vedios/Depression.dart';
import 'package:wibsite/admindasbord_wibsite/vedios/FITNESS.dart';
import 'package:wibsite/admindasbord_wibsite/vedios/Knee.dart';
import 'package:wibsite/admindasbord_wibsite/vedios/Obesity.dart';
import 'package:wibsite/admindasbord_wibsite/vedios/Osteoporosis.dart';
import 'package:wibsite/admindasbord_wibsite/vedios/backvedios.dart';
import 'package:wibsite/admindasbord_wibsite/vedios/bisibsvedios.dart';
import 'package:wibsite/admindasbord_wibsite/vedios/desk.dart';
import 'package:wibsite/admindasbord_wibsite/vedios/headache%20.dart';
import 'package:wibsite/admindasbord_wibsite/vedios/legs.dart';
import 'package:wibsite/admindasbord_wibsite/vedios/pressure.dart';
import 'package:wibsite/admindasbord_wibsite/vedios/shoulder.dart';
import 'package:wibsite/admindasbord_wibsite/vedios/stress.dart';
import 'package:wibsite/admindasbord_wibsite/vedios/trainingvedios.dart';
import 'package:wibsite/admindasbord_wibsite/vedios/tricibsvedios.dart';

class Adminhome extends StatefulWidget {
  const Adminhome({super.key});

  @override
  State<Adminhome> createState() => _AdminhomeState();
}

class _AdminhomeState extends State<Adminhome> {
  // To track which menu is selected
  String selectedMenu = 'User';

  // List of menu items and their icons
  final List<Map<String, dynamic>> menuItems = [
    {'title': 'User', 'icon': Icons.person},
    {'title': 'Coutch', 'icon': Icons.person_2_sharp},
    {'title': 'Doctor', 'icon': Icons.person_2_sharp},
    {'title': 'Chest Videos', 'icon': Icons.video_library},
    {'title': 'Back Videos', 'icon': Icons.video_library},
    {'title': 'Triceps Videos', 'icon': Icons.video_library},
    {'title': 'Biceps Videos', 'icon': Icons.video_library},
    {'title': 'shoulder Videos', 'icon': Icons.video_library},
    {'title': 'Legs Videos', 'icon': Icons.video_library},
    {'title': 'Training Videos', 'icon': Icons.video_library},
    {'title': 'Fitness Videos', 'icon': Icons.video_library},
    {'title': 'Obesity Videos', 'icon': Icons.video_library},
    {'title': 'Headache Videos', 'icon': Icons.video_library},
    {'title': 'Desk Videos', 'icon': Icons.video_library},
    {'title': 'Pressure Videos', 'icon': Icons.video_library},
    {'title': 'Knee Videos', 'icon': Icons.video_library},
    {'title': 'Osteoporosis Videos', 'icon': Icons.video_library},
    {'title': 'Depression Videos', 'icon': Icons.video_library},
    {'title': 'Stress Videos', 'icon': Icons.video_library},
  ];

  // Method to display specific content based on the selected menu
  Widget getContent(String menu) {
    switch (menu) {
      case 'User':
        return const UserPage();
      case 'Coutch':
        return const coutchpage();
      case 'Doctor':
        return const Doctor();
      case 'Chest Videos':
        return const Chestvideospage();
      case 'Back Videos':
        return const Backvedios();
      case 'Legs Videos':
        return const Legs();
      case 'Triceps Videos':
        return const Tricibsvedios();
      case 'Biceps Videos':
        return const Bisibsvedios();
      case 'shoulder Videos':
        return const Shoulder();
      case 'Training Videos':
        return const Trainingvedios();
      case 'Fitness Videos':
        return const Fitnessvedio();
      case 'Obesity Videos':
        return const Obesity();
      case 'Headache Videos':
        return const Headache();
      case 'Desk Videos':
        return const Desk();
      case 'Pressure Videos':
        return const Pressure();
      case 'Knee Videos':
        return const Knee();
      case 'Osteoporosis Videos':
        return const Osteoporosis();
      case 'Depression Videos':
        return const Depression();
      case 'Stress Videos':
        return const Stress();
      default:
        return Scaffold(
          body: Center(
            child: Text(
              'Page not found for $menu',
              style: TextStyle(
                color: const Color(0xffD5FF5F).withOpacity(0.8),
                fontSize: 20,
              ),
            ),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Black theme
      appBar: AppBar(
        backgroundColor: Colors.black, // Black AppBar
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildAppBarText('Profile'),
            const SizedBox(width: 20),
            _buildAppBarText('Home'),
            const SizedBox(width: 20),
            _buildAppBarText('Contact'),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: const Color(0xffD5FF5F).withOpacity(0.2),
            height: 0.5,
          ),
        ),
      ),
      body: Row(
        children: [
          // Left menu
          Container(
            width: 200,
            decoration: BoxDecoration(
              color: Colors.black,
              border: Border(
                right: BorderSide(
                  color: const Color(0xffD5FF5F).withOpacity(0.2),
                  width: 1,
                ),
              ),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border(
                      bottom: BorderSide(
                        color: const Color(0xffD5FF5F).withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Menu',
                      style: TextStyle(
                        color: const Color(0xffD5FF5F),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: menuItems.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 8),
                        decoration: BoxDecoration(
                          color: selectedMenu == menuItems[index]['title']
                              ? const Color(0xffD5FF5F).withOpacity(0.1)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          border: selectedMenu == menuItems[index]['title']
                              ? Border.all(
                                  color: const Color(0xffD5FF5F).withOpacity(0.5),
                                  width: 1,
                                )
                              : null,
                        ),
                        child: ListTile(
                          leading: Icon(
                            menuItems[index]['icon'],
                            color: const Color(0xffD5FF5F),
                          ),
                          title: Text(
                            menuItems[index]['title'],
                            style: TextStyle(
                              color: selectedMenu == menuItems[index]['title']
                                  ? const Color(0xffD5FF5F)
                                  : const Color(0xffD5FF5F).withOpacity(0.7),
                              fontWeight: selectedMenu == menuItems[index]['title']
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              selectedMenu = menuItems[index]['title'];
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          // Right content area
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black,
                    Colors.black.withOpacity(0.9),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: getContent(selectedMenu),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build AppBar text with glow effect
  Widget _buildAppBarText(String text) {
    return Text(
      text,
      style: TextStyle(
        color: const Color(0xffD5FF5F),
        fontSize: 16,
        fontWeight: FontWeight.bold,
        shadows: [
          Shadow(
            color: const Color(0xffD5FF5F).withOpacity(0.8),
            blurRadius: 10,
          ),
        ],
      ),
    );
  }
}