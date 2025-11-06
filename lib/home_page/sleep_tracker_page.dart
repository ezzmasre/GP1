import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class SleepTrackerPage extends StatefulWidget {
  const SleepTrackerPage({super.key});

  @override
  State<SleepTrackerPage> createState() => _SleepTrackerPageState();
}

class _SleepTrackerPageState extends State<SleepTrackerPage> {
  TimeOfDay? wakeUpTime;
  TimeOfDay? sleepTime;
  List<TimeOfDay> sleepOptions = [];
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    _loadSavedData(); // Load saved data when the page initializes
    tz.initializeTimeZones(); // Initialize timezone database
  }

  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _scheduleNotification(TimeOfDay bedtime) async {
    final now = DateTime.now();
    final bedtimeDateTime = DateTime(now.year, now.month, now.day, bedtime.hour, bedtime.minute);
    final notificationTime = bedtimeDateTime.subtract(const Duration(minutes: 30));

    if (notificationTime.isBefore(now)) {
      // If the notification time is in the past, schedule it for the next day
      final nextDay = now.add(const Duration(days: 1));
      final nextDayBedtime = DateTime(nextDay.year, nextDay.month, nextDay.day, bedtime.hour, bedtime.minute);
      final nextDayNotificationTime = nextDayBedtime.subtract(const Duration(minutes: 30));
      _scheduleNotificationAtTime(nextDayNotificationTime);
    } else {
      _scheduleNotificationAtTime(notificationTime);
    }
  }

Future<void> _scheduleNotificationAtTime(DateTime notificationTime) async {
  final now = DateTime.now();
  if (notificationTime.isAfter(now)) {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0, // Notification ID
      'Bedtime Reminder', // Title
      'You have 30 minutes until your scheduled bedtime. Get ready to sleep!', // Body
      tz.TZDateTime.from(notificationTime, tz.local), // Scheduled time
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'bedtime_channel', // Channel ID
           // Channel Name
          'Bedtime Reminders', // Channel Description
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }
}
  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    if (wakeUpTime != null) {
      prefs.setInt('wakeUpHour', wakeUpTime!.hour);
      prefs.setInt('wakeUpMinute', wakeUpTime!.minute);
    }
    if (sleepTime != null) {
      prefs.setInt('sleepHour', sleepTime!.hour);
      prefs.setInt('sleepMinute', sleepTime!.minute);
    }
  }

  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    final wakeUpHour = prefs.getInt('wakeUpHour');
    final wakeUpMinute = prefs.getInt('wakeUpMinute');
    final sleepHour = prefs.getInt('sleepHour');
    final sleepMinute = prefs.getInt('sleepMinute');

    if (wakeUpHour != null && wakeUpMinute != null) {
      setState(() {
        wakeUpTime = TimeOfDay(hour: wakeUpHour, minute: wakeUpMinute);
      });
    }
    if (sleepHour != null && sleepMinute != null) {
      setState(() {
        sleepTime = TimeOfDay(hour: sleepHour, minute: sleepMinute);
      });
    }
    _calculateSleepOptions();
  }

  void _calculateSleepOptions() {
    if (wakeUpTime != null) {
      final wakeDateTime = DateTime(2024, 1, 1, wakeUpTime!.hour, wakeUpTime!.minute);
      sleepOptions = [
        wakeDateTime.subtract(const Duration(hours: 6, minutes: 0)),
        wakeDateTime.subtract(const Duration(hours: 7, minutes: 30)),
        wakeDateTime.subtract(const Duration(hours: 9, minutes: 0)),
      ].map((dt) => TimeOfDay.fromDateTime(dt)).toList();
    } else {
      sleepOptions = []; // Clear options if wakeUpTime is null
    }
  }

  void _setSleepTime(TimeOfDay selectedSleepTime) {
    setState(() {
      sleepTime = selectedSleepTime;
    });
    _saveData(); // Save the selected sleep time
    _scheduleNotification(selectedSleepTime); // Schedule notification for the selected bedtime
  }

  Duration? get _sleepDuration {
    if (sleepTime == null || wakeUpTime == null) return null;
    final sleep = DateTime(2024, 1, 1, sleepTime!.hour, sleepTime!.minute);
    var wake = DateTime(2024, 1, 1, wakeUpTime!.hour, wakeUpTime!.minute);
    if (wake.isBefore(sleep)) wake = wake.add(const Duration(days: 1));
    return wake.difference(sleep);
  }

  int? get _cycleCount {
    final duration = _sleepDuration;
    if (duration == null) return null;
    return (duration.inMinutes / 90).round();
  }

  String _getFormattedDate() {
    final now = DateTime.now();
    final day = now.day;
    final month = now.month;
    final year = now.year;
    final weekday = now.weekday;
    final days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return 'Today, ${days[weekday - 1]}\n$day/${month.toString().padLeft(2, '0')}/$year';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Sleep Tracker', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _getFormattedDate(),
              style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            _buildSleepCard(),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: wakeUpTime ?? TimeOfDay.now(),
                );
                if (pickedTime != null) {
                  setState(() {
                    wakeUpTime = pickedTime;
                    _calculateSleepOptions();
                    _saveData(); // Save the selected wake-up time
                  });
                  _showSleepOptionsDialog();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD50000),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Set Wake Up Time', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSleepCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          _buildInfoRow(Icons.nightlight_round, 'Bedtime', sleepTime),
          const Divider(color: Colors.grey, height: 30),
          _buildInfoRow(Icons.wb_sunny, 'Wake Up', wakeUpTime),
          const Divider(color: Colors.grey, height: 30),
          _buildStatsRow(),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, TimeOfDay? time) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 28),
        const SizedBox(width: 15),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 16)),
        const Spacer(),
        Text(
          time != null ? time.format(context) : '--:--',
          style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildStatsRow() {
    final duration = _sleepDuration;
    final cycles = _cycleCount;
    final quality = cycles != null ? (cycles >= 5 ? 'Good' : 'Poor') : '--';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatColumn(Icons.access_time, 'Duration',
            duration != null ? '${duration.inHours}h ${duration.inMinutes.remainder(60)}m' : '--h --m'),
        _buildStatColumn(Icons.star, 'Quality', quality,
            color: quality == 'Good' ? const Color(0xFFD5FF5F) : const Color(0xFFD50000)),
        _buildStatColumn(Icons.repeat, 'Cycles', cycles?.toString() ?? '--'),
      ],
    );
  }

  Widget _buildStatColumn(IconData icon, String label, String value, {Color? color}) {
    return Column(
      children: [
        Icon(icon, color: color ?? Colors.white, size: 28),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(
          color: color ?? Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold
        )),
      ],
    );
  }

  void _showSleepOptionsDialog() {
    if (sleepOptions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please set a wake-up time first.')),
      );
      return;
    }
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey.shade900,
          title: const Text('Recommended Bedtimes',
              style: TextStyle(color: Colors.white, fontSize: 20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: sleepOptions.map((time) {
              final isSelected = sleepTime == time;
              return ListTile(
                title: Text(
                  time.format(context),
                  style: TextStyle(
                    color: isSelected ? const Color(0xFFD5FF5F) : Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  _getDurationLabel(time),
                  style: TextStyle(
                    color: isSelected ? const Color(0xFFD5FF5F).withOpacity(0.8) : Colors.grey,
                  ),
                ),
                onTap: () {
                  _setSleepTime(time);
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  String _getDurationLabel(TimeOfDay sleepTime) {
    if (wakeUpTime == null) return '';
    final sleep = DateTime(2024, 1, 1, sleepTime.hour, sleepTime.minute);
    var wake = DateTime(2024, 1, 1, wakeUpTime!.hour, wakeUpTime!.minute);
    if (wake.isBefore(sleep)) wake = wake.add(const Duration(days: 1));
    final duration = wake.difference(sleep);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    return '${hours}h ${minutes}m sleep';
  }
}