import 'package:flutter/material.dart';
import 'package:mobile_app4/data/models/Task_list_model.dart';
import 'package:mobile_app4/data/models/network_response.dart';
import 'package:mobile_app4/data/services/network_caller.dart';
import 'package:mobile_app4/data/utils/urls.dart';
import 'package:mobile_app4/ui/screens/update_task_status_sheet.dart';
import 'package:mobile_app4/ui/widgets/screen_background.dart';
import 'package:mobile_app4/ui/widgets/task_list_tile.dart';
import 'package:mobile_app4/ui/widgets/user_profile_appbar.dart';

class CompletedTaskScreen extends StatefulWidget {
  const CompletedTaskScreen({Key? key}) : super(key: key);

  @override
  State<CompletedTaskScreen> createState() => _CompletedTaskScreenState();
}

class _CompletedTaskScreenState extends State<CompletedTaskScreen> {
  bool _getCompletedTaskCompleted = false;

  TaskListModel _taskListModel = TaskListModel();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
          (timeStamp) {
        getCompletedTasks();
      },
    );
  }

  Future<void> getCompletedTasks() async {
    _getCompletedTaskCompleted = true;
    if (mounted) {
      setState(() {});
    }
    final NetworkResponse response =
    await NetworkCaller().getRequest(Urls.completedTask);
    if (response.isSuccess) {
      _taskListModel = TaskListModel.fromJson(response.body!);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to load in progress task'),
          ),
        );
      }
    }
    _getCompletedTaskCompleted = false;
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> deleteTask(String taskId) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Do you want to delete',
            style: TextStyle(fontSize: 23, fontWeight: FontWeight.normal),
          ),
          content: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Are you sure?',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () async {
                    final NetworkResponse response =
                    await NetworkCaller().getRequest(
                      Urls.deleteTask(taskId),
                    );
                    if (response.isSuccess) {
                      _taskListModel.data!
                          .removeWhere((element) => element.sId == taskId);
                      if (mounted) {
                        setState(() {});
                      }
                    } else {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Task deletion failed'),
                          ),
                        );
                      }
                    }
                  },
                  child: const Text(
                    'Yes',
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'No',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            )
          ],
          contentPadding: const EdgeInsets.all(15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: Column(
          children: [
            const UserProfileAppBar(),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  getCompletedTasks();
                },
                child: _getCompletedTaskCompleted
                    ? const Center(
                  child: CircularProgressIndicator(),
                )
                    : ListView.separated(
                  itemCount: _taskListModel.data?.length ?? 0,
                  itemBuilder: (context, index) {
                    return TaskListTile(
                      data: _taskListModel.data![index],
                      onDeleteTap: () {
                        deleteTask(_taskListModel.data![index].sId!);
                      },
                      onEditTap: () {
                        showStatueUpdateBottomSheet(
                            _taskListModel.data![index]);
                      },
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const Divider(
                      height: 4,
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void showStatueUpdateBottomSheet(TaskData task) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return UpdateTaskStatusSheet(
          task: task,
          onUpdate: () {
            getCompletedTasks();
          },
        );
      },
    );
  }
}
