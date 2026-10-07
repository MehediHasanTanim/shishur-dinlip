import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shishur_dinlipi/core/di/core_providers.dart';
import 'package:shishur_dinlipi/core/domain/models/growth_record.dart';
import 'package:shishur_dinlipi/core/domain/unit_conversion.dart';
import 'package:shishur_dinlipi/core/errors/error_mapper.dart';
import 'package:shishur_dinlipi/core/settings/app_settings.dart';
import 'package:shishur_dinlipi/core/settings/settings_controller.dart';
import 'package:shishur_dinlipi/features/children/child_controller.dart';
import 'package:shishur_dinlipi/features/development/growth_providers.dart';
import 'package:shishur_dinlipi/features/memories/widgets/discard_guard.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';

class GrowthEditorScreen extends ConsumerStatefulWidget {
  const GrowthEditorScreen({super.key, this.recordId});

  final String? recordId;

  @override
  ConsumerState<GrowthEditorScreen> createState() => _GrowthEditorScreenState();
}

class _GrowthEditorScreenState extends ConsumerState<GrowthEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _height;
  late final TextEditingController _feet;
  late final TextEditingController _inches;
  late final TextEditingController _weight;
  late final TextEditingController _location;
  late final TextEditingController _notes;

  DateTime _measuredAt = DateTime.now();
  bool _dirty = false;
  bool _saving = false;
  bool _loading = true;
  String? _loadedId;
  DateTime? _createdAt;
  GrowthRecord? _previous;

  @override
  void initState() {
    super.initState();
    _height = TextEditingController()..addListener(_markDirty);
    _feet = TextEditingController()..addListener(_markDirty);
    _inches = TextEditingController()..addListener(_markDirty);
    _weight = TextEditingController()..addListener(_markDirty);
    _location = TextEditingController()..addListener(_markDirty);
    _notes = TextEditingController()..addListener(_markDirty);
    WidgetsBinding.instance.addPostFrameCallback((_) => _bootstrap());
  }

  void _markDirty() {
    if (!_dirty && mounted) setState(() => _dirty = true);
  }

  Future<void> _bootstrap() async {
    final child = ref.read(selectedChildProvider).valueOrNull;
    if (child != null) {
      _previous = await ref
          .read(growthRepositoryProvider)
          .latestForChild(child.id);
    }

    if (widget.recordId != null) {
      final record = await ref
          .read(growthRepositoryProvider)
          .getById(widget.recordId!);
      if (record != null && mounted) {
        _loadedId = record.id;
        _createdAt = record.createdAt;
        _measuredAt = record.measuredAt;
        _fillFromCanonical(record);
        _location.text = record.measurementLocation ?? '';
        _notes.text = record.notes ?? '';
        if (_previous?.id == record.id) {
          final history = await ref
              .read(growthRepositoryProvider)
              .historyForChild(record.childId);
          for (final item in history) {
            if (item.record.id == record.id) {
              _previous = item.previous;
              break;
            }
          }
        }
      }
    }

    if (mounted) {
      setState(() {
        _loading = false;
        _dirty = false;
      });
    }
  }

  void _fillFromCanonical(GrowthRecord record) {
    final settings = ref.read(settingsControllerProvider).valueOrNull;
    final heightUnit = settings?.heightUnit ?? HeightUnit.cm;
    final weightUnit = settings?.weightUnit ?? WeightUnit.kg;

    if (record.heightCm != null) {
      if (heightUnit == HeightUnit.cm) {
        _height.text = UnitConversion.roundDisplay(
          record.heightCm!,
        ).toStringAsFixed(1);
      } else {
        final fi = UnitConversion.cmToFeetInches(record.heightCm!);
        _feet.text = '${fi.feet}';
        _inches.text = fi.inches.toStringAsFixed(1);
      }
    }
    if (record.weightKg != null) {
      final value = weightUnit == WeightUnit.kg
          ? record.weightKg!
          : UnitConversion.kgToLb(record.weightKg!);
      _weight.text = UnitConversion.roundDisplay(value).toStringAsFixed(1);
    }
  }

  @override
  void dispose() {
    _height.dispose();
    _feet.dispose();
    _inches.dispose();
    _weight.dispose();
    _location.dispose();
    _notes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final settings = ref.watch(settingsControllerProvider).valueOrNull;
    final heightUnit = settings?.heightUnit ?? HeightUnit.cm;
    final weightUnit = settings?.weightUnit ?? WeightUnit.kg;
    final bangla = Localizations.localeOf(context).languageCode == 'bn';

    return PopScope(
      canPop: !_dirty,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final ok = await confirmDiscardIfDirty(context, isDirty: _dirty);
        if (ok && context.mounted) context.pop();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.recordId == null ? l10n.addGrowth : l10n.editGrowth,
          ),
          actions: [
            PopupMenuButton<String>(
              onSelected: (value) async {
                if (value == 'cm') {
                  await ref
                      .read(settingsControllerProvider.notifier)
                      .setHeightUnit(HeightUnit.cm);
                } else if (value == 'ft') {
                  await ref
                      .read(settingsControllerProvider.notifier)
                      .setHeightUnit(HeightUnit.ftIn);
                } else if (value == 'kg') {
                  await ref
                      .read(settingsControllerProvider.notifier)
                      .setWeightUnit(WeightUnit.kg);
                } else if (value == 'lb') {
                  await ref
                      .read(settingsControllerProvider.notifier)
                      .setWeightUnit(WeightUnit.lb);
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(value: 'cm', child: Text(l10n.unitCm)),
                PopupMenuItem(value: 'ft', child: Text(l10n.unitFtIn)),
                PopupMenuItem(value: 'kg', child: Text(l10n.unitKg)),
                PopupMenuItem(value: 'lb', child: Text(l10n.unitLb)),
              ],
            ),
          ],
        ),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                  children: [
                    if (_previous != null) ...[
                      Card(
                        color: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerHighest,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            l10n.growthPreviousContext(
                              UnitConversion.formatHeight(
                                heightCm: _previous!.heightCm,
                                unit: heightUnit,
                                bangla: bangla,
                              ),
                              UnitConversion.formatWeight(
                                weightKg: _previous!.weightKg,
                                unit: weightUnit,
                                bangla: bangla,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(l10n.memoryDate),
                      subtitle: Text(
                        MaterialLocalizations.of(
                          context,
                        ).formatFullDate(_measuredAt),
                      ),
                      trailing: const Icon(Icons.calendar_today_outlined),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _measuredAt,
                          firstDate: DateTime(1980),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) {
                          setState(() {
                            _measuredAt = picked;
                            _dirty = true;
                          });
                        }
                      },
                    ),
                    if (heightUnit == HeightUnit.cm)
                      TextFormField(
                        controller: _height,
                        decoration: InputDecoration(
                          labelText: l10n.growthHeightCm,
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'[0-9.]'),
                          ),
                        ],
                      )
                    else
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _feet,
                              decoration: InputDecoration(
                                labelText: l10n.growthHeightFt,
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: _inches,
                              decoration: InputDecoration(
                                labelText: l10n.growthHeightIn,
                              ),
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9.]'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _weight,
                      decoration: InputDecoration(
                        labelText: weightUnit == WeightUnit.kg
                            ? l10n.growthWeightKg
                            : l10n.growthWeightLb,
                      ),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _location,
                      decoration: InputDecoration(
                        labelText: l10n.memoryLocation,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _notes,
                      decoration: InputDecoration(labelText: l10n.childNotes),
                      minLines: 2,
                      maxLines: 5,
                    ),
                  ],
                ),
              ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: FilledButton(
              onPressed: _saving ? null : () => _save(heightUnit, weightUnit),
              child: Text(l10n.saveGrowth),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _save(HeightUnit heightUnit, WeightUnit weightUnit) async {
    final l10n = AppLocalizations.of(context);
    final child = ref.read(selectedChildProvider).valueOrNull;
    if (child == null) return;

    double? heightCm;
    if (heightUnit == HeightUnit.cm) {
      final raw = double.tryParse(_height.text.trim());
      if (raw != null) heightCm = raw;
    } else {
      final feet = int.tryParse(_feet.text.trim()) ?? 0;
      final inches = double.tryParse(_inches.text.trim()) ?? 0;
      if (feet > 0 || inches > 0) {
        heightCm = UnitConversion.feetInchesToCm(feet: feet, inches: inches);
      }
    }

    double? weightKg;
    final weightRaw = double.tryParse(_weight.text.trim());
    if (weightRaw != null) {
      weightKg = weightUnit == WeightUnit.kg
          ? weightRaw
          : UnitConversion.lbToKg(weightRaw);
    }

    if (heightCm == null && weightKg == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.growthNeedValue)),
      );
      return;
    }

    setState(() => _saving = true);
    try {
      final now = DateTime.now().toUtc();
      await ref.read(growthRepositoryProvider).save(
            GrowthRecord(
              id: _loadedId ?? '',
              childId: child.id,
              measuredAt: _measuredAt,
              heightCm: heightCm,
              weightKg: weightKg,
              measurementLocation: _location.text.trim().isEmpty
                  ? null
                  : _location.text.trim(),
              notes: _notes.text.trim().isEmpty ? null : _notes.text.trim(),
              createdAt: _createdAt ?? now,
              updatedAt: now,
            ),
          );
      ref.invalidate(growthHistoryProvider);
      ref.invalidate(latestGrowthProvider);
      ref.invalidate(growthChartProvider);
      if (mounted) {
        setState(() => _dirty = false);
        context.pop();
      }
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(ErrorMapper.localize(context, error))),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}
