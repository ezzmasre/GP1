import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wibsite/home_page/food_page/chatai_withfood.dart';

// Meal model definition
class Meal {
  final String imagePath;
  final String title;
  final String category;
  final String calories;
  final String time; // Added time field

  Meal({
    required this.imagePath,
    required this.title,
    required this.category,
    required this.calories,
    required this.time, // Updated constructor
  });
}

// MealDetails model definition
class MealDetails {
  final String imagePath;
  final String title;
  final String time;
  final String calories;
  final String description;
  final String ingredients;
  final String instructions;

  MealDetails({
    required this.imagePath,
    required this.title,
    required this.time,
    required this.calories,
    required this.description,
    required this.ingredients,
    required this.instructions,
  });
}

// Meal Provider for Global State Management
class MealProvider with ChangeNotifier {
  final List<Meal> _meals = [];
  int _totalCalories = 0; // Track total calories

  List<Meal> get meals => List.unmodifiable(_meals);
  int get totalCalories => _totalCalories; // Getter for total calories

  void addMeal(Meal meal) {
    _meals.add(meal);
    _totalCalories +=
        int.parse(meal.calories.split(' ')[0]); // Extract and add calories
    notifyListeners();
  }

  void removeMeal(Meal meal) {
    _meals.remove(meal);
    _totalCalories -=
        int.parse(meal.calories.split(' ')[0]); // Subtract calories
    notifyListeners();
  }

  void clearMeals() {
    _meals.clear();
    _totalCalories = 0; // Reset calories
    notifyListeners();
  }
}

class MealPage extends StatelessWidget {
  const MealPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, List<MealDetails>> categorizedMealss = {
      "Breakfast": [
        MealDetails(
          imagePath: "assets/meals/avocado_toast.jpg",
          title: "Avocado Toast with Egg",
          time: "10 min",
          calories: "300 Cal",
          description:
              "A healthy and quick breakfast option with creamy avocado, boiled egg, and crispy toast.",
          ingredients: "Avocado, Egg, Whole Grain Bread, Salt, Pepper.",
          instructions:
              "1. Toast the bread until golden brown.\n2. Mash avocado and spread evenly on the toasted bread.\n3. Slice the boiled egg and arrange it on top of the avocado.\n4. Season with salt and pepper to taste.",
        ),
        MealDetails(
          imagePath: "assets/meals/hummus.jpg",
          title: "Hummus with Veggie Sticks",
          time: "5 min",
          calories: "150 Cal",
          description:
              "A light and nutritious snack perfect for dipping veggies into creamy hummus.",
          ingredients:
              "Hummus, Carrot Sticks, Cucumber Sticks, Bell Pepper Slices.",
          instructions:
              "1. Slice the carrot, cucumber, and bell pepper into sticks.\n2. Serve hummus in a small bowl.\n3. Dip the veggie sticks into the hummus and enjoy.",
        ),
        MealDetails(
          imagePath: "assets/meals/oatmeal.jpg",
          title: "Banana and Almond Oatmeal",
          time: "15 min",
          calories: "350 Cal",
          description:
              "A warm, hearty breakfast made with oats, banana slices, and almond butter.",
          ingredients: "Oats, Banana, Almond Butter, Milk, Honey.",
          instructions:
              "1. Cook oats in milk over medium heat until thickened.\n2. Add sliced bananas and almond butter to the oats.\n3. Drizzle honey over the oatmeal and stir to combine.\n4. Serve warm and enjoy your nutritious breakfast.",
        ),
      ],
      "Brunch": [
        MealDetails(
          imagePath: "assets/meals/quinoa_salad.jpg",
          title: "Quinoa Salad with Avocado",
          time: "20 min",
          calories: "400 Cal",
          description:
              "A protein-packed quinoa salad with fresh avocado, cherry tomatoes, and a lemon vinaigrette.",
          ingredients:
              "Quinoa, Avocado, Cherry Tomatoes, Lemon, Olive Oil, Salt, Pepper.",
          instructions:
              "1. Cook the quinoa according to package instructions.\n2. Dice the avocado and cherry tomatoes.\n3. Toss the quinoa, avocado, and tomatoes together in a large bowl.\n4. Drizzle with lemon vinaigrette made from lemon juice, olive oil, salt, and pepper.\n5. Serve chilled or at room temperature.",
        ),
        MealDetails(
          imagePath: "assets/meals/grilled_chicken.jpg",
          title: "Grilled Chicken Wrap",
          time: "25 min",
          calories: "350 Cal",
          description:
              "A delicious wrap filled with grilled chicken, fresh lettuce, and tangy sauce.",
          ingredients:
              "Chicken Breast, Tortilla Wrap, Lettuce, Yogurt Sauce, Spices.",
          instructions:
              "1. Grill the chicken until cooked through and juicy.\n2. Lay out a tortilla wrap and place fresh lettuce on top.\n3. Slice the grilled chicken and place it on top of the lettuce.\n4. Drizzle with yogurt sauce and sprinkle with your favorite spices.\n5. Roll up the wrap and enjoy.",
        ),
      ],
      "Lunch": [
        MealDetails(
          imagePath: "assets/meals/grilled_salmon.jpg",
          title: "Grilled Salmon with Veggies",
          time: "30 min",
          calories: "500 Cal",
          description:
              "A healthy lunch with grilled salmon and a side of roasted vegetables.",
          ingredients: "Salmon Fillet, Broccoli, Carrots, Olive Oil, Lemon.",
          instructions:
              "1. Grill the salmon fillet until the skin is crispy and the fish is cooked through.\n2. Toss broccoli and carrots in olive oil, salt, and pepper.\n3. Roast the vegetables in the oven at 400°F for 20 minutes.\n4. Squeeze fresh lemon over the grilled salmon and roasted veggies.\n5. Serve hot and enjoy your healthy lunch.",
        ),
        MealDetails(
          imagePath: "assets/meals/chicken_salad.jpg",
          title: "Chicken Caesar Salad",
          time: "15 min",
          calories: "350 Cal",
          description:
              "A classic Caesar salad with grilled chicken, croutons, and parmesan cheese.",
          ingredients:
              "Chicken Breast, Romaine Lettuce, Caesar Dressing, Croutons, Parmesan.",
          instructions:
              "1. Grill the chicken breast until fully cooked and slice into strips.\n2. In a large bowl, toss romaine lettuce with Caesar dressing.\n3. Add croutons and sprinkle with parmesan cheese.\n4. Top the salad with sliced chicken and serve.",
        ),
        MealDetails(
          imagePath: "assets/meals/veggie_bowl.jpg",
          title: "Veggie Buddha Bowl",
          time: "25 min",
          calories: "400 Cal",
          description:
              "A wholesome veggie bowl with quinoa, roasted sweet potato, and chickpeas.",
          ingredients: "Quinoa, Sweet Potato, Chickpeas, Avocado, Tahini.",
          instructions:
              "1. Roast the sweet potato and chickpeas in olive oil and seasoning at 400°F for 20 minutes.\n2. Cook quinoa according to package instructions.\n3. Assemble the bowl by adding quinoa, roasted veggies, and chickpeas.\n4. Top with avocado slices and drizzle with tahini sauce.\n5. Serve warm or cold.",
        ),
      ],
      "Snacks": [
        MealDetails(
          imagePath: "assets/meals/energy_balls.jpg",
          title: "Peanut Butter Energy Balls",
          time: "10 min",
          calories: "200 Cal",
          description:
              "Quick and easy energy balls made with peanut butter, oats, and chocolate chips.",
          ingredients: "Peanut Butter, Oats, Honey, Chocolate Chips.",
          instructions:
              "1. In a bowl, mix peanut butter, oats, honey, and chocolate chips.\n2. Roll the mixture into small balls using your hands.\n3. Refrigerate the energy balls for at least 30 minutes before serving.",
        ),
        MealDetails(
          imagePath: "assets/meals/fruit_salad.jpg",
          title: "Fresh Fruit Salad",
          time: "10 min",
          calories: "150 Cal",
          description:
              "A colorful mix of fresh seasonal fruits, perfect for a light snack.",
          ingredients: "Strawberries, Kiwi, Orange, Grapes, Honey.",
          instructions:
              "1. Chop the strawberries, kiwi, and orange into bite-sized pieces.\n2. Combine the fruit in a large bowl.\n3. Drizzle with honey and toss gently to coat.\n4. Serve chilled and enjoy.",
        ),
        MealDetails(
          imagePath: "assets/meals/greek_yogurt_parfait.jpg",
          title: "Greek Yogurt Parfait",
          time: "5 min",
          calories: "250 Cal",
          description:
              "A creamy parfait made with layers of Greek yogurt, honey, and fresh fruits.",
          ingredients: "Greek Yogurt, Honey, Granola, Mixed Berries.",
          instructions:
              "1. In a glass, layer Greek yogurt, mixed berries, and granola.\n2. Repeat the layers until the glass is full.\n3. Drizzle honey on top and enjoy a quick and nutritious snack.",
        ),
        MealDetails(
          imagePath: "assets/meals/smoothie_bowl.jpg",
          title: "Berry Smoothie Bowl",
          time: "10 min",
          calories: "250 Cal",
          description:
              "A refreshing smoothie bowl topped with fresh berries and granola.",
          ingredients: "Mixed Berries, Banana, Yogurt, Granola, Honey.",
          instructions:
              "1. Blend mixed berries, banana, and yogurt together until smooth.\n2. Pour the smoothie into a bowl.\n3. Top with granola, fresh berries, and a drizzle of honey.\n4. Serve immediately and enjoy.",
        ),
      ],
    };

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: const Color(0xFF1a1a1e), // Dark background
        appBar: AppBar(
          backgroundColor: const Color(0xFF1a1a1e), // Dark background
          title: const Text(
            'Meals',
            style: TextStyle(color: Colors.white),
          ),
          bottom: const TabBar(
            indicatorColor:
                Color(0xFFd5ff5f), // Highlight color for selected tab
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: 'Breakfast'),
              Tab(text: 'Brunch'),
              Tab(text: 'Lunch'),
              Tab(text: 'Snacks'),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: TabBarView(
                children: [
                  MealGrid(meals: categorizedMealss["Breakfast"]!),
                  MealGrid(meals: categorizedMealss["Brunch"]!),
                  MealGrid(meals: categorizedMealss["Lunch"]!),
                  MealGrid(meals: categorizedMealss["Snacks"]!),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0, right: 16.0),
              child: Align(
                alignment: Alignment.bottomRight,
                child: SizedBox(
                  width: 100, // Small width for the button
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ChataiWithfood(), // Replace with your page
                          )); // Replace with your chat page route
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFc4ff00), // Button color
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(8), // Rounded corners
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.chat_bubble, size: 16, color: Colors.black),
                        SizedBox(width: 4),
                        Text(
                          'FoodGPT',
                          style: TextStyle(color: Colors.black, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MealGrid extends StatelessWidget {
  final List<MealDetails> meals;

  const MealGrid({super.key, required this.meals});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          childAspectRatio: 3 / 4,
        ),
        itemCount: meals.length,
        itemBuilder: (context, index) {
          final meal = meals[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MealDetailsPage(
                    imagePath: meal.imagePath,
                    title: meal.title,
                    time: meal.time,
                    calories: meal.calories,
                    description: meal.description,
                    ingredients: meal.ingredients,
                    instructions: meal.instructions,
                  ),
                ),
              );
            },
            child: MealTip(
              imagePath: meal.imagePath,
              title: meal.title,
              time: meal.time,
              calories: meal.calories,
            ),
          );
        },
      ),
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
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.favorite_border, color: Colors.white),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                borderRadius:
                    const BorderRadius.vertical(bottom: Radius.circular(16.0)),
                color: Colors.black.withOpacity(0.6),
              ),
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4.0),
                  Row(
                    children: [
                      const Icon(Icons.timer, color: Colors.white, size: 16.0),
                      const SizedBox(width: 4.0),
                      Text(time, style: const TextStyle(color: Colors.white)),
                      const SizedBox(width: 16.0),
                      const Icon(Icons.local_fire_department,
                          color: Colors.white, size: 16.0),
                      const SizedBox(width: 4.0),
                      Text(calories,
                          style: const TextStyle(color: Colors.white)),
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

// Placeholder MealDetailsPage
class MealDetailsPage extends StatelessWidget {
  final String imagePath;
  final String title;
  final String time;
  final String calories;
  final String description;
  final String ingredients;
  final String instructions;

  const MealDetailsPage({
    super.key,
    required this.imagePath,
    required this.title,
    required this.time,
    required this.calories,
    required this.description,
    required this.ingredients,
    required this.instructions,
  });

  @override
  Widget build(BuildContext context) {
    // Split the instructions into lines by breaking at each newline character
    //List<String> instructionLines = instructions.split('\n');
    return Scaffold(
      backgroundColor: const Color(0xFF1a1a1e), // Dark background
      appBar: AppBar(
        backgroundColor: const Color(0xFF1a1a1e),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              color: Color(0xFFd5ff5f)), //  back arrow
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 250,
              ),
            ),
            const SizedBox(height: 16),
            // Details Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Basic Info
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.timer, color: Colors.grey, size: 20),
                      const SizedBox(width: 4),
                      Text(time, style: const TextStyle(color: Colors.grey)),
                      const SizedBox(width: 16),
                      const Icon(Icons.local_fire_department,
                          color: Colors.grey, size: 20),
                      const SizedBox(width: 4),
                      Text(calories,
                          style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Description with rounded box
                  const Text(
                    "About",
                    style: TextStyle(
                      color: Color(0xFFd5ff5f), // Highlighted section title
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 59, 58, 58),
                      borderRadius: BorderRadius.circular(35.0),
                    ),
                    child: Text(
                      description,
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Ingredients with rounded box
                  const Text(
                    "Ingredients",
                    style: TextStyle(
                      color: Color(0xFFd5ff5f),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 59, 58, 58),
                      borderRadius: BorderRadius.circular(35.0),
                    ),
                    child: Text(
                      ingredients,
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Instructions with rounded box
                  const Text(
                    "Instructions",
                    style: TextStyle(
                      color: Color(0xFFd5ff5f),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 59, 58, 58),
                      borderRadius: BorderRadius.circular(35.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...instructions.split('\n').map(
                              (instruction) => Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Text(
                                  instruction,
                                  style: const TextStyle(
                                      color: Colors.white70, fontSize: 16),
                                ),
                              ),
                            ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // CTA (Call-To-Action) Button
            Center(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFD700), // Gold button
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () {
                  final mealProvider =
                      Provider.of<MealProvider>(context, listen: false);
                  mealProvider.addMeal(
                    Meal(
                      imagePath: imagePath,
                      title: title,
                      category:
                          "", // You can update this dynamically based on the page or meal category
                      calories: calories,
                      time: time,
                    ),
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('$title added to your meals!')),
                  );
                },
                icon: const Icon(Icons.star, color: Colors.black),
                label: const Text(
                  "Add To Meals",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
