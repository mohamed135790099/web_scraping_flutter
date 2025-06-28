class ResponseModel {
  dynamic success;
  dynamic statusCode;
  dynamic message;
  dynamic messageAr;
  dynamic data = {};

  ResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    statusCode = json['status'];
    message = json['message'];
    messageAr = json['messageAR'];
    data = json;
  }
}