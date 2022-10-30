import 'dart:convert';

class Audio {
    Audio({
    required this.title,
    required this.description,
    required this.year,
    required this.url,
  });
  final String title;
  final String description;
  final String year;
  final String url;

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'year': year,
      'url': url,
    };
  }

  factory Audio.fromMap(Map<String, dynamic> map) {
    return Audio(
      title: map['Title'] ?? '',
      description: map['Description'] ?? '',
      year: map['Year'] ?? '',
      url: map['AudioUrl'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Audio.fromJson(String source) => Audio.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Audio(title: $title, description: $description, year: $year, url: $url)';
  }
}
