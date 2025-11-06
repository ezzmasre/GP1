import 'dart:convert'; // For JSON encoding
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wibsite/firebasenotifation/gettoken.dart';

class FcmButtonPage extends StatelessWidget {
  const FcmButtonPage({Key? key}) : super(key: key);

Future<void> sendFcmMessage() async {
  const String url = 'https://fcm.googleapis.com/v1/projects/chatapp-59ea9/messages:send';

  // Generate the access token
  final String authToken = await getAccessToken();

  // JSON body
  const Map<String, dynamic> requestBody = {
    "message": {
      "token": "fzxQ7J0KT8G7Lxe911o1uq:APA91bFEbdrCRrQ1vMyx9jMq8wWCMdWksCSYCbOOdsNTdeg4FtcWtHP6TJNc2dkrJn-HtvU7-bY5zQpAVNtZnIUrX32paaRcRiy5Ms1vNOuZTvjZdflKn8U",
      "notification": {
        "title": "aboooooooooood داعر",
        "body": "abood dar"
      }
    }
  };

  // HTTP headers
  final Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $authToken',
  };

  try {
    // Send POST request
    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(requestBody),
    );

    // Handle response
    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Message sent successfully: ${response.body}');
    } else {
      print('Failed to send message: ${response.statusCode} - ${response.body}');
    }
  } catch (e) {
    print('Error occurred while sending FCM message: $e');
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Send FCM Request'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            sendFcmMessage();
          },
          child: const Text('Send FCM Request'),
        ),
      ),
    );
  }
}

