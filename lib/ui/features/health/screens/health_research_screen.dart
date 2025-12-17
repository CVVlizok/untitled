import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../delegates/health_research/health_research_cubit.dart';
import 'package:untitled/core/models/scientific_health_article.dart';

class HealthResearchScreen extends StatefulWidget {
  const HealthResearchScreen({super.key});

  @override
  State<HealthResearchScreen> createState() => _HealthResearchScreenState();
}

class _HealthResearchScreenState extends State<HealthResearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HealthResearchCubit>().loadMedicineConcepts();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Научные статьи'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildActionButtons(),
          _buildSearchBar(),
          _buildSelectedConcept(),
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: FilledButton.tonalIcon(
              onPressed: () {
                context.read<HealthResearchCubit>().loadMedicineConcepts();
              },
              icon: const Icon(Icons.medical_services),
              label: const Text('Medicine'),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: FilledButton.tonalIcon(
              onPressed: () {
                context.read<HealthResearchCubit>().loadPublicHealthConcepts();
              },
              icon: const Icon(Icons.health_and_safety),
              label: const Text('Public Health'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Поиск: diabetes, cancer, covid...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              context.read<HealthResearchCubit>().searchDiseases(
                _searchController.text,
              );
            },
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onSubmitted: (value) {
          context.read<HealthResearchCubit>().searchDiseases(value);
        },
      ),
    );
  }

  Widget _buildSelectedConcept() {
    return BlocBuilder<HealthResearchCubit, HealthResearchState>(
      builder: (context, state) {
        if (state.selectedConcept == null) return const SizedBox.shrink();
        
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                Icons.bookmark,
                color: Theme.of(context).colorScheme.onSecondaryContainer,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Концепт: ${state.selectedConcept!.name}',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContent() {
    return BlocBuilder<HealthResearchCubit, HealthResearchState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.error != null) {
          return _buildErrorState(state.error!);
        }

        // Если выбрана статья для деталей - показываем диалог
        if (state.selectedArticle != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showArticleDetails(context, state.selectedArticle!);
          });
        }

        // Показываем концепты или статьи
        if (state.requestType == ResearchRequestType.medicineConcepts ||
            state.requestType == ResearchRequestType.publicHealthConcepts) {
          return _buildConceptsList(state.concepts);
        }

        return _buildArticlesList(state.articles);
      },
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Ошибка',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => context.read<HealthResearchCubit>().loadData(),
              icon: const Icon(Icons.refresh),
              label: const Text('Повторить'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConceptsList(List<HealthConcept> concepts) {
    if (concepts.isEmpty) {
      return const Center(child: Text('Концепты не найдены'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: concepts.length,
      itemBuilder: (context, index) {
        final concept = concepts[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: Icon(
                Icons.category,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
            title: Text(
              concept.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (concept.description != null)
                  Text(
                    concept.description!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    if (concept.worksCount != null)
                      _buildChip('${concept.worksCount} статей'),
                    if (concept.citedByCount != null) ...[
                      const SizedBox(width: 8),
                      _buildChip('${concept.citedByCount} цитирований'),
                    ],
                  ],
                ),
              ],
            ),
            isThreeLine: true,
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              context.read<HealthResearchCubit>().selectConceptAndLoadWorks(concept);
            },
          ),
        );
      },
    );
  }

  Widget _buildChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall,
      ),
    );
  }

  Widget _buildArticlesList(List<ScientificHealthArticle> articles) {
    if (articles.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.science_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              'Статьи не найдены',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Попробуйте изменить параметры поиска',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: articles.length,
      itemBuilder: (context, index) {
        return _buildArticleCard(articles[index]);
      },
    );
  }

  Widget _buildArticleCard(ScientificHealthArticle article) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          context.read<HealthResearchCubit>().loadWorkDetails(article.id);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (article.isOpenAccess)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Open Access',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.green.shade800,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  const Spacer(),
                  if (article.publicationYear != null)
                    Text(
                      '${article.publicationYear}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                article.title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              if (article.journalName != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.menu_book,
                      size: 16,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        article.journalName!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 8),
              Row(
                children: [
                  if (article.citedByCount != null) ...[
                    Icon(
                      Icons.format_quote,
                      size: 16,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${article.citedByCount} цитирований',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                  const Spacer(),
                  Icon(
                    Icons.info_outline,
                    size: 16,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showArticleDetails(BuildContext context, ScientificHealthArticle article) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.outline,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (article.isOpenAccess)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.lock_open, 
                            size: 16, 
                            color: Colors.green.shade800,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Open Access',
                            style: TextStyle(
                              color: Colors.green.shade800,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 16),
                  Text(
                    article.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildDetailRow(
                    Icons.calendar_today,
                    'Год публикации',
                    article.publicationYear?.toString() ?? 'Н/Д',
                  ),
                  _buildDetailRow(
                    Icons.format_quote,
                    'Цитирований',
                    article.citedByCount?.toString() ?? '0',
                  ),
                  if (article.journalName != null)
                    _buildDetailRow(
                      Icons.menu_book,
                      'Журнал',
                      article.journalName!,
                    ),
                  if (article.doi != null)
                    _buildDetailRow(
                      Icons.link,
                      'DOI',
                      article.doi!,
                    ),
                  if (article.abstractText != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      'Аннотация',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      article.abstractText!,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                  const SizedBox(height: 24),
                  if (article.url != null)
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () => _openUrl(article.url!),
                        icon: const Icon(Icons.open_in_new),
                        label: const Text('Открыть статью'),
                      ),
                    ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        this.context.read<HealthResearchCubit>().clearSelectedArticle();
                      },
                      child: const Text('Закрыть'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    ).whenComplete(() {
      context.read<HealthResearchCubit>().clearSelectedArticle();
    });
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.outline),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.tryParse(url);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

