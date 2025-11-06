import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wibsite/home_page/workout.dart/vidioplayer.dart';
import 'package:wibsite/sign_inmoblie/auth.dart';

class DisplayUserVideos extends StatefulWidget {
  const DisplayUserVideos({super.key});

  @override
  State<DisplayUserVideos> createState() => _DisplayUserVideosState();
}

class _DisplayUserVideosState extends State<DisplayUserVideos>
    with SingleTickerProviderStateMixin {
  final Authservce auth = Authservce();
  String? currentUserEmail;
  Map<String, List<String>> videosByDay = {};
  late AnimationController _animationController;
  late Animation<Color?> _gradientAnimation;

  @override
  void initState() {
    super.initState();
    currentUserEmail = auth.getcurrentuser()?.email;
    if (currentUserEmail != null) {
      fetchUserVideos(currentUserEmail!);
    }

    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    // Gradient animation
    _gradientAnimation = ColorTween(
      begin: Colors.black,
      end: Color(0xffD5FF5F).withOpacity(0.2),
    ).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> fetchUserVideos(String email) async {
    final url = Uri.parse('https://fitnes-bakeend.onrender.com/pro/$email');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final Map<String, List<String>> parsedVideosByDay = {
          "Saturday": List<String>.from(data["Saturday"] ?? []),
          "Sunday": List<String>.from(data["Sunday"] ?? []),
          "Monday": List<String>.from(data["Monday"] ?? []),
          "Tuesday": List<String>.from(data["Tuesday"] ?? []),
          "Wednesday": List<String>.from(data["Wednesday"] ?? []),
          "Thursday": List<String>.from(data["Thursday"] ?? []),
          "Friday": List<String>.from(data["Friday"] ?? []),
        };

        setState(() {
          videosByDay = parsedVideosByDay;
        });
      } else {
        print('Failed to fetch data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  String getThumbnailUrl(String videoId) {
    return 'https://img.youtube.com/vi/$videoId/0.jpg';
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 7,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
          backgroundColor: Colors.black,
          flexibleSpace: AnimatedBuilder(
            animation: _gradientAnimation,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black, _gradientAnimation.value!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              );
            },
          ),
          title: const Text(
            "User Videos",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xffD5FF5F),
              fontFamily: 'Poppins', // Use a custom font
            ),
          ),
          centerTitle: true,
          bottom: TabBar(
            isScrollable: true,
            indicatorColor: Color(0xffD5FF5F),
            labelStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xffD5FF5F),
              fontFamily: 'Poppins', // Use a custom font
            ),
            unselectedLabelColor: Colors.white70,
            tabs: const [
              Tab(text: "Saturday"),
              Tab(text: "Sunday"),
              Tab(text: "Monday"),
              Tab(text: "Tuesday"),
              Tab(text: "Wednesday"),
              Tab(text: "Thursday"),
              Tab(text: "Friday"),
            ],
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black, Colors.black],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: TabBarView(
            children: [
              _buildDayContent("Saturday"),
              _buildDayContent("Sunday"),
              _buildDayContent("Monday"),
              _buildDayContent("Tuesday"),
              _buildDayContent("Wednesday"),
              _buildDayContent("Thursday"),
              _buildDayContent("Friday"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDayContent(String day) {
    final dayVideos = videosByDay[day] ?? [];

    return dayVideos.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.video_library,
                  size: 80,
                  color: Color(0xffD5FF5F),
                ),
                const SizedBox(height: 20),
                Text(
                  "No videos available for $day",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Color(0xffD5FF5F),
                    fontFamily: 'Poppins', // Use a custom font
                  ),
                ),
              ],
            ),
          )
        : ListView.builder(
            itemCount: dayVideos.length,
            itemBuilder: (context, index) {
              final videoId = dayVideos[index];
              final thumbnailUrl = getThumbnailUrl(videoId);
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: InkWell(
                  onTap: () {},
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        colors: [
                          Colors.grey[900]!,
                          Colors.grey[850]!,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xffD5FF5F).withOpacity(0.2),
                          blurRadius: 10,
                          spreadRadius: 2,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.network(
                              thumbnailUrl,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Text(
                              'Video ID: $videoId',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xffD5FF5F),
                                fontFamily: 'Poppins', // Use a custom font
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.play_circle_filled,
                              color: Color(0xffD5FF5F),
                              size: 30,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => VideoPlayerPage(
                                    videoId: videoId,
                                    title: 'Video ID: $videoId',
                                    description: 'No description available',
                                  ),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.delete_forever,
                              color: Colors.redAccent,
                              size: 30,
                            ),
                            onPressed: () => deleteVideo(day, index),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
  }

  void deleteVideo(String day, int index) async {
    final videoId = videosByDay[day]?[index];
    if (videoId == null) return;

    final url = Uri.parse(
        'https://fitnes-bakeend.onrender.com/pro/delete/$currentUserEmail/$videoId/$day');

    try {
      final response = await http.delete(url);
      if (response.statusCode == 200) {
        setState(() {
          videosByDay[day]?.removeAt(index);
        });
        print('Video deleted successfully from the database.');
      } else {
        print('Failed to delete video: ${response.statusCode}');
      }
    } catch (e) {
      print('Error while deleting video: $e');
    }
  }
}