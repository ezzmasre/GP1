// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:wibsite/home_page/workout.dart/Patientspages/Patients.dart';
import 'package:wibsite/home_page/workout.dart/fitnessTap.dart';
import 'package:wibsite/home_page/workout.dart/trainng.dart';
import 'package:wibsite/home_page/workout.dart/workoutpage.dart';

// Define the Workout model
class Workout {
  final String title;
  final String imageUrl;
  final int duration;
  final String difficulty;
  final List<WorkoutVideo> videos;

  Workout({
    required this.title,
    required this.imageUrl,
    required this.duration,
    required this.difficulty,
    required this.videos,
  });
}

// Define the WorkoutVideo model
class WorkoutVideo {
  final String title;
  final String videoUrl;

  WorkoutVideo({required this.title, required this.videoUrl});
}

class workout extends StatelessWidget {
  const workout({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const home(),
    );
  }
}

class home extends StatelessWidget {
  const home({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4, // Adjust the length to match the number of tabs
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0, // Remove shadow for a cleaner look
          flexibleSpace: PreferredSize(
            preferredSize: const Size.fromHeight(50), // Adjust height here
            child: const TabBar(
              isScrollable: true, // Enable scrolling for the TabBar
              tabs: [
                Tab(
                  text: 'In-Door ',
                  icon: Icon(Icons.fitness_center),
                ),
                Tab(
                  text: 'Out-Door',
                  icon: Icon(Icons.directions_run),
                ),
                Tab(
                  text: 'Stretching',
                  icon: Icon(Icons.accessibility_new),
                ),
                Tab(
                  text: 'Helping',
                  icon: Icon(Icons.healing),
                ),
              ],
              indicatorColor: Colors.white,
              indicatorWeight: 3.0,
              labelColor: Colors.green,
              unselectedLabelColor: Colors.grey,
              labelStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              unselectedLabelStyle: TextStyle(
                fontWeight: FontWeight.normal,
              ),
              indicatorPadding: EdgeInsets.symmetric(horizontal: 16.0),
            ),
          ),
        ),
        body: const TabBarView(
          children: [
            WorkoutPage(),
            FitnessTab(),
            Trainng(),
            PatientsPage(), // Adjust with your desired widgets
          ],
        ),
      ),
    );
  }
}
