import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class Headache extends StatefulWidget {
  const Headache({super.key});

  @override
  State<Headache> createState() => _ChestvideospageState();
}

class _ChestvideospageState extends State<Headache> {
  List<Map<String, String>> chestVideos = [];

  @override
  void initState() {
    super.initState();
    searchById("headache.email", 'chest');
  }

  void delethhtp(String id) async {
    final url = Uri.parse('https://fitnes-bakeend.onrender.com/delete-video/$id');

    try {
      final request = http.Request('DELETE', url)
        ..headers['Content-Type'] = 'application/json'
        ..body = json.encode({
          'productId': "6771894f2144276c57febda5",
        });

      final response = await http.Client().send(request);

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        print('Video deleted successfully: $responseBody');
      } else {
        print('Failed to delete video: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during HTTP delete: $e');
    }
  }

  void addvediotolist(String id, String title, String description) async {
    final url = Uri.parse(
        'https://fitnes-bakeend.onrender.com/update-fitnes/6771894f2144276c57febda5');

    final newItem = [id, title, description]; // Prepare the new item

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(newItem), // Send as JSON
      );

      if (response.statusCode == 200) {
        print('Video added successfully: ${response.body}');
      } else {
        print('Failed to add video: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during HTTP POST: $e');
    }
  }

  void callhttp(String id, String title, String description) async {
    final url = Uri.parse('https://fitnes-bakeend.onrender.com/update-video');

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'id':
              '6771894f2144276c57febda5', // Add 'id' (the MongoDB document ID)
          'videoId': id, // Add 'videoId' (the ID of the video)
          'newTitle': title, // Add 'newTitle' (the new title for the video)
          'newDescription':
              description, // Add 'newDescription' (the new description for the video)
        }),
      );

      if (response.statusCode == 200) {
        print('Video updated successfully: ${response.body}');
      } else {
        print('Failed to update video: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during HTTP PUT: $e');
    }
  }

  void searchById(String id, String category) async {
    final url = Uri.parse('https://fitnes-bakeend.onrender.com/pro/$id');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('API Response: $data'); // Debug log to check the data

        if (data['fitnes'] != null && data['fitnes'] is List) {
          setState(() {
            List<Map<String, String>> videoList = [];
            for (var video in data['fitnes']) {
              // Ensure data structure is correct (array with 3 elements)
              if (video.length == 3) {
                videoList.add({
                  'id': video[0].toString(),
                  'title': video[1].toString(),
                  'description': video[2].toString(),
                });
              }
            }

            if (category == 'chest') {
              chestVideos = videoList;
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

  void _editVideo(int index) {
    final titleController =
        TextEditingController(text: chestVideos[index]['title']);
    final descriptionController =
        TextEditingController(text: chestVideos[index]['description']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color(0xff3C3C3C), // Set dialog background color
          title: const Text(
            'Edit Video',
            style: TextStyle(color: Color(0xffD5FF5F)), // Set text color
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                style: TextStyle(color: Color(0xffD5FF5F)), // Set text color
                decoration: InputDecoration(
                  labelText: 'Title',
                  labelStyle: TextStyle(color: Color(0xffD5FF5F)), // Set label color
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffD5FF5F)), // Set border color
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: descriptionController,
                style: TextStyle(color: Color(0xffD5FF5F)), // Set text color
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Description',
                  labelStyle: TextStyle(color: Color(0xffD5FF5F)), // Set label color
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffD5FF5F)), // Set border color
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog.
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Color(0xffD5FF5F)), // Set text color
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  chestVideos[index]['title'] = titleController.text;
                  chestVideos[index]['description'] =
                      descriptionController.text;
                });
                callhttp(
                  chestVideos[index]['id']!,
                  titleController.text,
                  descriptionController.text,
                );
                Navigator.of(context).pop(); // Close the dialog.
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xffD5FF5F), // Set button color
              ),
              child: const Text(
                'Save',
                style: TextStyle(color: Colors.black), // Set text color
              ),
            ),
          ],
        );
      },
    );
  }

  void _showAddVideoDialog() {
    final idController = TextEditingController();
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color(0xff3C3C3C), // Set dialog background color
          title: const Text(
            'Add New Video',
            style: TextStyle(color: Color(0xffD5FF5F)), // Set text color
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: idController,
                style: TextStyle(color: Color(0xffD5FF5F)), // Set text color
                decoration: InputDecoration(
                  labelText: 'Video ID',
                  labelStyle: TextStyle(color: Color(0xffD5FF5F)), // Set label color
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffD5FF5F)), // Set border color
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: titleController,
                style: TextStyle(color: Color(0xffD5FF5F)), // Set text color
                decoration: InputDecoration(
                  labelText: 'Title',
                  labelStyle: TextStyle(color: Color(0xffD5FF5F)), // Set label color
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffD5FF5F)), // Set border color
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: descriptionController,
                style: TextStyle(color: Color(0xffD5FF5F)), // Set text color
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Description',
                  labelStyle: TextStyle(color: Color(0xffD5FF5F)), // Set label color
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffD5FF5F)), // Set border color
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog.
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Color(0xffD5FF5F)), // Set text color
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final id = idController.text.trim();
                final title = titleController.text.trim();
                final description = descriptionController.text.trim();

                if (id.isNotEmpty &&
                    title.isNotEmpty &&
                    description.isNotEmpty) {
                  // Call the HTTP function to add the video
                  addvediotolist(id, title, description);

                  // Add the video to the local list
                  setState(() {
                    chestVideos.add({
                      'id': id,
                      'title': title,
                      'description': description,
                    });
                  });
                }

                Navigator.of(context).pop(); // Close the dialog.
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xffD5FF5F), // Set button color
              ),
              child: const Text(
                'Add',
                style: TextStyle(color: Colors.black), // Set text color
              ),
            ),
          ],
        );
      },
    );
  }

  void _deleteVideo(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color(0xff3C3C3C), // Set dialog background color
          title: const Text(
            'Delete Video',
            style: TextStyle(color: Color(0xffD5FF5F)), // Set text color
          ),
          content: const Text(
            'Are you sure you want to delete this video?',
            style: TextStyle(color: Color(0xffD5FF5F)), // Set text color
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog.
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Color(0xffD5FF5F)), // Set text color
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final id = chestVideos[index]['id']; // Get video ID
                if (id != null) {
                  delethhtp(id); // Call the delete HTTP function
                }

                setState(() {
                  chestVideos.removeAt(index); // Remove video from the list
                });

                Navigator.of(context).pop(); // Close the dialog
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xffD5FF5F), // Set button color
              ),
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.black), // Set text color
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Set background color to black
      appBar: AppBar(
        title: const Text(
          'Headache Videos',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xffD5FF5F), // Set text color
          ),
        ),
        backgroundColor: Colors.black, // Set app bar background color
        elevation: 0,
        centerTitle: true,
      ),
      body: chestVideos.isEmpty
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xffD5FF5F), // Set progress indicator color
              ),
            )
          : SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ...chestVideos.asMap().entries.map((entry) {
                    final index = entry.key;
                    final video = entry.value;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Card(
                        elevation: 8,
                        color: Color(0xff3C3C3C), // Set card background color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                video['title']!,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xffD5FF5F), // Set text color
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                video['description']!,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xffD5FF5F), // Set text color
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () async {
                                      final videoUrl =
                                          'https://www.youtube.com/watch?v=${video['id']}';
                                      if (await canLaunch(videoUrl)) {
                                        await launch(videoUrl);
                                      } else {
                                        throw 'Could not launch $videoUrl';
                                      }
                                    },
                                    icon: const Icon(Icons.play_arrow,
                                        color: Colors.black), // Set icon color
                                    label: const Text(
                                      'Watch Now',
                                      style: TextStyle(
                                          color: Colors.black), // Set text color
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Color(0xffD5FF5F), // Set button color
                                      minimumSize: const Size(100, 40),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => _editVideo(index),
                                  icon: const Icon(Icons.edit,
                                      color: Color(0xffD5FF5F)), // Set icon color
                                ),
                                IconButton(
                                  onPressed: () => _deleteVideo(index),
                                  icon: const Icon(Icons.delete,
                                      color: Color(0xffD5FF5F)), // Set icon color
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton.icon(
                      onPressed: _showAddVideoDialog,
                      icon: const Icon(Icons.add, color: Colors.black), // Set icon color
                      label: const Text(
                        'Add New Video',
                        style: TextStyle(color: Colors.black), // Set text color
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xffD5FF5F), // Set button color
                        minimumSize: const Size(double.infinity, 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
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