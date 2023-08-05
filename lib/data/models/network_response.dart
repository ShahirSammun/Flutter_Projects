class NetworkResponse{
  final int statuscode;
  final bool isSuccess;
  final Map<String, dynamic>? body;
  NetworkResponse(this.isSuccess, this.statuscode, this.body);
}