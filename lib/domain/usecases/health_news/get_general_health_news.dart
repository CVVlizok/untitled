import 'package:untitled/core/models/health_news_article.dart';
import '../../interfaces/health_news_repository.dart';

/// UseCase: Получить общие новости о здоровье
/// NewsAPI: GET /everything?q=здоровье OR медицина&language=ru
class GetGeneralHealthNews {
  final HealthNewsRepository _repository;

  GetGeneralHealthNews(this._repository);

  Future<List<HealthNewsArticle>> call() async {
    return _repository.getGeneralHealthNews();
  }
}