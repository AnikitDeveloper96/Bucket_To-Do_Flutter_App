import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

////class FirebaseStorage {
String collectionName = "/My Tasks/";
FirebaseFirestore firestore = FirebaseFirestore.instance;

Future<void> addTasks(
    User user, String todoname, Timestamp dateCreated, bool iscompleted) {
  CollectionReference<Map<String, dynamic>> users =
      FirebaseFirestore.instance.collection(user.email ?? "");

  Map<String, dynamic> addTasksData = {
    'todoId': user.uid, // John Doe
    'todoName': todoname, // Stokes and Sons
    'dateCreated': dateCreated,
    'isCompleted': iscompleted,
  };
  // Call the user's CollectionReference to add a new user
  return users
      .doc(user.uid)
      .collection(collectionName)
      .add(addTasksData)
      .then((value) => print("User Added at "))
      .catchError((error) => print("Failed to add user: $error"));
}

Future deleteTasks(User getUser, String taskId) async {
  var collection = FirebaseFirestore.instance
      .collection(getUser.email ?? "")
      .doc(getUser.uid)
      .collection(collectionName); // fetch the collection name i.e. tasks
  collection
          .doc(
              taskId) // ensure the right task is deleted by passing the task id to the method
          .delete() // delete method removes the task entry in the collection
      ;
}

Future updateTask(User getUser, String taskId, bool completed) async {
  var collection = FirebaseFirestore.instance
      .collection(getUser.email ?? "")
      .doc(getUser.uid)
      .collection(collectionName); // fetch the collection name i.e. tasks
  collection
      .doc(
          taskId) // ensure the right task is deleted by passing the task id to the method
      .update({
    'isCompleted': completed,
  });
}

///}
