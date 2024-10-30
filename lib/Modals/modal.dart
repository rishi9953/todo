class TodoModal {
  String task;
  bool status;

  TodoModal({
    required this.task,
    this.status = false,
  });

  factory TodoModal.fromJson(Map<String, dynamic> json) {
    return TodoModal(
      task: json['task'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'task': task,
      'status': status,
    };
  }
}