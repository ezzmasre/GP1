import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wibsite/saving_data/save_data.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class FitnessTab extends StatefulWidget {
  const FitnessTab({super.key});

  @override
  _FitnessTabState createState() => _FitnessTabState();
}

class _FitnessTabState extends State<FitnessTab> {
  List<Map<String, String>> chestVideos = [];
  String? selectedDay = "Monday"; // Default value for the dropdown
  String? savedString = "-";
  Map<String, dynamic> jsonData = {};

  final List<String> days = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday"
  ];

  @override
  void initState() {
    super.initState();
    searchById("fitins.gmail", 'fitins');
    
    loadString();
    print("Saved string: $savedString");
    searchById("$savedString", 'videos');
  }

  Future<void> loadString() async {
    String? data = await getString();
    // Simulate loading a string from shared preferences
    setState(() {
      savedString = data; // Replace with actual loading logic
    });
  }

Future<void> addVideoToUserList(String userId, String videoId) async {
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
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['fitnes'] != null && data['fitnes'] is List) {
          setState(() {
            chestVideos = data['fitnes']
                .map<Map<String, String>>((video) => {
                      'id': video[0]?.toString() ?? '',
                      'title': video[1]?.toString() ?? '',
                      'description': video[2]?.toString() ?? '',
                    })
                .toList();
          });
        }
      } else {
        print('Product not found!');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

 Widget buildDropdownSection() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
      const Text(
        "Choose Day:",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      DropdownButton<String>(
        value: selectedDay,
        icon: const Icon(Icons.arrow_downward, color: Colors.white),
        dropdownColor: Colors.black,
        underline: Container(height: 2, color: Colors.white),
        onChanged: (String? newValue) {
          setState(() {
            selectedDay = newValue!;
            print('Selected Day: $selectedDay');
          });
        },
        items: days.map<DropdownMenuItem<String>>((String day) {
          return DropdownMenuItem<String>(
            value: day,
            child: Text(
              day,
              style: const TextStyle(color: Colors.white),
            ),
          );
        }).toList(),
      ),
    ],
  );
}


  Widget buildVideoGrid(List<Map<String, String>> videos) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.7,
      ),
      itemCount: videos.length,
      itemBuilder: (context, index) {
        final video = videos[index];

        return Card(
          color: Colors.black,
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VideoPlayerPage(
                        videoId: video['id']!,
                        description: video['description']!,
                        title: video['title']!,
                      ),
                    ),
                  );
                },
                child: Column(
                  children: [
                    YoutubePlayer(
                      controller: YoutubePlayerController(
                        initialVideoId: video['id']!,
                        flags: const YoutubePlayerFlags(
                          autoPlay: false,
                          mute: false,
                        ),
                      ),
                      showVideoProgressIndicator: true,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            video['title']!,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffD5FF5F),
                ),
                onPressed: () async {
                  if (savedString != null && video['id'] != null) {
                    await addVideoToUserList(savedString!, video['id']!);
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Success"),
                          content: const Text("You added the item to your list."),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text("OK"),
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    print("User ID or Video ID is missing");
                  }
                },
                child: const Text(
                  'Add to My List',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 5, 6, 12),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              buildDropdownSection(),
              const SizedBox(height: 16),
              buildVideoGrid(chestVideos),
            ],
          ),
        ),
      ),
    );
  }
}

class VideoPlayerPage extends StatelessWidget {
  final String videoId;
  final String description;
  final String title;

  const VideoPlayerPage({
    super.key,
    required this.videoId,
    required this.description,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text("Video Player for $videoId"),
      ),
    );
  }
}
