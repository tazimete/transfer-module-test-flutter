/// Domain entity representing a file download request.
class DownloadEntity {
  final String fileUrl;
  final String fileName;
  final String? localPath;

  const DownloadEntity({
    required this.fileUrl,
    required this.fileName,
    this.localPath,
  });
}
