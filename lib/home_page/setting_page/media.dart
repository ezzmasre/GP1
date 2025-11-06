import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class FitnessMediaPage extends StatelessWidget {
  // YouTube video links and IDs
  final List<String> workoutVideos = [
    '9o0UPuDBM8M', // First video ID
    'CP9n_Hm4FCE', // Second video ID
    'XJYNSuRyjIs', // New video 1 from the link
    'BjxoME-MT1s', // New video 2 from the link
  ];

  final List<Map<String, String>> articles = [
    {
      'title': 'Nutrition Tips for a Healthier Lifestyle',
      'description':
          'Discover essential nutrition tips to maintain a balanced diet and promote overall health.'
    },
    {
      'title': '10 Effective Home Workouts',
      'description':
          'Explore a variety of effective workouts you can do at home without any equipment.'
    },
    {
      'title': 'The Importance of Hydration',
      'description':
          'Learn why staying hydrated is crucial for your fitness journey and overall well-being.'
    },
    {
      'title': 'Stretching Exercises for Flexibility',
      'description':
          'Improve your flexibility and reduce injury risk with these essential stretching exercises.'
    },
    {
      'title': 'Mindfulness in Fitness',
      'description':
          'Understand how mindfulness can enhance your workout experience and boost mental health.'
    },
    {
      'title': 'Understanding Macronutrients',
      'description':
          'Get to know the role of proteins, fats, and carbohydrates in your diet and how to balance them.'
    },
  ];


  //const FitnessMediaPage({super.key});

   //FitnessMediaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              color: Color.fromARGB(255, 255, 255, 255)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Fitness Hub',
          style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
        ),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0), // Your custom color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Section for workout videos
            const Text(
              'Workout Videos',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xffD5FF5F)),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 200, // Adjust height as needed
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: workoutVideos.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: GestureDetector(
                      onTap: () {
                        // Navigate to the video player page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                VideoPlayerPage(videoId: workoutVideos[index]),
                          ),
                        );
                      },
                      child: Container(
                        width: 150,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                              'https://img.youtube.com/vi/${workoutVideos[index]}/0.jpg', // Get thumbnail image
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // Section for articles
            const Text(
              'Fitness Articles',
              style: TextStyle(
                  color: Color(0xffD5FF5F),
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(), // Prevent scrolling
              itemCount: articles.length,
              itemBuilder: (context, index) {
                return Card(
                  color: const Color(0xff2E2E35),
                  child: ListTile(
                    title: Text(
                      articles[index]['title']!,
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(articles[index]['description']!,
                        style: const TextStyle(color: Colors.white)),
                    onTap: () {
                      // Handle article tap (navigate to article detail page)
                      // You can create a detailed article page here
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 20),

            // Motivational Quotes Section (Optional)
            const Text(
              'Motivational Quotes',
              style: TextStyle(
                  color: Color(0xffD5FF5F),
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                '"The only bad workout is the one that didn\'t happen."',
                style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Video Player Page
class VideoPlayerPage extends StatelessWidget {
  final String videoId;

  const VideoPlayerPage({super.key, required this.videoId});

  @override
  Widget build(BuildContext context) {
    final YoutubePlayerController controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xffD5FF5F)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Video Player',
          style: TextStyle(color: Color(0xffD5FF5F)),
        ),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      ),
      body: Column(
        children: [
          YoutubePlayer(
            controller: controller,
            showVideoProgressIndicator: true,
            progressIndicatorColor: Colors.amber,
          ),
          const SizedBox(height: 20),
          // You can add more content below the player if needed
        ],
      ),
    );
  }
}
