import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wibsite/home_page/food_page/meals.dart';

class FoodForToday extends StatelessWidget {
  const FoodForToday({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0), // Dark background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Meals For Today',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              color: Color(0xFFd5ff5f)), //  back arrow
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Consumer<MealProvider>(
        builder: (context, mealProvider, child) {
          // Group meals by category
          final Map<String, List<Meal>> groupedMeals = {};
          for (var meal in mealProvider.meals) {
            if (!groupedMeals.containsKey(meal.category)) {
              groupedMeals[meal.category] = [];
            }
            groupedMeals[meal.category]?.add(meal);
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: groupedMeals.keys.map((category) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      ...groupedMeals[category]!.map((meal) {
                        return MealCard(
                          meal: meal,
                          onRemove: () {
                            // Remove the meal
                            mealProvider.removeMeal(meal);
                          },
                        );
                        // ignore: unnecessary_to_list_in_spreads
                      }).toList(),
                      const SizedBox(height: 20),
                    ],
                  );
                }).toList(),
              ),
            ),
          );
        },
      ),
    );
  }
}

class MealCard extends StatelessWidget {
  final Meal meal;
  final VoidCallback onRemove;

  const MealCard({
    super.key,
    required this.meal,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF1a1a1e),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Align items at the top
          children: [
            // Meal Image with Red Border
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 1), // White border
                borderRadius: BorderRadius.circular(10), // Rounded corners
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  meal.imagePath,
                  width: 100, // Set width to control the image size
                  height: 100, // Set height to match text height
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 10), // Space between image and text

            // Meal Title and Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    meal.title,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${meal.time} | 🔥 ${meal.calories} cal',
                    style: const TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            // Remove icon
            IconButton(
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
              onPressed: onRemove,
            ),
          ],
        ),
      ),
    );
  }
}
