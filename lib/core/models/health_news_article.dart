/// Domain модель для новостей о здоровье (NewsAPI)
class HealthNewsArticle {
  final String title;
  final String? description;
  final String? url;
  final String? imageUrl;
  final String? sourceName;
  final DateTime? publishedAt;
  final String? author;

  const HealthNewsArticle({
    required this.title,
    this.description,
    this.url,
    this.imageUrl,
    this.sourceName,
    this.publishedAt,
    this.author,
  });

  HealthNewsArticle copyWith({
    String? title,
    String? description,
    String? url,
    String? imageUrl,
    String? sourceName,
    DateTime? publishedAt,
    String? author,
  }) {
    return HealthNewsArticle(
      title: title ?? this.title,
      description: description ?? this.description,
      url: url ?? this.url,
      imageUrl: imageUrl ?? this.imageUrl,
      sourceName: sourceName ?? this.sourceName,
      publishedAt: publishedAt ?? this.publishedAt,
      author: author ?? this.author,
    );
  }

  @override
  String toString() {
    return 'HealthNewsArticle(title: $title, sourceName: $sourceName)';
  }
}
