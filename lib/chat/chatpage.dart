import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:wibsite/chat/chatservice.dart';
import 'package:wibsite/firebasenotifation/gettoken.dart';
import 'package:wibsite/sign_inmoblie/auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For JSON encoding

class Chatpage extends StatefulWidget {
  final String riciveemail;
  final String riciveid;

  Chatpage({Key? key, required this.riciveemail, required this.riciveid})
      : super(key: key);

  @override
  _ChatpageState createState() => _ChatpageState();
}

class _ChatpageState extends State<Chatpage> {
  final TextEditingController massagecount = TextEditingController();
  final chatservice chatServ = chatservice();
  final Authservce authSer = Authservce();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  void initState() {
    super.initState();
    _initializeFirebaseMessaging();
    _initializeLocalNotifications();
  }

  void _initializeFirebaseMessaging() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        _showNotification(
          notification.hashCode,
          notification.title,
          notification.body,
        );
      }
    });
  }

  void _initializeLocalNotifications() {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _showNotification(int id, String? title, String? body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        id, title, body, platformChannelSpecifics);
  }

  void sendmaasge() async {
    if (massagecount.text.isNotEmpty) {
      String a = massagecount.text;
      sendFcmMessage(a);
      await chatServ.sendmassege(widget.riciveid, massagecount.text);
      print("Message sent: ${massagecount.text}");
      massagecount.clear();
    }
  }

  Future<void> sendFcmMessage(String a) async {
    String token = await getusertoken();
    print(token);
    const String url =
        'https://fcm.googleapis.com/v1/projects/chatapp-59ea9/messages:send';

    // Generate the access token
    final String authToken = await getAccessToken();

    // JSON body
    Map<String, dynamic> requestBody = {
      "message": {
        "token": token,
        "notification": {
          "title": authSer.getcurrentuser()!.email,
          "body": "${a}" // massagecount.text!
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
        print(
            'Failed to send message: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error occurred while sending FCM message: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Set black background
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          widget.riciveemail,
          style: const TextStyle(
              color: Color.fromARGB(255, 255, 243, 243),
              fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.black, // Match app bar with background
      ),
      body: Column(
        children: [
          Expanded(child: buldmassegelist()),
          const Divider(height: 1, color: Colors.white), // White divider
          bulduserinput(),
        ],
      ),
    );
  }

  Widget buldmassegelist() {
    String senedrid = authSer.getcurrentuser()!.uid;
    print(senedrid);
    print(widget.riciveid);

    return StreamBuilder(
      stream: chatServ.getmessages(widget.riciveid, senedrid),
      builder: (context, snapshot) {
        print(snapshot.data!.docs.isEmpty);
        if (snapshot.hasError) {
          return const Center(
              child: Text("An error occurred.",
                  style: TextStyle(color: Colors.white)));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(color: Colors.white));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
              child: Text("No messages found.",
                  style: TextStyle(color: Colors.white)));
        }

        List<DocumentSnapshot> messages = snapshot.data!.docs;
        return ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: messages.length,
          itemBuilder: (context, index) {
            return buldmassageitem(messages[index], index + 1);
          },
        );
      },
    );
  }

Widget buldmassageitem(DocumentSnapshot doc, int count) {
  Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
  bool iscurrent = data['senderID'] == authSer.getcurrentuser()!.uid;
  var alignment = iscurrent ? Alignment.centerRight : Alignment.centerLeft;
  var badgeColor =
      iscurrent ? Colors.teal : const Color.fromARGB(255, 4, 231, 114);

  return Container(
    margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
    alignment: alignment,
    child: Row(
      mainAxisSize: MainAxisSize.min, // Prevent unnecessary expansion
      children: [
        if (!iscurrent)
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: badgeColor,
              shape: BoxShape.circle,
            ),
            child: Text(
              '$count',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white,
              ),
            ),
          ),
        const SizedBox(width: 4),
        Container(
          constraints: const BoxConstraints(maxWidth: 250), // Limit width
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: iscurrent
                ? Colors.teal
                : const Color.fromARGB(255, 7, 124, 63),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            data["message"],
            style: const TextStyle(fontSize: 16, color: Colors.white),
            softWrap: true, // Allow wrapping
          ),
        ),
        const SizedBox(width: 4),
        if (iscurrent)
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: badgeColor,
              shape: BoxShape.circle,
            ),
            child: Text(
              '$count',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white,
              ),
            ),
          ),
      ],
    ),
  );
}

  Widget bulduserinput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
      color: Colors.grey.shade900, // Dark input area background
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: massagecount,
              decoration: InputDecoration(
                hintText: "Type your message...",
                hintStyle: const TextStyle(
                    color: Colors.white70), // Lighter text for hint
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 12.0,
                  horizontal: 16.0,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none, // Remove border line
                ),
                filled: true,
                fillColor: Colors.white30, // Semi-transparent input field
              ),
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: sendmaasge,
            icon: const Icon(Icons.send, color: Colors.teal),
          ),
        ],
      ),
    );
  }

  Future<String> getusertoken() async {
    final url =
        Uri.parse('https://fitnes-bakeend.onrender.com/pro/${widget.riciveemail}');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        final String token = jsonResponse['token'];
        return token;
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error occurred: $e');
    }
  }
}
