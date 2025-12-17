/// Domain модель для научных статей о здоровье (OpenAlex)
class ScientificHealthArticle {
  final String id;
  final String title;
  final int? publicationYear;
  final int? citedByCount;
  final String? journalName;
  final String? doi;
  final String? url;
  final bool isOpenAccess;
  final String? abstractText;

  const ScientificHealthArticle({
    required this.id,
    required this.title,
    this.publicationYear,
    this.citedByCount,
    this.journalName,
    this.doi,
    this.url,
    this.isOpenAccess = false,
    this.abstractText,
  });

  ScientificHealthArticle copyWith({
    String? id,
    String? title,
    int? publicationYear,
    int? citedByCount,
    String? journalName,
    String? doi,
    String? url,
    bool? isOpenAccess,
    String? abstractText,
  }) {
    return ScientificHealthArticle(
      id: id ?? this.id,
      title: title ?? this.title,
      publicationYear: publicationYear ?? this.publicationYear,
      citedByCount: citedByCount ?? this.citedByCount,
      journalName: journalName ?? this.journalName,
      doi: doi ?? this.doi,
      url: url ?? this.url,
      isOpenAccess: isOpenAccess ?? this.isOpenAccess,
      abstractText: abstractText ?? this.abstractText,
    );
  }

  @override
  String toString() {
    return 'ScientificHealthArticle(id: $id, title: $title, year: $publicationYear)';
  }
}

/// Модель для концептов из OpenAlex
class HealthConcept {
  final String id;
  final String name;
  final String? description;
  final int? worksCount;
  final int? citedByCount;

  const HealthConcept({
    required this.id,
    required this.name,
    this.description,
    this.worksCount,
    this.citedByCount,
  });

  @override
  String toString() {
    return 'HealthConcept(id: $id, name: $name)';
  }
}

