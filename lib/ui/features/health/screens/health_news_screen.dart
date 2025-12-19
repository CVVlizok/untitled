import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../delegates/health_news/health_news_cubit.dart';
import 'package:untitled/core/models/health_news_article.dart';

class HealthNewsScreen extends StatefulWidget {
  const HealthNewsScreen({super.key});

  @override
  State<HealthNewsScreen> createState() => _HealthNewsScreenState();
}

class _HealthNewsScreenState extends State<HealthNewsScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HealthNewsCubit>().loadNews();
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
        title: const Text('Новости о здоровье'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildCategorySelector(),
          _buildSearchBar(),
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }

  Widget _buildCategorySelector() {
    return BlocBuilder<HealthNewsCubit, HealthNewsState>(
      builder: (context, state) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: SegmentedButton<NewsCategory>(
            segments: const [
              ButtonSegment(
                value: NewsCategory.general,
                label: Text('Здоровье'),
                icon: Icon(Icons.favorite),
              ),
              ButtonSegment(
                value: NewsCategory.psychology,
                label: Text('Психология'),
                icon: Icon(Icons.psychology),
              ),
              ButtonSegment(
                value: NewsCategory.sleep,
                label: Text('Сон'),
                icon: Icon(Icons.bedtime),
              ),
              ButtonSegment(
                value: NewsCategory.nutrition,
                label: Text('Питание'),
                icon: Icon(Icons.restaurant),
              ),
              ButtonSegment(
                value: NewsCategory.search,
                label: Text('Поиск'),
                icon: Icon(Icons.search),
              ),
            ],
            selected: {state.category},
            onSelectionChanged: (selected) {
              context.read<HealthNewsCubit>().setCategory(selected.first);
            },
          ),
        );
      },
    );
  }

  Widget _buildSearchBar() {
    return BlocBuilder<HealthNewsCubit, HealthNewsState>(
      builder: (context, state) {
        // Показываем поиск только для категории "Поиск"
        if (state.category != NewsCategory.search) {
          return const SizedBox.shrink();
        }
        
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Введите запрос на русском...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                icon: const Icon(Icons.send),
                onPressed: () {
                  context.read<HealthNewsCubit>().setSearchQuery(_searchController.text);
                  context.read<HealthNewsCubit>().search();
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onSubmitted: (value) {
              context.read<HealthNewsCubit>().setSearchQuery(value);
              context.read<HealthNewsCubit>().search();
            },
          ),
        );
      },
    );
  }

  Widget _buildContent() {
    return BlocBuilder<HealthNewsCubit, HealthNewsState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.error != null) {
          return _buildErrorState(state.error!);
        }

        if (state.articles.isEmpty) {
          return _buildEmptyState();
        }

        return RefreshIndicator(
          onRefresh: () => context.read<HealthNewsCubit>().loadNews(),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.articles.length,
            itemBuilder: (context, index) {
              return _buildArticleCard(state.articles[index]);
            },
          ),
        );
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
              onPressed: () => context.read<HealthNewsCubit>().loadNews(),
              icon: const Icon(Icons.refresh),
              label: const Text('Повторить'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.article_outlined,
            size: 64,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            'Нет новостей',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Попробуйте изменить категорию или поисковый запрос',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildArticleCard(HealthNewsArticle article) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _openArticle(article.url),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article.imageUrl != null)
              CachedNetworkImage(
                imageUrl: article.imageUrl!,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  height: 180,
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => Container(
                  height: 180,
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: const Icon(Icons.image_not_supported, size: 48),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (article.sourceName != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        article.sourceName!,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
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
                  if (article.description != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      article.description!,
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      if (article.publishedAt != null) ...[
                        Icon(
                          Icons.access_time,
                          size: 16,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatDate(article.publishedAt!),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ),
                      ],
                      const Spacer(),
                      Icon(
                        Icons.open_in_new,
                        size: 16,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }

  Future<void> _openArticle(String? url) async {
    if (url == null) return;
    final uri = Uri.tryParse(url);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
