import 'package:untitled/core/models/health_news_article.dart';
import '../dto/news_api/article_dto.dart';

extension ArticleDtoMapper on ArticleDto {
  HealthNewsArticle toModel() {
    return HealthNewsArticle(
      title: title ?? 'Без заголовка',
      description: description,
      url: url,
      imageUrl: urlToImage,
      sourceName: source?.name,
      publishedAt: _parseDate(publishedAt),
      author: author,
    );
  }

  DateTime? _parseDate(String? dateStr) {
    if (dateStr == null) return null;
    try {
      return DateTime.parse(dateStr);
    } catch (_) {
      return null;
    }
  }
}

extension ArticleDtoListMapper on List<ArticleDto> {
  List<HealthNewsArticle> toModels() {
    return map((dto) => dto.toModel()).toList();
  }
}



