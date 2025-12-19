import 'package:untitled/core/models/health_news_article.dart';

/// Интерфейс репозитория для новостей о здоровье (NewsAPI)
abstract class HealthNewsRepository {
  /// Получить общие новости о здоровье
  Future<List<HealthNewsArticle>> getGeneralHealthNews();

  /// Получить новости о психологии
  Future<List<HealthNewsArticle>> getPsychologyNews();

  /// Получить новости о сне
  Future<List<HealthNewsArticle>> getSleepNews();

  /// Получить новости о питании
  Future<List<HealthNewsArticle>> getNutritionNews();

  /// Поиск новостей по запросу
  Future<List<HealthNewsArticle>> searchHealthNews(String query);
}
