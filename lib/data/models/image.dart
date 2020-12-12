class Image {
  final String id;
  final String parentId;
  final String path;

  Image(this.id, this.parentId, this.path);

  Map<String, dynamic> toMap() {
    return {
      'ID': id,
      'parentID': parentId,
      'path': path,
    };
  }
}
