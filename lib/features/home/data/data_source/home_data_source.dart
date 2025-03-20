import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dmj_task/features/home/data/model/add_task_model.dart';

class HomeDataSource {
  final FirebaseFirestore _firebaseFirestore;
  HomeDataSource(this._firebaseFirestore);

  Future<void> addTask(AddTaskModel task) async {
    try {
      DocumentReference docRef =
          await _firebaseFirestore.collection("tasks").add(task.toMap());
      await docRef.update({"taskId": docRef.id});
    } catch (error) {
      log("❌ Error adding task: ${error.toString()}");
    }
  }

  Stream<List<AddTaskModel>> getTasksStream() {
    return _firebaseFirestore
        .collection("tasks")
        .orderBy("date", descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => AddTaskModel.fromMap(
                    doc.data(),
                  ))
              .toList(),
        );
  }

  Future<void> updateTask(
      String taskId, Map<String, dynamic> updatedData) async {
    try {
      await _firebaseFirestore
          .collection("tasks")
          .doc(taskId)
          .update(updatedData);
      log("✅ Task updated: $taskId");
    } catch (error) {
      log("❌ Error updating task: ${error.toString()}");
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      await _firebaseFirestore.collection("tasks").doc(taskId).delete();
      log("✅ Task updated: $taskId");
    } catch (error) {
      log("❌ Error updating task: ${error.toString()}");
    }
  }
}
