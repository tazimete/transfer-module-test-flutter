import 'package:json_annotation/json_annotation.dart';

class GenericResponse<T> {
  @JsonKey(name: 'isSuccess')
  bool isSuccess;

  @JsonKey(name: 'message')
  String? message;

  @JsonKey(name: 'result')
  T? result;

  @JsonKey(name: 'data')
  T? data;

  GenericResponse({
    this.isSuccess = false,
    this.message,
    this.result,
    this.data,
  });

  factory GenericResponse.fromJson(Map<String, dynamic> json) {
    return GenericResponse<T>(
      isSuccess: json['isSuccess'] as bool? ?? false,
      message: json['message'] as String?,
      result: json['result'] as T?,
      data: json['data'] as T?,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'isSuccess': isSuccess,
      'message': message,
      'result': result,
      'data': data,
    };
  }
}
