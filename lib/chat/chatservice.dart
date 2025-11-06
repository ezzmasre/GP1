import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wibsite/chat/formassege/massage.dart';

class chatservice {
  final FirebaseFirestore firestoree = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Stream<List<Map<String, dynamic>>> getuserstream() {
    return firestoree.collection("Users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  Future<void> sendmassege(String reciverid, String massage) async {
    final String currentuserid = auth.currentUser!.uid;
    final String currentusereamil = auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    Message newmassege = Message(
      senderID: currentuserid,
      senderEmaiI: currentusereamil,
      receiverlD: reciverid,
      message: massage,
      timestamp: timestamp,
    );

    List<String> ids = [currentuserid, reciverid];
    ids.sort();
    String chatroom = ids.join('_');
    //print("Chat room: $chatroom");
    //print("Message: ${newmassege.tomap()}");

    await firestoree
        .collection("chat_rooms")
        .doc(chatroom)
        .collection("messages")
        .add(newmassege.tomap());
  }

  Stream<QuerySnapshot> getmessages(String userid, String otherid) {
    List<String> ids = [userid, otherid];
    ids.sort();

    String chatroom = ids.join('_');
    print('Generated chatroom ID: $chatroom');

    return firestoree
        .collection("chat_rooms")
        .doc(chatroom)
        .collection("messages")
        .orderBy("Timestamp", descending: false)
        .snapshots();
  }
}
