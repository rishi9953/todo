import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_list/Controllers/controller.dart';
import 'package:todo_list/Modals/modal.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<Controller>(
        init: Controller(),
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              elevation: 1,
              title: const Text('To-Do'),
            ),
            body: buildTaskList(controller, controller.tasks),
            floatingActionButton: FloatingActionButton(
              onPressed: () => controller.showTaskDialog(context),
              child: const Icon(Icons.add),
            ),
          );
        });
  }

  Widget buildTaskList(Controller controller, List<TodoModal> tasks) {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        return Dismissible(
          key: Key(tasks[index].task),
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            if (direction == DismissDirection.startToEnd) {
              controller.changeTaskStatus(index);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text('${tasks[index].task} marked as completed')),
              );
            } else if (direction == DismissDirection.endToStart) {
              controller.deleteTask(index);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${tasks[index].task} deleted')),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: ListTile(
                leading: Checkbox(
                  value: tasks[index].status,
                  onChanged: (value) {
                    controller.changeTaskStatus(tasks.indexOf(tasks[index]));
                  },
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                title: Text(tasks[index].task),
                subtitle: Text(
                    tasks[index].status == false ? 'Pending' : 'Completed'),
                trailing: PopupMenuButton(
                  onSelected: (selectedValue) {
                    if (selectedValue == 'edit') {
                      controller.showTaskDialog(context,
                          task: tasks[index].task, index: index);
                    } else if (selectedValue == 'delete') {
                      controller.confirmDialog(tasks.indexOf(tasks[index]));
                    }
                  },
                  itemBuilder: (context) {
                    return [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Text('Edit'),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text('Delete'),
                      ),
                    ];
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
