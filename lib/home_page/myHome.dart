import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:wibsite/home_page/dailyActivity.dart';
import 'package:wibsite/home_page/distance_counter_page.dart';
import 'package:wibsite/home_page/running_counter_page.dart';
import 'package:wibsite/home_page/sleep_tracker_page.dart';
import 'package:wibsite/providers/distance_provider.dart';
import 'package:wibsite/providers/running_provider.dart';
import 'package:http/http.dart' as http;
import 'package:wibsite/sign_inmoblie/auth.dart';

import 'food_page/FoodForToday.dart';
import 'food_page/meals.dart';
import 'package:wibsite/home_page/home.dart';

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  final Authservce auth = Authservce();
  String name = "";

  String? currentUserEmail;

  @override
  void initState() {
    super.initState();
    currentUserEmail = auth.getcurrentuser()?.email;
    searchById(currentUserEmail!);
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
        });
      } else {
        print('Product not found!');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Header(name: name), // Pass the name variable here
              const SizedBox(height: 20),
              const DailyActivityCard(),
              const SizedBox(height: 20),
              const WorkoutsCard(),
              const SizedBox(height: 20),
              Consumer<MealProvider>(
                builder: (context, mealProvider, child) {
                  return FoodTrackerCard(
                    consumedCalories: mealProvider.totalCalories,
                    totalCalories: 2000, // You can change this based on user goals
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Header extends StatelessWidget {
  final String name; // Add a name parameter

  const Header({super.key, required this.name}); // Require name in the constructor

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello  $name ', // Use the passed name
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
            const Text(
              'Let\'s start your day',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SleepTrackerPage()),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[800], // Background color
            ),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.nights_stay, color: Color(0xFFb3ff00), size: 30), // Moon icon
            ),
          ),
        ),
      ],
    );
  }
}

class DailyActivityCard extends StatelessWidget {
  const DailyActivityCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DistanceProvider>(
      builder: (context, distanceProvider, child) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF2d2d36),
            borderRadius: BorderRadius.circular(35),
          ),
          height: 220,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Daily Activity', style: TextStyle(color: Colors.white, fontSize: 18)),
                    const SizedBox(height: 10),
                   buildActivityRow(
                    'Walk', 
                    distanceProvider.distance.toStringAsFixed(2), 
                    '5.00 km'
                  ),
                  buildActivityRow(
                    'Calories', 
                    '${distanceProvider.calories}', 
                    '680 Cal'
                  ),
                    buildActivityRow('Water', '0.0', '2.5 L'),
                  ],
                ),
              ),
              Expanded(
                child: SizedBox(
                // You can specify width for the gif if needed, height is now dynamic
                width: 200, // Set width for the gif image
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const DailyActivityPage()),
                    );
                  },
                  child: Image.asset('assets/progress_bars.gif',
                      fit: BoxFit.cover),
                ),
              ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildActivityRow(String label, String numerator, String denominator) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: numerator,
                style: const TextStyle(color: Color(0xFFd5ff5f), fontSize: 20),
              ),
              TextSpan(
                text: ' / $denominator',
                style: const TextStyle(color: Color(0xFFd5ff5f), fontSize: 16),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class WorkoutsCard extends StatelessWidget {
  const WorkoutsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2d2d36),
        borderRadius: BorderRadius.circular(35),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Workouts', style: TextStyle(color: Colors.white, fontSize: 18)),
          SizedBox(height: 10),
          WorkoutItem(
            icon: Icons.directions_walk,
            title: 'Outdoor Walk',
            distance: '0.00 km',
            time: 'Today',
          ),
          WorkoutItem(
            icon: Icons.directions_run,
            title: 'Morning Running',
            distance: '0.00 km',
            time: 'Today',
          ),
        ],
      ),
    );
  }
}

class WorkoutItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String distance;
  final String time;

  const WorkoutItem({
    super.key,
    required this.icon,
    required this.title,
    required this.distance,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer2<DistanceProvider, RunningProvider>(
      builder: (context, distanceProvider, runningProvider, child) {
        return Container(
          padding: const EdgeInsets.all(15),
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: const Color(0xFF1e1e25),
            borderRadius: BorderRadius.circular(35),
          ),
          child: Row(
            children: [
              Icon(icon, color: const Color(0xFFd5ff5f), size: 30),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(color: Colors.white)),
                    Text(
                      title == 'Outdoor Walk'
                          ? '${distanceProvider.distance.toStringAsFixed(2)} km'
                          : title == 'Morning Running'
                              ? '${runningProvider.runningDistance.toStringAsFixed(2)} km'
                              : distance,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: title == 'Outdoor Walk'
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DistanceCounterPage(),
                          ),
                        );
                      }
                    : title == 'Morning Running'
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RunningCounterPage(),
                              ),
                            );
                          }
                        : null,
                child: Row(
                  children: [
                    Text(time, style: const TextStyle(color: Colors.grey)),
                    const Icon(Icons.chevron_right, color: Colors.grey),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class FoodTrackerCard extends StatelessWidget {
  final int consumedCalories;
  final int totalCalories;

  const FoodTrackerCard({
    super.key,
    required this.consumedCalories,
    required this.totalCalories,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2d2d36),
        borderRadius: BorderRadius.circular(35),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Food',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$consumedCalories / $totalCalories Cal',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const FoodForToday()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFd5ff5f),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  'Record',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Meal Tips',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          const SizedBox(height: 10),
          const MealTips(),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MainPage(
                    initialIndex: 1, // Pass 1 to navigate to MealPage
                  ),
                ),
              );
            },
            child: const Text(
              'See All',
              style: TextStyle(
                color: Color(0xFFD5FF5F),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MealTips extends StatelessWidget {
  const MealTips({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MealDetailsPage(
                  imagePath: "assets/meals/grilled_chicken.jpg",
                  title: 'Grilled Chicken Wrap',
                  time: '25 min',
                  calories: '350 Cal',
                  description:
                      "A delicious wrap filled with grilled chicken, fresh lettuce, and tangy sauce.",
                  ingredients:
                      "Chicken Breast, Tortilla Wrap, Lettuce, Yogurt Sauce, Spices.",
                  instructions:
                      "1. Grill the chicken until cooked through and juicy.\n2. Lay out a tortilla wrap and place fresh lettuce on top.\n3. Slice the grilled chicken and place it on top of the lettuce.\n4. Drizzle with yogurt sauce and sprinkle with your favorite spices.\n5. Roll up the wrap and enjoy.",
                ),
              ),
            );
          },
          child: const MealTip(
            imagePath: "assets/meals/grilled_chicken.jpg",
            title: 'Grilled Chicken Wrap',
            time: '25 min',
            calories: '350 Cal',
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MealDetailsPage(
                  imagePath: "assets/meals/quinoa_salad.jpg",
                  title: "Quinoa Salad with Avocado",
                  time: '20 min',
                  calories: '400 Cal',
                  description:
                      "A protein-packed quinoa salad with fresh avocado, cherry tomatoes, and a lemon vinaigrette.",
                  ingredients:
                      "Quinoa, Avocado, Cherry Tomatoes, Lemon, Olive Oil, Salt, Pepper.",
                  instructions:
                      "1. Cook the quinoa according to package instructions.\n2. Dice the avocado and cherry tomatoes.\n3. Toss the quinoa, avocado, and tomatoes together in a large bowl.\n4. Drizzle with lemon vinaigrette made from lemon juice, olive oil, salt, and pepper.\n5. Serve chilled or at room temperature.",
                ),
              ),
            );
          },
          child: const MealTip(
            imagePath: "assets/meals/quinoa_salad.jpg",
            title: "Quinoa Salad with Avocado",
            time: '20 min',
            calories: '400 Cal',
          ),
        ),
      ],
    );
  }
}

class MealTip extends StatelessWidget {
  final String imagePath;
  final String title;
  final String time;
  final String calories;

  const MealTip({
    super.key,
    required this.imagePath,
    required this.title,
    required this.time,
    required this.calories,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      height: 180,
      decoration: BoxDecoration(
        color: const Color(0xFF3a3a3c),
        borderRadius: BorderRadius.circular(35),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            child: Container(
              width: 160,
              height: 60,
              decoration: const BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(35)),
              ),
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(FontAwesomeIcons.clock, color: Colors.white, size: 12),
                          const SizedBox(width: 5),
                          Text(time, style: const TextStyle(color: Colors.white, fontSize: 12)),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(FontAwesomeIcons.fire, color: Colors.white, size: 12),
                          const SizedBox(width: 5),
                          Text(calories, style: const TextStyle(color: Colors.white, fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: const Color(0xFF2d2d36),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            onPressed: () {},
            icon: const Icon(FontAwesomeIcons.house, color: Colors.white),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(FontAwesomeIcons.codeFork, color: Colors.white),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(FontAwesomeIcons.dumbbell, color: Color(0xFFc4ff00), size: 30),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(FontAwesomeIcons.chartBar, color: Colors.white),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.account_circle, color: Colors.white),
          ),
        ],
      ),
    );
  }
}