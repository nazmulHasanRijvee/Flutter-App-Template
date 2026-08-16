class DailyVerse {
  final String verse;
  final String reference;
  final String reflection;
  final String prayer;

  const DailyVerse({
    required this.verse,
    required this.reference,
    required this.reflection,
    required this.prayer,
  });

  factory DailyVerse.fromJson(Map<String, dynamic> json) {
    return DailyVerse(
      verse: json['verse'] as String? ?? '',
      reference: json['reference'] as String? ?? '',
      reflection: json['reflection'] as String? ?? '',
      prayer: json['prayer'] as String? ?? '',
    );
  }
}
