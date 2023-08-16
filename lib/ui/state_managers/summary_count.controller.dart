import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:mobile_app4/data/models/network_response.dart';
import 'package:mobile_app4/data/models/summary_count.dart';
import 'package:mobile_app4/data/services/network_caller.dart';
import 'package:mobile_app4/data/utils/urls.dart';

class SummaryCountController extends GetxController{
  bool _getCountSummaryInProgress = false;
  SummaryCountModel _summaryCountModel = SummaryCountModel();
  bool get getCountSummaryInProgress => _getCountSummaryInProgress;
  SummaryCountModel  get summaryCountModel => _summaryCountModel;
  Future<bool> getCountSummary() async {
    _getCountSummaryInProgress = true;
    update();
    final NetworkResponse response =
    await NetworkCaller().getRequest(Urls.taskStatusCount);
    _getCountSummaryInProgress = false;
    if (response.isSuccess) {
      _summaryCountModel = SummaryCountModel.fromJson(response.body!);
      update();
      return true;
    } else {
      update();
     return false;
    }
  }
}