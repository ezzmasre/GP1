import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:wibsite/providers/distance_provider.dart';

class DailyActivityPage extends StatelessWidget {
  const DailyActivityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Daily Activity',
            style: TextStyle(color: Colors.white)),
      ),
      body: Consumer<DistanceProvider>(
        builder: (context, distanceProvider, child) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                _buildActivitySection(
                  icon: FontAwesomeIcons.shoePrints,
                  iconColor: const Color(0xFFD5FF5F),
                  title: 'Steps & Distance',
                  currentValue: '${distanceProvider.steps}',
                  targetValue: '/ 10,000 steps',
                  progress: distanceProvider.steps / 10000,
                  progressColor: const Color(0xFFD5FF5F),
                  additionalInfo: '${distanceProvider.distance.toStringAsFixed(2)} km walked',
                ),
                const SizedBox(height: 30),
                _buildActivitySection(
                  icon: FontAwesomeIcons.fireFlameCurved,
                  iconColor: const Color(0xFFD50000),
                  title: 'Calories Burned',
                  currentValue: '${distanceProvider.calories}',
                  targetValue: '/ 600 Cal',
                  progress: distanceProvider.calories / 600,
                  progressColor: const Color(0xFFD50000),
                  additionalInfo: '${(distanceProvider.calories / 600 * 100).toStringAsFixed(0)}% of goal',
                ),
                const SizedBox(height: 30),
                _buildActivitySection(
                  icon: FontAwesomeIcons.glassWater,
                  iconColor: Colors.blue,
                  title: 'Water Intake',
                  currentValue: '${distanceProvider.water}',
                  targetValue: '/ 2.5 L',
                  progress: distanceProvider.water / 2.5,
                  progressColor: Colors.blue,
                  additionalInfo: '${(distanceProvider.water / 2.5 * 100).toStringAsFixed(0)}% hydrated',
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildActivitySection({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String currentValue,
    required String targetValue,
    required double progress,
    required Color progressColor,
    required String additionalInfo,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2D2D36),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 30),
              const SizedBox(width: 15),
              Text(title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 15),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[800],
            color: progressColor,
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: currentValue,
                      style: TextStyle(
                        color: progressColor,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: targetValue,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              Text(additionalInfo,
                  style: const TextStyle(color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }
}