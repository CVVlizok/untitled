import 'package:untitled/core/models/scientific_health_article.dart';
import '../dto/open_alex/work_dto.dart';
import '../dto/open_alex/concept_dto.dart';

extension WorkDtoMapper on WorkDto {
  ScientificHealthArticle toModel() {
    return ScientificHealthArticle(
      id: _extractOpenAlexId(id),
      title: displayName ?? title ?? 'Без названия',
      publicationYear: publicationYear,
      citedByCount: citedByCount,
      journalName: primaryLocation?.source?.displayName,
      doi: doi,
      url: primaryLocation?.landingPageUrl ?? openAccess?.oaUrl,
      isOpenAccess: openAccess?.isOa ?? false,
      abstractText: _reconstructAbstract(abstractInvertedIndex),
    );
  }

  String _extractOpenAlexId(String? fullId) {
    if (fullId == null) return '';
    // ID формата: https://openalex.org/W2741809807
    final parts = fullId.split('/');
    return parts.isNotEmpty ? parts.last : fullId;
  }

  String? _reconstructAbstract(Map<String, dynamic>? invertedIndex) {
    if (invertedIndex == null || invertedIndex.isEmpty) return null;
    
    try {
      // Инвертированный индекс: {"word": [0, 5, 10], "another": [1, 6]}
      // Нужно восстановить текст по позициям
      final Map<int, String> positionToWord = {};
      
      invertedIndex.forEach((word, positions) {
        if (positions is List) {
          for (var pos in positions) {
            if (pos is int) {
              positionToWord[pos] = word;
            }
          }
        }
      });
      
      if (positionToWord.isEmpty) return null;
      
      final sortedPositions = positionToWord.keys.toList()..sort();
      final words = sortedPositions.map((pos) => positionToWord[pos]!).toList();
      
      return words.join(' ');
    } catch (_) {
      return null;
    }
  }
}

extension WorkDtoListMapper on List<WorkDto> {
  List<ScientificHealthArticle> toModels() {
    return map((dto) => dto.toModel()).toList();
  }
}

extension ConceptDtoMapper on ConceptDto {
  HealthConcept toModel() {
    return HealthConcept(
      id: _extractConceptId(id),
      name: displayName ?? 'Неизвестно',
      description: description,
      worksCount: worksCount,
      citedByCount: citedByCount,
    );
  }

  String _extractConceptId(String? fullId) {
    if (fullId == null) return '';
    // ID формата: https://openalex.org/C71924100
    final parts = fullId.split('/');
    return parts.isNotEmpty ? parts.last : fullId;
  }
}

extension ConceptDtoListMapper on List<ConceptDto> {
  List<HealthConcept> toModels() {
    return map((dto) => dto.toModel()).toList();
  }
}



