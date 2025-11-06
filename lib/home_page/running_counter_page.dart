import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import '../providers/running_provider.dart'; // Ensure this path is correct

class RunningCounterPage extends StatefulWidget {
  const RunningCounterPage({super.key});

  @override
  State<RunningCounterPage> createState() => _RunningCounterPageState();
}

class _RunningCounterPageState extends State<RunningCounterPage> {
  bool _isPaused = true;
  double _distance = 0; // in kilometers
  int _calories = 0;
  String _duration = '0h 0m';
  Timer? _timer;
  int _seconds = 0;
  double _distanceGoal = 5.00;
  Position? _lastPosition;
  double _currentSpeed = 0;
  bool _permissionGranted = false; // Track permission status
  bool _locationServiceEnabled = false; // Track if location services are enabled

  Map<String, double> weeklyDistance = {
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
    print("Initializing RunningCounterPage...");
    _checkLocationServices(); // Check if location services are enabled
    _requestLocationPermission(); // Request location permission
    loadTodayDistance();
    loadWeeklyDistance();
    loadGoal();
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    print("Disposing RunningCounterPage...");
    super.dispose();
  }

  // Check if location services are enabled
  Future<void> _checkLocationServices() async {
    print("Checking if location services are enabled...");
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    setState(() {
      _locationServiceEnabled = serviceEnabled;
    });
    if (!serviceEnabled) {
      print("Location services are disabled.");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enable location services to track running.'),
        ),
      );
    } else {
      print("Location services are enabled.");
    }
  }

  // Request location permission
  Future<void> _requestLocationPermission() async {
    print("Requesting location permission...");
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        print("Location permission denied.");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Location permission denied. Running tracking will not work.'),
          ),
        );
      } else {
        setState(() {
          _permissionGranted = true;
        });
        print("Location permission granted.");
        startLocationTracking();
      }
    } else {
      setState(() {
        _permissionGranted = true;
      });
      print("Location permission already granted.");
      startLocationTracking();
    }
  }

  void startLocationTracking() {
    if (!_permissionGranted || !_locationServiceEnabled) {
      print("Cannot start location tracking. Permission: $_permissionGranted, Location Service: $_locationServiceEnabled");
      return;
    }
    print("Starting location tracking...");
    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 5, // Update every 5 meters
    );

    Geolocator.getPositionStream(locationSettings: locationSettings).listen((Position position) {
      print("New position: ${position.latitude}, ${position.longitude}");
      if (!_isPaused && _lastPosition != null) {
        double newDistance = Geolocator.distanceBetween(
          _lastPosition!.latitude,
          _lastPosition!.longitude,
          position.latitude,
          position.longitude,
        ) / 1000; // Convert to kilometers
        print("Distance added: $newDistance km");

        setState(() {
          _distance += newDistance;
          _currentSpeed = position.speed * 3.6; // Convert speed to km/h
          _updateStats();
        });
        saveTodayDistance(_distance);
      }
      _lastPosition = position;
    }, onError: (error) {
      print("Location stream error: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error occurred while tracking location.'),
        ),
      );
    });
  }

  Future<void> loadGoal() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _distanceGoal = prefs.getDouble('running_goal') ?? 5.0;
      print("Loaded running goal: $_distanceGoal km");
    });
  }

  Future<void> saveGoal(double goal) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('running_goal', goal);
    print("Saved running goal: $goal km");
  }

  void _showGoalEditDialog() {
    TextEditingController controller = TextEditingController(
      text: _distanceGoal.toString(),
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2d2d36),
        title: const Text('Set Running Goal',
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
          print("Timer updated: $_duration");
        });
      }
    });
  }

  void _updateStats() {
    _calories = (_distance * 60).round(); // Calories burned per km
    print("Updated stats - Distance: $_distance km, Calories: $_calories cal");
    Provider.of<RunningProvider>(context, listen: false).updateRunningDistance(_distance);
  }

  void togglePause() {
    setState(() {
      _isPaused = !_isPaused;
      print(_isPaused ? "Paused" : "Resumed");
    });
  }

  Future<void> saveTodayDistance(double distance) async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().split('T')[0];
    await prefs.setDouble('running_$today', distance);
    print("Saved today's distance: $distance km");

    final weekday = DateTime.now().weekday;
    weeklyDistance[_getWeekdayName(weekday)] = distance;
    await prefs.setString('weekly_running', weeklyDistance.toString());
    print("Saved weekly distance: $weeklyDistance");
  }

  Future<void> loadTodayDistance() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().split('T')[0];
    setState(() {
      _distance = prefs.getDouble('running_$today') ?? 0;
      print("Loaded today's distance: $_distance km");
      _updateStats();
    });
  }

  Future<void> loadWeeklyDistance() async {
    final prefs = await SharedPreferences.getInstance();
    final weeklyData = prefs.getString('weekly_running');
    if (weeklyData != null) {
      setState(() {
        weeklyDistance = Map<String, double>.from(
          weeklyData.split(',').map((entry) {
            final parts = entry.replaceAll('{', '').replaceAll('}', '').split(':');
            return MapEntry(
              parts[0].trim(),
              double.parse(parts[1].trim()),
            );
          }).toList().asMap().map((_, e) => e),
        );
        print("Loaded weekly distance: $weeklyDistance");
      });
    }
  }

  String _getWeekdayName(int weekday) {
    switch (weekday) {
      case 1: return 'Mon';
      case 2: return 'Tue';
      case 3: return 'Wed';
      case 4: return 'Thu';
      case 5: return 'Fri';
      case 6: return 'Sat';
      case 7: return 'Sun';
      default: return '';
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
        title: const Text('Running -->',
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
        _buildStatCard('Speed', '${_currentSpeed.toStringAsFixed(1)} km/h', FontAwesomeIcons.gauge),
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
            height: 140,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: weeklyDistance.entries.map((entry) {
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