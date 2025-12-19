import 'package:untitled/core/models/health_news_article.dart';
import '../../interfaces/health_news_repository.dart';

/// UseCase: Получить новости о питании
/// NewsAPI: GET /everything?q=питание OR диета&language=ru
class GetNutritionNews {
  final HealthNewsRepository _repository;

  GetNutritionNews(this._repository);

  Future<List<HealthNewsArticle>> call() async {
    return _repository.getNutritionNews();
  }
}



