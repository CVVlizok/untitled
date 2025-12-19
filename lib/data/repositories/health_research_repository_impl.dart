import 'package:untitled/core/models/scientific_health_article.dart';
import '../../domain/interfaces/health_research_repository.dart';
import '../datasources/open_alex_api_client.dart';
import '../mappers/scientific_article_mapper.dart';

class HealthResearchRepositoryImpl implements HealthResearchRepository {
  final OpenAlexApiClient _apiClient;

  HealthResearchRepositoryImpl(this._apiClient);

  @override
  Future<List<HealthConcept>> searchMedicineConcepts() async {
    final response = await _apiClient.searchMedicineConcepts();
    return response.results?.toModels() ?? [];
  }

  @override
  Future<List<HealthConcept>> searchPublicHealthConcepts() async {
    final response = await _apiClient.searchPublicHealthConcepts();
    return response.results?.toModels() ?? [];
  }

  @override
  Future<List<ScientificHealthArticle>> getWorksByConcept(String conceptId) async {
    final filter = 'concept.id:$conceptId';
    final response = await _apiClient.getWorksByConcept(filter: filter);
    return response.results?.toModels() ?? [];
  }

  @override
  Future<List<ScientificHealthArticle>> searchDiseaseWorks(
    String query, {
    String? conceptId,
  }) async {
    final filter = conceptId != null ? 'concept.id:$conceptId' : null;
    final response = await _apiClient.searchDiseaseWorks(
      search: query,
      filter: filter,
    );
    return response.results?.toModels() ?? [];
  }

  @override
  Future<ScientificHealthArticle> getWorkDetails(String workId) async {
    final response = await _apiClient.getWorkDetails(id: workId);
    return response.toModel();
  }
}



