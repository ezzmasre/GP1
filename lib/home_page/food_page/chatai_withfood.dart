import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ChataiWithfood extends StatefulWidget {
  const ChataiWithfood({super.key});

  @override
  _ChataiWithfood createState() => _ChataiWithfood();
}

class _ChataiWithfood extends State<ChataiWithfood> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Map<String, String>> messages = [];
  int currentStep = 0; // Tracks the current question
  String selectedCategory = "";
  String caloriesPreference = "";
  String userIngredients = "";
  String weightGoal = ""; // Define the weightGoal variable
  double? userWeight; // Define the userWeight variable
  int minCalories = 0; // Define the minCalories variable
  int maxCalories = 0; // Define the maxCalories variable

  @override
  void initState() {
    super.initState();

    // Initial welcome message
    messages.add({
      'sender': 'bot',
      'text':
          'Hello! My name is FoodGPT, and I am here to help you with your meals. What can I assist you with today?',
    });

    _askNextQuestion();
  }

  final List<Map<String, String>> bulkMealPlan = [
    {
      'title': 'Breakfast: Protein Pancakes',
      'calories': '500',
      'description': 'Fluffy pancakes packed with protein.',
      'ingredients': 'Oats, Eggs, Protein Powder, Banana',
      'instructions': '1. Blend ingredients. 2. Cook on a skillet.'
    },
    {
      'title': 'Brunch: Peanut Butter Banana Smoothie',
      'calories': '600',
      'description': 'A calorie-dense smoothie for energy.',
      'ingredients': 'Banana, Peanut Butter, Oats, Milk',
      'instructions': '1. Blend all ingredients until smooth.'
    },
    {
      'title': 'Lunch: Chicken and Rice',
      'calories': '700',
      'description': 'A classic meal for muscle gain.',
      'ingredients': 'Chicken Breast, Brown Rice, Broccoli',
      'instructions': '1. Cook chicken and rice. 2. Serve with broccoli.'
    },
    {
      'title': 'Snack: Trail Mix',
      'calories': '300',
      'description': 'A mix of nuts and dried fruits.',
      'ingredients': 'Almonds, Walnuts, Dried Cranberries',
      'instructions': '1. Mix all ingredients together.'
    },
    {
      'title': 'Dinner: Beef Stir-Fry',
      'calories': '800',
      'description': 'A hearty stir-fry with vegetables.',
      'ingredients': 'Beef, Bell Peppers, Soy Sauce, Rice',
      'instructions': '1. Stir-fry beef and veggies. 2. Serve with rice.'
    },
  ];

  final List<Map<String, String>> cutMealPlan = [
    {
      'title': 'Breakfast: Scrambled Eggs with Spinach',
      'calories': '250',
      'description': 'A low-calorie breakfast rich in protein.',
      'ingredients': 'Eggs, Spinach, Olive Oil',
      'instructions': '1. Scramble eggs with spinach in olive oil.'
    },
    {
      'title': 'Brunch: Greek Yogurt with Berries',
      'calories': '200',
      'description': 'A refreshing and low-calorie snack.',
      'ingredients': 'Greek Yogurt, Mixed Berries',
      'instructions': '1. Mix yogurt with berries.'
    },
    {
      'title': 'Lunch: Grilled Chicken Salad',
      'calories': '300',
      'description': 'A light salad with lean protein.',
      'ingredients': 'Grilled Chicken, Lettuce, Tomato, Cucumber',
      'instructions': '1. Grill chicken and toss with salad ingredients.'
    },
    {
      'title': 'Snack: Celery with Hummus',
      'calories': '100',
      'description': 'A crunchy snack with healthy fats.',
      'ingredients': 'Celery, Hummus',
      'instructions': '1. Dip celery sticks in hummus.'
    },
    {
      'title': 'Dinner: Baked Salmon with Asparagus',
      'calories': '400',
      'description': 'A nutritious dinner rich in omega-3s.',
      'ingredients': 'Salmon, Asparagus, Lemon',
      'instructions': '1. Bake salmon and asparagus with lemon.'
    },
  ];

  Future<void> sendMessage(String userMessage) async {
    setState(() {
      messages.add({'sender': 'user', 'text': userMessage});
    });

    _scrollToBottom();

    switch (currentStep) {
      case 0:
        if (userMessage.toLowerCase().contains('hello') ||
            userMessage.toLowerCase().contains('hi') ||
            userMessage.toLowerCase().contains('hey') ||
            userMessage.toLowerCase().contains('how are you')) {
          messages.add({
            'sender': 'bot',
            'text': 'Great to hear from you! how can I help you today?',
          });
          currentStep++;
        }
        break;

      case 1:
        if (userMessage.toLowerCase().contains('meal') ||
            userMessage.toLowerCase().contains('food') ||
            userMessage.toLowerCase().contains('eat')) {
          messages.add({
            'sender': 'bot',
            'text': 'okay okay! but i need to know wether you want to gain or lose weight?',
          });
          currentStep++;
        }
        break;

      case 2:
        if (userMessage.toLowerCase().contains('gain')) {
          messages.add({
            'sender': 'bot',
            'text': 'Got it! but before i need to know your weight in kg?'
          });
          currentStep++;
          weightGoal = 'bulk'; // Set the goal for later use
        } else if (userMessage.toLowerCase().contains('lose')) {
          messages.add({
            'sender': 'bot',
            'text': 'Understood! but before i need to know your weight in kg?'
          });
          currentStep++;
          weightGoal = 'cut'; // Set the goal for later use
        }
        break;

      case 3:
        // Store the user's weight
        userWeight = double.tryParse(userMessage);
        if (userWeight != null) {
          // Calculate calorie range based on weight
          if (weightGoal == 'bulk') {
            minCalories = ((userWeight ?? 0) * 30).toInt();
            maxCalories = minCalories + 500;
            messages.add({
              'sender': 'bot',
              'text':
                  'Your calorie range for bulking is $minCalories - $maxCalories. Do you want a full meal plan for the day or just a specific meal like breakfast?'
            });
          } else if (weightGoal == 'cut') {
            minCalories = ((userWeight ?? 0) * 30).toInt();
            maxCalories =
                minCalories; // For cutting, we use the calculated value directly
            messages.add({
              'sender': 'bot',
              'text':
                  'Your calorie range for cutting is $minCalories. Do you want a full meal plan for the day or just a specific meal like breakfast?'
            });
          }
          currentStep++;
        } else {
          messages.add(
              {'sender': 'bot', 'text': 'Please enter a valid weight in kg.'});
        }
        break;

      case 4:
        if (userMessage.toLowerCase().contains('full meal plan') ||
            userMessage.toLowerCase().contains('full plan') ||
            userMessage.toLowerCase().contains('full')) {
          messages.add({
            'sender': 'bot',
            'text':
                'Great! I will provide you with meals that fit your calorie range.'
          });
          // Call a method to fetch meal recommendations for the full plan
          await _fetchFullMealPlan();
        } else if (userMessage.toLowerCase().contains('specific meal') ||
            userMessage.toLowerCase().contains('specific') ||
            userMessage.toLowerCase().contains('breakfast') ||
            userMessage.toLowerCase().contains('lunch') ||
            userMessage.toLowerCase().contains('dinner') ||
            userMessage.toLowerCase().contains('snack')) {
          messages.add({
            'sender': 'bot',
            'text': 'What ingredients do you have in your kitchen?'
          });
          currentStep++;
        }
        break;

      case 5:
        userIngredients = userMessage;

        // Show a waiting message
        setState(() {
          messages.add({
            'sender': 'bot',
            'text':
                'Got it! Let me find a meal based on your ingredients. Please wait a moment...'
          });
        });

        _scrollToBottom();

        // Fetch meal recommendations based on ingredients
        await Future.delayed(const Duration(seconds: 2));
        await _fetchMealRecommendations();
        currentStep++;
        break;

      default:
        messages.add({
          'sender': 'bot',
          'text': 'Let me know if you need more recommendations!'
        });
    }

    _scrollToBottom();
  }

  Future<void> _fetchFullMealPlan() async {
    // Simulate a delay for fetching data
    await Future.delayed(const Duration(seconds: 1));

    List<Map<String, String>> selectedMealPlan;

    // Select meal plan based on user goal
    if (weightGoal == 'bulk') {
      selectedMealPlan = bulkMealPlan;
      messages
          .add({'sender': 'bot', 'text': 'Here is your bulking meal plan:'});
    } else if (weightGoal == 'cut') {
      selectedMealPlan = cutMealPlan;
      messages
          .add({'sender': 'bot', 'text': 'Here is your cutting meal plan:'});
    } else {
      messages.add({
        'sender': 'bot',
        'text': 'I could not find a meal plan for that goal.'
      });
      return;
    }

    // Send each meal to the chat, filtering based on calorie range
    for (var meal in selectedMealPlan) {
      int mealCalories = int.parse(meal['calories']!);
      print('Checking meal: ${meal['title']} with calories: $mealCalories');

      if (weightGoal == 'bulk') {
        if (mealCalories >= minCalories && mealCalories <= maxCalories) {
          messages.add({
            'sender': 'bot',
            'text': '${meal['title']}\n'
                'Calories: ${meal['calories']}\n'
                'Description: ${meal['description']}\n'
                'Ingredients: ${meal['ingredients']}\n'
                'Instructions: ${meal['instructions']}'
          });
        }
      } else if (weightGoal == 'cut') {
        if (mealCalories <= minCalories) {
          messages.add({
            'sender': 'bot',
            'text': '${meal['title']}\n'
                'Calories: ${meal['calories']}\n'
                'Description: ${meal['description']}\n'
                'Ingredients: ${meal['ingredients']}\n'
                'Instructions: ${meal['instructions']}'
          });
        }
      }
    }
  }

  Future<void> _fetchMealRecommendations() async {
    final url = Uri.parse(
        'https://fitnes-bakeend.onrender.com/chat'); // Replace with your backend IP

    final requestPayload = {
      'prompt': '''
          Find a meal based on these preferences:
          Category: $selectedCategory,
          Calories: $caloriesPreference,
          Ingredients: $userIngredients.
          Provide the meal title, calories, description, ingredients, and instructions.
        '''
    };

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(requestPayload),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      setState(() {
        messages.add({'sender': 'bot', 'text': responseData['text']});
      });
    } else {
      setState(() {
        messages.add({
          'sender': 'bot',
          'text': 'Sorry, something went wrong. Please try again later.'
        });
      });
    }
  }

  void _askNextQuestion() {
    // if (currentStep == 0) {
    //   messages.add({
    //     'sender': 'bot',
    //     'text':
    //         'What meal would you like? Choose from breakfast, brunch, lunch, or snacks.',
    //   });
    // }
    _scrollToBottom();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'FoodGPT',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.red,
        elevation: 0,
      ),
      body: Container(
        color: Colors.grey[900],
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: messages.length,
                reverse: false,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  final isUser = message['sender'] == 'user';
                  return Align(
                    alignment:
                        isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 10,
                      ),
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: isUser
                            ? Colors.red.withOpacity(0.8)
                            : const Color.fromARGB(255, 0, 0, 0)
                                .withOpacity(0.8),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                          bottomLeft:
                              isUser ? Radius.circular(16) : Radius.zero,
                          bottomRight:
                              isUser ? Radius.zero : Radius.circular(16),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        message['text'] ?? '',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Type your message...',
                        hintStyle: const TextStyle(color: Colors.white54),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 15,
                        ),
                        filled: true,
                        fillColor: Colors.grey[800],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.clear, color: Colors.red),
                          onPressed: () => _controller.clear(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      if (_controller.text.trim().isNotEmpty) {
                        sendMessage(_controller.text.trim());
                        _controller.clear();
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
