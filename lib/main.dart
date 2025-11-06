import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:wibsite/admindasbord_wibsite/adminlogin.dart';
import 'package:wibsite/admindasbord_wibsite/homeadminpage.dart';
import 'package:wibsite/firebase_options.dart';
import 'package:wibsite/firebasenotifation/mainfirebase.dart';
import 'package:wibsite/firebasenotifation/masseging.dart';
import 'package:wibsite/home_page/home.dart';
import 'package:wibsite/notificationss/local_notification.dart';
import 'package:wibsite/providers/distance_provider.dart';
import 'package:wibsite/providers/running_provider.dart';

import 'package:wibsite/sign_inmoblie/auth_gate.dart';

//import 'package:wibsite/db/mongo.dart';
import 'package:provider/provider.dart';

import 'home_page/food_page/meals.dart';
import 'notificationss/notifacationbody.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

//   runApp(
//     MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: () => DistanceProvider()),
//          ChangeNotifierProvider(create: () => RunningProvider()),
//         ChangeNotifierProvider(create: (_) => MealProvider()),
//       ],
//       child: const MainApp(),
//     ),
//   );
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // Initialize notifications
  await NotificationHelper.initializeNotifications();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // await firebaseapi().initNotifications();

    runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DistanceProvider()),
         ChangeNotifierProvider(create: (_) => RunningProvider()),
        ChangeNotifierProvider(create: (_) => MealProvider()),
      ],
      child: const MainApp(),
    ),
  );
}
//  runApp(
//     ChangeNotifierProvider(
//       create: (context) => MealProvider(),
//       child: const MainApp(),
//     ),
//   );

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "ezz masre",
      debugShowCheckedModeBanner: false,
     // home: HomePageWeb(),
      home: auth_gate(),
   // home: Adminlogin(),
      //home: Notifacationbody(),
      //home: Home_Page(),
    );
  }
  /*
  final List<Map<String, String>> videos = [
    {
      'id': 'o2tDhbgYEdk',
      'title': 'Workout Video 10',
      'description': 'This is a description for video 1.'
    },
    {
      'id': '1Lg5rJSKjZk',
      'title': 'Workout Video 2',
      'description': 'This is a description for video 2.'
    },m 
    {
      'id': 'LFJ9ptKsQUo',
      'title': 'Workout Video 3',
      'description': 'This is a description for video 3.'
    },
    {
      'id': 'qdGtc6-c0F0',
      'title': 'Workout Video 4',
      'description': 'This is a description for video 4.'
    },
  ];
  */
}
