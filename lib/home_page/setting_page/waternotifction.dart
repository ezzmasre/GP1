import 'package:flutter/material.dart';
import 'package:wibsite/notificationss/local_notification.dart';

class WaterNotification extends StatefulWidget {
  const WaterNotification({Key? key}) : super(key: key);

  @override
  _WaterNotificationState createState() => _WaterNotificationState();
}

class _WaterNotificationState extends State<WaterNotification> {
  final TextEditingController delayController = TextEditingController();

  @override
  void dispose() {
    delayController.dispose();
    super.dispose();
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: const Text(
            'Success!',
            style: TextStyle(color: Color(0xffD5FF5F)),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(
                Icons.local_drink,
                color: Color(0xffD5FF5F),
                size: 50,
              ),
              SizedBox(height: 10),
              Text(
                'Your water reminder has been scheduled!',
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 10),
              Text(
                'Stay hydrated and drink water regularly! 💧',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'OK',
                style: TextStyle(color: Color(0xffD5FF5F)),
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
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Water Reminder',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Description for the user
            const Text(
              '💧 Stay Hydrated! 💧',
              style: TextStyle(
                color: Color(0xffD5FF5F),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Set a reminder to drink water regularly. Enter the delay (in seconds) below, and we\'ll notify you when it\'s time to hydrate!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: delayController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Color(0xffD5FF5F)),
              decoration: InputDecoration(
                labelText: 'Delay (in seconds)',
                labelStyle: const TextStyle(color: Colors.white),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xffD5FF5F)),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xffD5FF5F)),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffD5FF5F),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              onPressed: () {
                final delay = int.tryParse(delayController.text.trim()) ?? 0;

                if (delay > 0) {
                  NotificationHelper.startCustomTimer(
                    title: 'Time to Hydrate! 💧',
                    body: 'Drink a glass of water to stay healthy and refreshed!',
                    seconds: delay,
                  );
                  _showSuccessDialog();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a valid delay in seconds.'),
                    ),
                  );
                }
              },
              child: const Text(
                'Schedule Water Reminder',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}