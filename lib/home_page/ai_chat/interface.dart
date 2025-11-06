import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:wibsite/home_page/account_page/displayuservedios.dart';
import 'package:wibsite/home_page/account_page/user_vedios.dart';
import 'package:wibsite/sign_inmoblie/auth.dart';

class ChatBotPage extends StatefulWidget {
  const ChatBotPage({super.key});

  @override
  _ChatBotPageState createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
    final Authservce auth = Authservce();
    String currentUserEmail="";
  List<String> dis = [];
  List<String> dis_withnumber = [];
  int count = 1;
  String resposefromai = "";
  List<Map<String, String>> chestVideos = [];
  List<Map<String, String>> shoulderVideos = [];
  List<Map<String, String>> handsVideos = [];
  List<Map<String, String>> backVideos = [];
  List<Map<String, String>> legsVideos = [];
  List<Map<String, String>> trysibs = [];
List<Map<String, String>> stritching = [];
 bool flagai=true;

  @override
  void initState() {

    super.initState();
    searchById("chest.email", 'chest');
    searchById("shoulder.email", 'shoulder');
    searchById("bicebs.email", 'hands');
    searchById("back.email", 'back');
    searchById("legs.email", 'legs');
    searchById("trysibs .email", 'trysibs');
    searchById("Trainng.gmail", 'Trainng');
     currentUserEmail = auth.getcurrentuser()!.email!;
    

    messages.add({
      'sender': 'bot',
      'text': 'Hello! My name is WorkoutGPT, and I am here to help you with your Workouts. Do you want a full plan workout or just a specific one?'
    });
  }
   Future<void> addVideoToUserList(String userId, String videoId ,String selectedDay) async {
   print('the user ${userId}');
  final url = Uri.parse('https://fitnes-bakeend.onrender.com/pro/$userId/add-video');
  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'videoId': videoId, 'day': selectedDay}),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('Video added successfully for day $selectedDay: ${data['selectedDay']}');
    } else {
      print('Failed to add video: ${response.body}');
    }
  } catch (e) {
    print('Error: $e');
  }
}

  void searchById(String id, String category) async {
    final url = Uri.parse('https://fitnes-bakeend.onrender.com/pro/$id');

    try {
      final response = await http.get(url);
      List<Map<String, String>> videoList = [];
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        int flag = 0;
        if (data['fitnes'] != null && data['fitnes'] is List) {
          setState(() {
            for (var video in data['fitnes']) {
              if (video.length >= 3) {
                if (flag < 1) {
                  dis_withnumber.add('$count-${video[2]}');
                  count++;
                  flag++;
                }
                dis.add(video[2]);
                videoList.add({
                  'id': video[0],
                  'title': video[1],
                  'description': video[2],
                });
              }
            }
           
            if (category == 'chest') {
              chestVideos = videoList;
            } else if (category == 'shoulder') {
              shoulderVideos = videoList;
            } else if (category == 'hands') {
              handsVideos = videoList;
            } else if (category == 'back') {
              backVideos = videoList;
            } else if (category == 'legs') {
              legsVideos = videoList;
            } else if (category == 'trysibs') {
              trysibs = videoList;
            }
            else if(category == 'Trainng'){
              stritching=videoList;

            }
          });
        } else {
          print('Invalid fitness data!');
        }
      } else {
        print('Product not found!');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Map<String, String>> messages = [];

 Future<void> sendMessage(String userMessage) async {
  setState(() {
    messages.add({
      'sender': 'user',
      'text': userMessage,
    });
  });

  _scrollToBottom();
    if (messages.length == 2) {
    // If it's the second message (after the bot's initial greeting)
   if(userMessage.contains("no")){
    print("iam here");
   flagai=false;
   setState(() {
      messages.add({
        'sender': 'bot',
        'text': 'Ask me any thing in your mind',
      });
    });
   }
   else{
    setState(() {
      messages.add({
        'sender': 'bot',
        'text': 'Do you have any illness or health condition?',
      });
    });
   }
    return; // Exit early as we're not yet querying the API.
  }
   // Scroll to the bottom after user sends a message.
if(flagai){
 

 if (messages.length == 4) {
      // If already asked about illness, proceed with asking about fitness goals.
      if(userMessage.toLowerCase().contains('no') || userMessage.toLowerCase().contains('just')|| userMessage.toLowerCase().contains('one') ){
        setState(() {
        messages.add({
          'sender': 'bot',
          'text': 'Thats very good . \nWhat is your occupation? This will help me recommend suitable exercises for your needs.',
        });
      });

      }else {
      setState(() {
        messages.add({
          'sender': 'bot',
          'text': 'Opps i hope to u be safe. \nWhat is your occupation? This will help me recommend suitable exercises for your needs.',
        });
      });}
      return; // Exit early as we're not yet querying the API.
    }




  if (messages.length == 6) {
    // Ask about fitness goals after getting the user's occupation
    String occupation = userMessage; // Assuming the user's last message was their occupation
    setState(() {
      messages.add({
        'sender': 'bot',
        'text': 'Wow nice job I’ve prepared a special exercise plan just for you. Please choose one of the following options: Weight Gain, Weight Loss, Weight Maintenance, or Special exercise. The first button is tailored especially for you, but feel free to explore the other options or make changes as needed!',
      });
    });
    return;
  }

  if (messages.length == 8) {
    print(userMessage);
    // Handle the user's fitness goal selection
    String selectedGoal = '';
    if (userMessage.toLowerCase().contains('weight gain')) {
      selectedGoal = 'Weight Gain';
    } else if (userMessage.toLowerCase().contains('weight loss')) {
      selectedGoal = 'Weight Loss';
    } else if (userMessage.toLowerCase().contains('weight maintenance')) {
      selectedGoal = 'Weight Maintenance';
    } else if (userMessage.contains('Special')) {
      print("ezzz");
      selectedGoal ='Special exercise';
    }
print(selectedGoal);
    if (selectedGoal.isNotEmpty) {
      setState(() {
        messages.add({
          'sender': 'bot',
          'text': 'You have selected: $selectedGoal. Here are some recommendations:',
        });
      });

      // Send the selected goal to the backend API
   
      
        
        setState(() {
          messages.add({
            'sender': 'bot',
            'text': 'I have created a personalized plan for you from Saturday to Friday. You can review the details by clicking the button below. If you have any questions, need an explanation, or want to discuss anything further, feel free to ask me. Im here to help', // Display the bot's response
          });
        });
      
    } else {
      setState(() {
        messages.add({
          'sender': 'bot',
          'text': 'Sorry, I didn\'t understand your choice. Please try again.',
        });
      });
    }
    return;
  }
}
 

  // Handle other messages (e.g., illness or general chat)
  final url = Uri.parse('https://fitnes-bakeend.onrender.com/chat');

  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'prompt': ' $userMessage. '}),
  );

  if (response.statusCode == 200) {
    final responseData = jsonDecode(response.body);
    setState(() {
      messages.add({
        'sender': 'bot',
        'text': responseData['text'],
      });
    });
  } else {
    setState(() {
      messages.add({
        'sender': 'bot',
        'text': 'Sorry, something went wrong. Please try again later.',
      });
    });
  }
  _scrollToBottom(); // Scroll to the bottom after bot sends a response.
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
          'Workout-GPT',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.black,
              child:ListView.builder(
  controller: _scrollController,
  itemCount: messages.length + (messages.length == 7 ? 1 : 0) + (messages.length == 10 ? 1 : 0), // Add 1 for the buttons
  reverse: false,
  itemBuilder: (context, index) {
    // Display buttons under the bot's message when messages.length == 7
    if (messages.length == 7 && index == messages.length) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Wrap(
          spacing: 10, // Horizontal space between buttons
          runSpacing: 10, // Vertical space between button lines
          children: [
            specialexercise('Special exercise'),
            weghtgain('Weight Gain'),
            WeightLoss('Weight Loss'),
            WeightMaintenance('Weight Maintenance'),
          ],
        ),
      );
    }

    // Display the "Finish" button when messages.length == 10
    if (messages.length == 10 && index == messages.length) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DisplayUserVideos()),
                  );
            // Handle the "Finish" button action
             // Example: Navigate back to the previous screen
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green, // Button color
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: const Text(
            'Vedio List',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ),
      );
    }

    // Display chat messages
    final message = messages[index];
    final isUser = message['sender'] == 'user';
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 5,
          horizontal: 10,
        ),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isUser ? Colors.blue : Colors.grey[800],
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: isUser ? const Radius.circular(16) : Radius.zero,
            bottomRight: isUser ? Radius.zero : const Radius.circular(16),
          ),
        ),
        child: Text(
          message['text'] ?? '',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 15,
          ),
        ),
      ),
    );
  },
)
            ),
          ),
          // Input field and send button
          Container(
            color: Colors.black,
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
                      hintStyle: const TextStyle(color: Colors.grey),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 15,
                      ),
                      filled: true,
                      fillColor: Colors.grey[900],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear, color: Colors.white),
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
                      color: Colors.blue,
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
    );
  }

  // Helper method to build a button
  Widget specialexercise(String text) {
    return ElevatedButton(
      onPressed: () {
        sendMessage(text); // Send the button text as a message
        String day="Saturday";
        String id = chestVideos[1]['id']!;
       addVideoToUserList(currentUserEmail,id,day);
          day="Sunday";
         id = backVideos[1]['id']!;
       addVideoToUserList(currentUserEmail,id,day);
           day="Monday";
         id = shoulderVideos[1]['id']!;
       addVideoToUserList(currentUserEmail,id,day);
           day="Tuesday";
         id = legsVideos[1]['id']!;
       addVideoToUserList(currentUserEmail,id,day);
           day="Wednesday";
         id = trysibs[1]['id']!;
       addVideoToUserList(currentUserEmail,id,day);
           day="Thursday";
         id = handsVideos[1]['id']!;
       addVideoToUserList(currentUserEmail,id,day);
           day="Friday";
         id = stritching[1]['id']!;
       addVideoToUserList(currentUserEmail,id,day);
       
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue, // Button color
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
      ),
    );
  }
   Widget WeightLoss(String text) {
    return ElevatedButton(
      onPressed: () {
        sendMessage(text);
        String day="Saturday";
        String id = chestVideos[2]['id']!;
       addVideoToUserList(currentUserEmail,id,day);
          day="Sunday";
         id = shoulderVideos[2]['id']!;
       addVideoToUserList(currentUserEmail,id,day);
           day="Monday";
         id = stritching[3]['id']!;
       addVideoToUserList(currentUserEmail,id,day);
           day="Tuesday";
         id = legsVideos[1]['id']!;
       addVideoToUserList(currentUserEmail,id,day);
           day="Wednesday";
         id = trysibs[1]['id']!;
       addVideoToUserList(currentUserEmail,id,day);
       id = legsVideos[3]['id']!;
       addVideoToUserList(currentUserEmail,id,day);
           day="Thursday";
         id = handsVideos[1]['id']!;
       addVideoToUserList(currentUserEmail,id,day);
           day="Friday";
         id = stritching[4]['id']!;
       addVideoToUserList(currentUserEmail,id,day);
        
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue, // Button color
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
      ),
    );
  } Widget WeightMaintenance(String text) {
    return ElevatedButton(
      onPressed: () {
        sendMessage(text);
          String day="Saturday";
        String id = chestVideos[3]['id']!;
       addVideoToUserList(currentUserEmail,id,day);
          day="Sunday";
         id = shoulderVideos[1]['id']!;
       addVideoToUserList(currentUserEmail,id,day);
           day="Monday";
         id = backVideos[1]['id']!;
       addVideoToUserList(currentUserEmail,id,day);
           day="Tuesday";
         id = legsVideos[2]['id']!;
       addVideoToUserList(currentUserEmail,id,day);
           day="Wednesday";
         id = trysibs[2]['id']!;
       addVideoToUserList(currentUserEmail,id,day);
      
           day="Thursday";
         id = handsVideos[2]['id']!;
       addVideoToUserList(currentUserEmail,id,day);
           day="Friday";
         id = stritching[4]['id']!;
       addVideoToUserList(currentUserEmail,id,day); // Send the button text as a message
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue, // Button color
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
      ),
    );
  }
  Widget weghtgain(String text) {
    return ElevatedButton(
      onPressed: () {
        sendMessage(text);
            String day="Saturday";
        String id = chestVideos[3]['id']!;
       addVideoToUserList(currentUserEmail,id,day);
       id = trysibs[2]['id']!;
       addVideoToUserList(currentUserEmail,id,day);
          day="Sunday";
         id = shoulderVideos[1]['id']!;
       addVideoToUserList(currentUserEmail,id,day);
           day="Monday";
         id = backVideos[1]['id']!;
       addVideoToUserList(currentUserEmail,id,day);
       id = handsVideos[3]['id']!;
       addVideoToUserList(currentUserEmail,id,day);
           day="Tuesday";
         id = legsVideos[1]['id']!;
       addVideoToUserList(currentUserEmail,id,day);
           day="Wednesday";
         id = trysibs[1]['id']!;
       addVideoToUserList(currentUserEmail,id,day);
          id = shoulderVideos[3]['id']!;
      addVideoToUserList(currentUserEmail,id,day);
           day="Thursday";
         id = handsVideos[2]['id']!;
       addVideoToUserList(currentUserEmail,id,day);
           day="Friday";
         id = stritching[4]['id']!;
       addVideoToUserList(currentUserEmail,id,day); // Send the button text as a message
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue, // Button color
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
      ),
    );
  }
}