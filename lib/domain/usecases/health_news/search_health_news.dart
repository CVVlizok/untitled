import 'package:untitled/core/models/health_news_article.dart';
import '../../interfaces/health_news_repository.dart';

/// UseCase: Поиск новостей по ключевым словам о здоровье
/// NewsAPI: GET /everything?q=здоровье OR медицина&language=ru&sortBy=publishedAt
class SearchHealthNews {
  final HealthNewsRepository _repository;

  SearchHealthNews(this._repository);

  Future<List<HealthNewsArticle>> call(String query) async {
    return _repository.searchHealthNews(query);
  }
}

