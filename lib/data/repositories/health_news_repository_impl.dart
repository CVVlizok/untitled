import 'package:untitled/core/models/health_news_article.dart';
import '../../domain/interfaces/health_news_repository.dart';
import '../datasources/news_api_client.dart';
import '../mappers/health_news_mapper.dart';

class HealthNewsRepositoryImpl implements HealthNewsRepository {
  final NewsApiClient _apiClient;

  HealthNewsRepositoryImpl(this._apiClient);

  @override
  Future<List<HealthNewsArticle>> getGeneralHealthNews() async {
    final response = await _apiClient.getGeneralHealthNews();
    return response.articles?.toModels() ?? [];
  }

  @override
  Future<List<HealthNewsArticle>> getPsychologyNews() async {
    final response = await _apiClient.getPsychologyNews();
    return response.articles?.toModels() ?? [];
  }

  @override
  Future<List<HealthNewsArticle>> getSleepNews() async {
    final response = await _apiClient.getSleepNews();
    return response.articles?.toModels() ?? [];
  }

  @override
  Future<List<HealthNewsArticle>> getNutritionNews() async {
    final response = await _apiClient.getNutritionNews();
    return response.articles?.toModels() ?? [];
  }

  @override
  Future<List<HealthNewsArticle>> searchHealthNews(String query) async {
    final response = await _apiClient.searchHealthNews(query: query);
    return response.articles?.toModels() ?? [];
  }
}
