class PrayerRequest {
  final int id;
  final String username;
  final String content;
  final int prayCount;
  final DateTime createdAt;

  const PrayerRequest({
    required this.id,
    required this.username,
    required this.content,
    this.prayCount = 0,
    required this.createdAt,
  });

  factory PrayerRequest.fromJson(Map<String, dynamic> json) {
    return PrayerRequest(
      id: json['id'] as int? ?? DateTime.now().millisecondsSinceEpoch,
      username: (json['username'] as String? ?? '').isNotEmpty
          ? json['username'] as String
          : 'Anonymous',
      content: json['content'] as String? ?? '',
      prayCount: json['prayCount'] as int? ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
    );
  }

  PrayerRequest copyWith({
    int? id,
    String? username,
    String? content,
    int? prayCount,
    DateTime? createdAt,
  }) {
    return PrayerRequest(
      id: id ?? this.id,
      username: username ?? this.username,
      content: content ?? this.content,
      prayCount: prayCount ?? this.prayCount,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
