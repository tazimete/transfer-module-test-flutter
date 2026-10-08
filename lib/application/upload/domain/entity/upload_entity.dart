/// Domain entity representing file upload outcome.
class UploadEntity {
  final String message;
  final String? fileUrl;
  final bool success;

  const UploadEntity({
    required this.message,
    this.fileUrl,
    required this.success,
  });
}
