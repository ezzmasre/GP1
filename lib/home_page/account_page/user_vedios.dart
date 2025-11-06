import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:wibsite/home_page/workout.dart/vidioplayer.dart';
import 'package:wibsite/sign_inmoblie/auth.dart';

class UserVedios extends StatefulWidget {
  const UserVedios({super.key});

  @override
  State<UserVedios> createState() => _UserVediosState();
}

class _UserVediosState extends State<UserVedios> {
  final Authservce auth = Authservce();
  String? currentUserEmail;
  List<String> userVideos = [];

  void searchById(String id) async {
    final url = Uri.parse('https://fitnes-bakeend.onrender.com/pro/$id');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['vedios'] != null && data['vedios'] is List) {
          setState(() {
            userVideos = List<String>.from(data['vedios']);
          });
        } else {
          print('No videos found for this user.');
        }
      } else {
        print('Failed to fetch data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void deleteVideo(int index) async {
    final videoId = userVideos[index];
    final userId = "$currentUserEmail"; // Replace with the actual user ID

    final url =
        Uri.parse('https://fitnes-bakeend.onrender.com/pro/delete/$userId/$videoId');

    try {
      print("$currentUserEmail");
      final response = await http.delete(url);
      if (response.statusCode == 200) {
        setState(() {
          userVideos.removeAt(index);
        });
        print('Video deleted successfully from the database.');
      } else {
        print('Failed to delete video: ${response.statusCode}');
      }
    } catch (e) {
      print('Error while deleting video: $e');
    }
  }

  String getThumbnailUrl(String videoId) {
    return 'https://img.youtube.com/vi/$videoId/0.jpg';
  }

  @override
  void initState() {
    super.initState();
    currentUserEmail = auth.getcurrentuser()!.email;
    searchById("$currentUserEmail");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Videos'),
        backgroundColor: Colors.teal.shade700, // Teal for a calm, modern look
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal.shade100, Colors.blue.shade200],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: userVideos.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: userVideos.length,
                itemBuilder: (context, index) {
                  final videoId = userVideos[index];
                  final thumbnailUrl = getThumbnailUrl(videoId);
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: InkWell(
                      onTap: () {},
                      child: Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        color: Colors.white,
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
                                    color: Colors.blueGrey.shade800,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.play_circle_filled,
                                  color: Colors.blueAccent,
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
                                onPressed: () => deleteVideo(index),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
