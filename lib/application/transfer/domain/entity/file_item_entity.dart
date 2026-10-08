/// Domain entity representing an uploaded file item retrieved from the server.
class FileItemEntity {
  final String id;
  final String name;
  final String? url;
  final String? size;
  final String? uploadedAt;

  const FileItemEntity({
    required this.id,
    required this.name,
    this.url,
    this.size,
    this.uploadedAt,
  });
}
