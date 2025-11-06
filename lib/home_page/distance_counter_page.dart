import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pedometer/pedometer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart'; // Add this import
import '../providers/distance_provider.dart';

class DistanceCounterPage extends StatefulWidget {
  const DistanceCounterPage({super.key});

  @override
  State<DistanceCounterPage> createState() => _DistanceCounterPageState();
}

class _DistanceCounterPageState extends State<DistanceCounterPage> {
  late Stream<StepCount> _stepCountStream;
  int _steps = 0;
  bool _isPaused = false;
  int _pausedSteps = 0;
  double _distance = 0; // in kilometers
  int _calories = 0;
  String _duration = '0h 0m';
  Timer? _timer;
  int _seconds = 0;
  double _distanceGoal = 5.00;
  bool _permissionGranted = false; // Track permission status
  int _initialSteps = 0; // Track initial step count

  Map<String, int> weeklySteps = {
    'Mon': 0,
    'Tue': 0,
    'Wed': 0,
    'Thu': 0,
    'Fri': 0,
    'Sat': 0,
    'Sun': 0,
  };

  @override
  void initState() {
    super.initState();
    clearSavedData(); // Reset saved data
    _checkAndRequestPermission(); // Check and request permission
    loadTodaySteps();
    loadWeeklySteps();
    loadGoal();
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // Clear saved data to reset values
  Future<void> clearSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('steps_${DateTime.now().toIso8601String().split('T')[0]}');
    await prefs.remove('weekly_steps');
    await prefs.remove('distance_goal');
    setState(() {
      _steps = 0;
      _distance = 0;
      _calories = 0;
      _duration = '0h 0m';
      _distanceGoal = 5.0;
    });
  }

  // Check and request ACTIVITY_RECOGNITION permission
  Future<void> _checkAndRequestPermission() async {
    final status = await Permission.activityRecognition.status;
    print("Permission status: $status");
    if (status.isGranted) {
      setState(() {
        _permissionGranted = true;
      });
      initPlatformState(); // Initialize pedometer if permission is granted
    } else {
      final result = await Permission.activityRecognition.request();
      if (result.isGranted) {
        setState(() {
          _permissionGranted = true;
        });
        initPlatformState(); // Initialize pedometer if permission is granted
      } else {
        setState(() {
          _permissionGranted = false;
        });
        // Show a message or handle permission denial
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Permission denied. Step counting will not work.'),
          ),
        );
      }
    }
  }

void initPlatformState() async {
  if (!_permissionGranted) {
    print("Permission not granted. Cannot initialize pedometer.");
    return;
  }
  try {
    print("Initializing pedometer...");
    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);
  } catch (e) {
    print("Error initializing pedometer: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Step counting is not supported on this device.'),
      ),
    );
  }
}

  Future<void> loadGoal() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _distanceGoal = prefs.getDouble('distance_goal') ?? 5.0;
    });
  }

  Future<void> saveGoal(double goal) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('distance_goal', goal);
  }

  void _showGoalEditDialog() {
    TextEditingController controller = TextEditingController(
      text: _distanceGoal.toString(),
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2d2d36),
        title: const Text('Set Distance Goal',
            style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            labelText: 'Goal (km)',
            labelStyle: TextStyle(color: Colors.grey),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFb3ff00)),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFb3ff00)),
            ),
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Cancel',
                style: TextStyle(color: Colors.grey)),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text('Save',
                style: TextStyle(color: Color(0xFFb3ff00))),
            onPressed: () {
              double newGoal = double.tryParse(controller.text) ?? _distanceGoal;
              setState(() {
                _distanceGoal = newGoal;
              });
              saveGoal(newGoal);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isPaused) {
        setState(() {
          _seconds++;
          _duration = '${_seconds ~/ 3600}h ${(_seconds % 3600) ~/ 60}m';
        });
      }
    });
  }

  void onStepCount(StepCount event) {
  print("Steps updated: ${event.steps}");
  if (_initialSteps == 0) {
    _initialSteps = event.steps;
  }
  if (!_isPaused) {
    setState(() {
      _steps = event.steps - _initialSteps;
      _updateStats(); // This now updates all metrics through provider
    });
    saveTodaySteps(_steps);
  }
}


  void onStepCountError(error) {
  print('Step count error: $error');
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Error occurred while counting steps.'),
    ),
  );
}

 void _updateStats() {
  // Update provider with all metrics
  Provider.of<DistanceProvider>(context, listen: false).updateMetrics(_steps);
  }


  void togglePause() {
    setState(() {
      _isPaused = !_isPaused;
      if (_isPaused) {
        _pausedSteps = _steps;
      }
    });
  }

  Future<void> saveTodaySteps(int steps) async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().split('T')[0];
    await prefs.setInt('steps_$today', steps);

    final weekday = DateTime.now().weekday;
    weeklySteps[_getWeekdayName(weekday)] = steps;
    await prefs.setString('weekly_steps', weeklySteps.toString());
  }

  String _getWeekdayName(int weekday) {
    switch (weekday) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
        return '';
    }
  }

  Future<void> loadTodaySteps() async {
  final prefs = await SharedPreferences.getInstance();
  final today = DateTime.now().toIso8601String().split('T')[0];
  setState(() {
    _steps = prefs.getInt('steps_$today') ?? 0;
  });
  _updateStats(); // Update provider with loaded steps
}

  Future<void> loadWeeklySteps() async {
    final prefs = await SharedPreferences.getInstance();
    final weeklyData = prefs.getString('weekly_steps');
    if (weeklyData != null) {
      setState(() {
        weeklySteps = Map<String, int>.from(
          weeklyData.split(',').map((entry) {
            final parts = entry.replaceAll('{', '').replaceAll('}', '').split(':');
            return MapEntry(
              parts[0].trim(),
              int.parse(parts[1].trim()),
            );
          }).toList().asMap().map((_, e) => e),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFFb3ff00)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Distance -->',
            style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              _buildDistanceCircle(),
              const SizedBox(height: 30),
              _buildStatsGrid(),
              const SizedBox(height: 30),
              _buildWeeklyProgress(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDistanceCircle() {
    double progress = _distance / _distanceGoal;
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: 250,
          width: 250,
          child: CircularProgressIndicator(
            value: progress,
            backgroundColor: const Color(0xFF3a3a3c),
            color: const Color(0xFFb3ff00),
            strokeWidth: 15,
          ),
        ),
        Container(
          height: 220,
          width: 220,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFF2d2d36),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${_distance.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Color(0xFFb3ff00),
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'km',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              Text(
                '${(progress * 100).toStringAsFixed(1)}%',
                style: const TextStyle(
                  color: Color(0xFFb3ff00),
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          child: IconButton(
            icon: Icon(
              _isPaused ? Icons.play_arrow : Icons.pause,
              color: const Color(0xFFb3ff00),
              size: 30,
            ),
            onPressed: togglePause,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsGrid() {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      crossAxisSpacing: 15,
      mainAxisSpacing: 15,
      children: [
        _buildStatCard('Steps', '$_steps', FontAwesomeIcons.personWalking),
        _buildStatCard('Calories', '$_calories cal', FontAwesomeIcons.fire),
        _buildStatCard('Duration', _duration, FontAwesomeIcons.clock),
        _buildStatCard('Goal', '${_distanceGoal.toStringAsFixed(2)} km',
            FontAwesomeIcons.flag, onTap: _showGoalEditDialog),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: const Color(0xFF2d2d36),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: const Color(0xFFb3ff00), size: 30),
            const SizedBox(height: 10),
            Text(value,
                style: const TextStyle(color: Colors.white, fontSize: 20)),
            Text(title,
                style: const TextStyle(color: Colors.grey, fontSize: 14)),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyProgress() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2d2d36),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Weekly Progress',
              style: TextStyle(color: Colors.white, fontSize: 18)),
          const SizedBox(height: 20),
          SizedBox(
            height: 140, // Fixed height for the progress bars section
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: weeklySteps.entries.map((entry) {
                double normalizedHeight = (entry.value / _distanceGoal).clamp(0.0, 1.0);
                return _buildDayBar(entry.key, normalizedHeight);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayBar(String day, double height) {
    return Column(
      children: [
        SizedBox(
          width: 30,
          height: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 8,
                height: 100 * height,
                decoration: BoxDecoration(
                  color: const Color(0xFFb3ff00),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(day,
            style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }
}