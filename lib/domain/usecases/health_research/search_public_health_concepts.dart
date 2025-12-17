import 'package:untitled/core/models/scientific_health_article.dart';
import '../../interfaces/health_research_repository.dart';

/// UseCase: Поиск концептов по теме "общественное здоровье"
/// OpenAlex: GET /concepts?search=public health
class SearchPublicHealthConcepts {
  final HealthResearchRepository _repository;

  SearchPublicHealthConcepts(this._repository);

  Future<List<HealthConcept>> call() async {
    return _repository.searchPublicHealthConcepts();
  }
}

