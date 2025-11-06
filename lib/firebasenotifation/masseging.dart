import 'package:firebase_messaging/firebase_messaging.dart';

class firebaseapi {
  final firebasemassge = FirebaseMessaging.instance;
  Future<void> handlerbackground(RemoteMessage message) async {
    print('title : ${message.notification?.title}');
    print('body : ${message.notification?.body}');
    print('paylod : ${message.data}');
  }

  Future<String?> initNotifications() async {
  await firebasemassge.requestPermission();
  final fCMToken = await firebasemassge.getToken();
  print('Token: $fCMToken');
  FirebaseMessaging.onBackgroundMessage(handlerbackground);
  return fCMToken;
}
}
