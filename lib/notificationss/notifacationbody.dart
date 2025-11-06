import 'package:flutter/material.dart';
import 'package:wibsite/notificationss/local_notification.dart';

class Notifacationbody extends StatefulWidget {
  const Notifacationbody({Key? key}) : super(key: key);

  @override
  _NotifacationbodyState createState() => _NotifacationbodyState();
}

class _NotifacationbodyState extends State<Notifacationbody> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();
  final TextEditingController delayController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    bodyController.dispose();
    delayController.dispose();
    super.dispose();
  }

  void _showConfirmationDialog(String title, String body, int delay) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: Color(0xffD5FF5F), width: 2),
          ),
          title: const Text(
            'Confirm Notification',
            style: TextStyle(
              color: Color(0xffD5FF5F),
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Are you sure you want to schedule a notification with the following details?\n\nTitle: $title\nBody: $body\nDelay: $delay seconds',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                NotificationHelper.startCustomTimer(
                  title: title,
                  body: body,
                  seconds: delay,
                );
                Navigator.of(context).pop(); // Close the dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text(
                      'Notification Scheduled Successfully!',
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              },
              child: const Text(
                'Confirm',
                style: TextStyle(
                  color: Color(0xffD5FF5F),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
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
          'Custom Notification ',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'You can add any notification by filling out the form below. Simply enter the title, body, and delay (in seconds) for the notification, and click the "Schedule Notification" button to schedule it.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              _buildTextField(
                controller: titleController,
                label: 'Notification Title',
                hint: 'Enter the title',
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: bodyController,
                label: 'Notification Body',
                hint: 'Enter the body',
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: delayController,
                label: 'Delay (in seconds)',
                hint: 'Enter the delay',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffD5FF5F),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 5,
                  shadowColor: const Color(0xffD5FF5F).withOpacity(0.5),
                ),
                onPressed: () {
                  final title = titleController.text.trim();
                  final body = bodyController.text.trim();
                  final delay = int.tryParse(delayController.text.trim()) ?? 0;

                  if (title.isNotEmpty && body.isNotEmpty && delay > 0) {
                    _showConfirmationDialog(title, body, delay);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Please fill all fields correctly',
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: const Text(
                  'Schedule Notification',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Color(0xffD5FF5F)),
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
        hintText: hint,
        hintStyle: const TextStyle(
          color: Colors.grey,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color(0xffD5FF5F),
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color(0xffD5FF5F),
            width: 2,
          ),
        ),
      ),
    );
  }
}