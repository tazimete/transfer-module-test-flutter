import '../../domain/entity/file_item_entity.dart';

class FileItemModel {
  final String? id;
  final String? name;
  final String? filename;
  final String? url;
  final String? size;
  final String? uploadedAt;

  const FileItemModel({
    this.id,
    this.name,
    this.filename,
    this.url,
    this.size,
    this.uploadedAt,
  });

  factory FileItemModel.fromJson(Map<String, dynamic> json) {
    return FileItemModel(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: json['name'] as String? ?? json['filename'] as String? ?? json['file_name'] as String? ?? 'Untitled File',
      filename: json['filename'] as String?,
      url: json['url'] as String? ?? json['file_url'] as String?,
      size: json['size']?.toString(),
      uploadedAt: json['uploaded_at'] as String? ?? json['created_at'] as String?,
    );
  }

  FileItemEntity toDomain() {
    return FileItemEntity(
      id: id ?? '0',
      name: name ?? filename ?? 'Untitled File',
      url: url,
      size: size,
      uploadedAt: uploadedAt,
    );
  }
}
