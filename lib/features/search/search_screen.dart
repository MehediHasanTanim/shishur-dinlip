import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shishur_dinlipi/core/di/core_providers.dart';
import 'package:shishur_dinlipi/core/domain/models/search_result.dart';
import 'package:shishur_dinlipi/features/children/child_controller.dart';
import 'package:shishur_dinlipi/features/search/search_labels.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';
import 'package:shishur_dinlipi/shared/widgets/app_state_views.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _queryController = TextEditingController();
  SearchResultType? _typeFilter;
  DateTime? _fromDate;
  DateTime? _toDate;
  List<SearchResult> _results = const [];
  List<String> _recent = const [];
  bool _searched = false;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadRecent());
  }

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  Future<void> _loadRecent() async {
    final recent = await ref.read(recentSearchesStoreProvider).list();
    if (mounted) setState(() => _recent = recent);
  }

  Future<void> _runSearch([String? overrideQuery]) async {
    final text = (overrideQuery ?? _queryController.text).trim();
    if (overrideQuery != null) {
      _queryController.text = text;
    }
    if (text.isEmpty) return;

    final child = ref.read(selectedChildProvider).valueOrNull;
    if (child == null) return;

    setState(() {
      _loading = true;
      _searched = true;
    });

    try {
      await ref.read(recentSearchesStoreProvider).add(text);
      final results = await ref.read(searchServiceProvider).search(
            SearchQuery(
              text: text,
              childId: child.id,
              type: _typeFilter,
              fromDate: _fromDate,
              toDate: _toDate,
            ),
          );
      final recent = await ref.read(recentSearchesStoreProvider).list();
      if (!mounted) return;
      setState(() {
        _results = results;
        _recent = recent;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).errorGeneric)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = MaterialLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.searchTitle)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: TextField(
              controller: _queryController,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: l10n.searchHint,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _queryController.text.isEmpty
                    ? null
                    : IconButton(
                        onPressed: () {
                          _queryController.clear();
                          setState(() {
                            _results = const [];
                            _searched = false;
                          });
                        },
                        icon: const Icon(Icons.clear),
                      ),
              ),
              onChanged: (_) => setState(() {}),
              onSubmitted: (_) => _runSearch(),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(l10n.searchFilterAll),
                    selected: _typeFilter == null,
                    onSelected: (_) {
                      setState(() => _typeFilter = null);
                      if (_searched) _runSearch();
                    },
                  ),
                ),
                for (final type in SearchResultType.values)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(searchTypeLabel(l10n, type)),
                      selected: _typeFilter == type,
                      onSelected: (_) {
                        setState(() => _typeFilter = type);
                        if (_searched) _runSearch();
                      },
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
            child: Row(
              children: [
                Expanded(
                  child: ListTile(
                    dense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                    title: Text(l10n.searchFromDate),
                    subtitle: Text(
                      _fromDate == null
                          ? l10n.commonNone
                          : locale.formatMediumDate(_fromDate!),
                    ),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _fromDate ?? DateTime.now(),
                        firstDate: DateTime(1980),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) {
                        setState(() => _fromDate = picked);
                        if (_searched) _runSearch();
                      }
                    },
                  ),
                ),
                Expanded(
                  child: ListTile(
                    dense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                    title: Text(l10n.searchToDate),
                    subtitle: Text(
                      _toDate == null
                          ? l10n.commonNone
                          : locale.formatMediumDate(_toDate!),
                    ),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _toDate ?? DateTime.now(),
                        firstDate: _fromDate ?? DateTime(1980),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) {
                        setState(() => _toDate = picked);
                        if (_searched) _runSearch();
                      }
                    },
                  ),
                ),
                if (_fromDate != null || _toDate != null)
                  IconButton(
                    tooltip: l10n.searchClearDates,
                    onPressed: () {
                      setState(() {
                        _fromDate = null;
                        _toDate = null;
                      });
                      if (_searched) _runSearch();
                    },
                    icon: const Icon(Icons.event_busy_outlined),
                  ),
              ],
            ),
          ),
          if (_recent.isNotEmpty && !_searched) ...[
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                child: Text(
                  l10n.searchRecent,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  for (final q in _recent)
                    ActionChip(
                      label: Text(q),
                      onPressed: () => _runSearch(q),
                    ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 8),
          Expanded(child: _buildResults(l10n, locale)),
        ],
      ),
    );
  }

  Widget _buildResults(
    AppLocalizations l10n,
    MaterialLocalizations locale,
  ) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (!_searched) {
      return const SizedBox.shrink();
    }
    if (_results.isEmpty) {
      return AppStateViews.empty(
        icon: Icons.search_off_outlined,
        title: l10n.stateNoSearchResults,
        subtitle: l10n.searchEmpty,
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      itemCount: _results.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final item = _results[index];
        return Card(
          child: ListTile(
            leading: Icon(searchTypeIcon(item.type)),
            title: Text(item.title),
            subtitle: Text(
              [
                searchTypeLabel(l10n, item.type),
                if (item.subtitle != null && item.subtitle!.isNotEmpty)
                  item.subtitle!,
                locale.formatMediumDate(item.eventDate),
                if (item.snippet != null && item.snippet!.trim().isNotEmpty)
                  item.snippet!,
              ].join(' · '),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => openSearchResult(context, item),
          ),
        );
      },
    );
  }
}
