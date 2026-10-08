import '../../domain/entity/upload_entity.dart';

class UploadResponseModel {
  final String? message;
  final String? fileUrl;
  final bool? success;

  const UploadResponseModel({
    this.message,
    this.fileUrl,
    this.success,
  });

  factory UploadResponseModel.fromJson(Map<String, dynamic> json) {
    return UploadResponseModel(
      message: json['message'] as String?,
      fileUrl: json['file_url'] as String?,
      success: json['success'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'file_url': fileUrl,
      'success': success,
    };
  }

  UploadEntity toDomain() {
    return UploadEntity(
      message: message ?? 'File uploaded successfully',
      fileUrl: fileUrl,
      success: success ?? true,
    );
  }
}
