class ReviewLog {
  final String id;
  final String mediaId;
  final String bookmarkId;
  final String createDate;
  final String recordUrl;

  ReviewLog({
    required this.id,
    required this.mediaId,
    required this.bookmarkId,
    required this.createDate,
    required this.recordUrl,
  });

  ReviewLog copy({
    String? id,
    String? mediaId,
    String? bookmarkId,
    String? createDate,
    String? recordUrl,
  }) =>
      ReviewLog(
        id: id ?? this.id,
        mediaId: mediaId ?? this.mediaId,
        bookmarkId: bookmarkId ?? this.bookmarkId,
        recordUrl: recordUrl ?? this.recordUrl,
        createDate: createDate ?? this.createDate,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'mediaId': mediaId,
        'bookmarkId': bookmarkId,
        'recordUrl': recordUrl,
        'createDate': createDate,
      };

  factory ReviewLog.fromJson(Map<String, dynamic> json) => ReviewLog(
        id: json['id'],
        mediaId: json['mediaId'],
        bookmarkId: json['bookmarkId'],
        recordUrl: json['recordUrl'],
        createDate: json['createDate'],
      );
}
