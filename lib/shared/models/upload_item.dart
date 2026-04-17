enum UploadStatus { uploading, ready, failed }

class UploadItem {
  const UploadItem({
    required this.id,
    required this.fileName,
    required this.category,
    required this.status,
    required this.updatedAt,
    this.progress = 0,
    this.sizeBytes,
  });

  final String id;
  final String fileName;
  final String category;
  final UploadStatus status;
  final DateTime updatedAt;
  final int progress;
  final int? sizeBytes;

  bool get isDone => status == UploadStatus.ready;
  bool get isFailed => status == UploadStatus.failed;
}
