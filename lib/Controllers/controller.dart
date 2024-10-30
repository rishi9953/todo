import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list/Modals/modal.dart';

class Controller extends GetxController {
  var tasks = <TodoModal>[].obs;
  List<TodoModal> get pendingTasks =>
      tasks.where((task) => task.status == false).toList();
  List<TodoModal> get completedTasks =>
      tasks.where((task) => task.status == true).toList();
  int selectedTabIndex = 0;
  @override
  void onInit() {
    super.onInit();
    loadTasks();
  }

  Future<void> loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? taskList = prefs.getString('tasks');
    if (taskList != null) {
      List<dynamic> decodedData = json.decode(taskList);
      tasks.value =
          decodedData.map((item) => TodoModal.fromJson(item)).toList();
    }
    update();
  }

  Future<void> _saveTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> taskList =
        tasks.map((task) => task.toJson()).toList();
    prefs.setString('tasks', json.encode(taskList));
  }

  void addTask(String task) {
    tasks.add(TodoModal(task: task));
    _saveTasks();
    update();
  }

  void changeTaskStatus(int index) {
    tasks[index].status = !tasks[index].status;
    tasks.refresh();
    _saveTasks();
    update();
  }

  void editTask(int index, String newTask) {
    tasks[index].task = newTask;
    _saveTasks();
    update();
  }

  void deleteTask(int index) {
    tasks.removeAt(index);
    _saveTasks();
    update();
  }

  void showTaskDialog(BuildContext context, {String? task, int? index}) {
    TextEditingController taskController = TextEditingController(text: task);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(task == null ? 'Add Task' : 'Edit Task'),
          content: TextField(
            controller: taskController,
            decoration: const InputDecoration(hintText: 'Enter task here'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (taskController.text.isNotEmpty) {
                  if (task == null) {
                    addTask(taskController.text);
                  } else {
                    editTask(index!, taskController.text);
                  }
                }
                Get.back();
              },
              child: Text(task == null ? 'Add' : 'Save'),
            ),
          ],
        );
      },
    );
  }

  void confirmDialog(int index) {
    showDialog(
      context: Get.context!,
      builder: (context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text('Do you want to delete?'),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                Get.back();
                deleteTask(index);
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}
