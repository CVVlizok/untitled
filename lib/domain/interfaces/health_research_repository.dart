import 'package:untitled/core/models/scientific_health_article.dart';

/// Интерфейс репозитория для научных статей о здоровье (OpenAlex)
abstract class HealthResearchRepository {
  /// Поиск концептов по теме "медицина"
  Future<List<HealthConcept>> searchMedicineConcepts();

  /// Поиск концептов по теме "общественное здоровье"
  Future<List<HealthConcept>> searchPublicHealthConcepts();

  /// Получить научные статьи по концепту
  Future<List<ScientificHealthArticle>> getWorksByConcept(String conceptId);

  /// Поиск научных статей по заболеваниям
  Future<List<ScientificHealthArticle>> searchDiseaseWorks(String query, {String? conceptId});

  /// Детальная информация по статье
  Future<ScientificHealthArticle> getWorkDetails(String workId);
}

