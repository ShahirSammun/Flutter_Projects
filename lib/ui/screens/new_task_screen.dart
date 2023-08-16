import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app4/data/models/Task_list_model.dart';
import 'package:mobile_app4/data/models/network_response.dart';
import 'package:mobile_app4/data/models/summary_count.dart';
import 'package:mobile_app4/data/services/network_caller.dart';
import 'package:mobile_app4/data/utils/urls.dart';
import 'package:mobile_app4/ui/screens/add_new_task_screen.dart';
import 'package:mobile_app4/ui/screens/update_task_status_sheet.dart';
import 'package:mobile_app4/ui/state_managers/summary_count.controller.dart';
import 'package:mobile_app4/ui/widgets/screen_background.dart';
import 'package:mobile_app4/ui/widgets/summary_card.dart';
import 'package:mobile_app4/ui/widgets/task_list_tile.dart';
import 'package:mobile_app4/ui/widgets/user_profile_appbar.dart';
import 'update_task_bottom_sheet.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({Key? key}) : super(key: key);

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  bool _getNewTaskInProgress = false;
  SummaryCountModel _summaryCountModel = SummaryCountModel();
  TaskListModel _taskListModel = TaskListModel();

  final SummaryCountController _summaryCountController = Get.find<SummaryCountController>();
  @override
  void initState() {
    super.initState();
    // after widget binding
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _summaryCountController.getCountSummary();
      getNewTasks();
    });
  }

  Future<void> getNewTasks() async {
    _getNewTaskInProgress = true;
    if (mounted) {
      setState(() {});
    }
    final NetworkResponse response =
    await NetworkCaller().getRequest(Urls.newTasks);
    if (response.isSuccess) {
      _taskListModel = TaskListModel.fromJson(response.body!);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Summary data got failed')));
      }
    }
    _getNewTaskInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> deleteTask(String taskId) async {
    final NetworkResponse response =
    await NetworkCaller().getRequest(Urls.deleteTask(taskId));
    if (response.isSuccess) {
      _taskListModel.data!.removeWhere((element) => element.sId == taskId);
      if (mounted) {
        setState(() {});
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Deletion of the task has failed')));
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: Column(
          children: [
            const UserProfileAppBar(),
            GetBuilder<SummaryCountController>(

              builder: (_) {
                if(_summaryCountController.getCountSummaryInProgress){
                  return const Center(
                    child: LinearProgressIndicator(),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 80,
                    width: double.infinity,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _summaryCountController.summaryCountModel.data?.length ?? 0,
                      itemBuilder: (context, index) {
                        return SummaryCard(
                          title: _summaryCountController.summaryCountModel.data![index].sId ?? 'New',
                          number: _summaryCountController.summaryCountModel.data![index].sum ?? 0,
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return const Divider(
                          height: 4,
                        );
                      },
                    ),
                  ),
                );
              }
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  getNewTasks();
                  _summaryCountController.getCountSummary();
                },
                child: _getNewTaskInProgress
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
                        // showEditBottomSheet(_taskListModel.data![index]);
                        showStatusUpdateBottomSheet(_taskListModel.data![index]);
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
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const AddNewTaskScreen()));
        },
      ),
    );
  }

  void showEditBottomSheet(TaskData task) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return UpdateTaskSheet(
          task: task,
          onUpdate: () {
            getNewTasks();
          },
        );
      },
    );
  }

  void showStatusUpdateBottomSheet(TaskData task) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return UpdateTaskStatusSheet(task: task, onUpdate: () {
          getNewTasks();
        });
      },
    );
  }
}