import 'package:untitled/core/models/scientific_health_article.dart';
import '../../interfaces/health_research_repository.dart';

/// UseCase: Поиск концептов по теме "медицина"
/// OpenAlex: GET /concepts?search=medicine
class SearchMedicineConcepts {
  final HealthResearchRepository _repository;

  SearchMedicineConcepts(this._repository);

  Future<List<HealthConcept>> call() async {
    return _repository.searchMedicineConcepts();
  }
}

