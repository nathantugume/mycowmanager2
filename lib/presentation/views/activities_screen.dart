import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mycowmanager/presentation/viewmodels/activities_view_model.dart';
import 'package:mycowmanager/presentation/views/activity_form_controller.dart';
import 'package:provider/provider.dart';

import '../../models/activities/activity.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  late final ActivitiesViewModel _vm;
  String? _filterType;
  DateTime? _filterStartDate;
  DateTime? _filterEndDate;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _vm = ActivitiesViewModel();
    // fetch once
    _vm.getAll();
  }

  @override
  void dispose() {
    super.dispose();
    _vm.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _vm,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Farm Activities'),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: 'Refresh',
              onPressed: () async {
                setState(() {
                  _isRefreshing = true;
                  _filterType = null;
                  _filterStartDate = null;
                  _filterEndDate = null;
                });
                await _vm.getAll();
                if (mounted) setState(() => _isRefreshing = false);
              },
            ),
            IconButton(
              icon: const Icon(Icons.filter_list),
              tooltip: 'Filter',
              onPressed: () async {
                final result = await showModalBottomSheet<Map<String, dynamic>>(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  builder: (ctx) {
                    String? selectedType;
                    DateTime? startDate;
                    DateTime? endDate;
                    return StatefulBuilder(
                      builder: (context, setModalState) {
                        return Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              DropdownButtonFormField<String>(
                                decoration: const InputDecoration(
                                  labelText: 'Activity Type',
                                  border: OutlineInputBorder(),
                                ),
                                value: selectedType,
                                items:
                                    [
                                          'All',
                                          'Disease',
                                          'Vaccination',
                                          'Weighing',
                                          'Breeding',
                                        ]
                                        .map(
                                          (type) => DropdownMenuItem(
                                            value: type == 'All' ? null : type,
                                            child: Text(type),
                                          ),
                                        )
                                        .toList(),
                                onChanged: (val) =>
                                    setModalState(() => selectedType = val),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      (startDate == null || endDate == null)
                                          ? 'Range: Not selected'
                                          : 'Range: ${startDate!.toLocal().toString().split(' ')[0]} - ${endDate!.toLocal().toString().split(' ')[0]}',
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      final picked = await showDateRangePicker(
                                        context: context,
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime.now(),
                                        initialDateRange:
                                            (startDate != null &&
                                                endDate != null)
                                            ? DateTimeRange(
                                                start: startDate!,
                                                end: endDate!,
                                              )
                                            : null,
                                      );
                                      if (picked != null) {
                                        setModalState(() {
                                          startDate = picked.start;
                                          endDate = picked.end;
                                        });
                                      }
                                    },
                                    child: const Text('Select Range'),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx),
                                    child: const Text('Cancel'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(ctx, {
                                        'type': selectedType,
                                        'startDate': startDate,
                                        'endDate': endDate,
                                      });
                                    },
                                    child: const Text('Apply'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
                if (result != null) {
                  setState(() {
                    _filterType = result['type'];
                    _filterStartDate = result['startDate'];
                    _filterEndDate = result['endDate'];
                  });
                }
              },
            ),
          ],
        ),
        body: Stack(
          children: [
            Consumer<ActivitiesViewModel>(
              builder: (context, vm, _) {
                // handle error
                if (vm.error != null) {
                  return Center(child: Text('⚠️ ${vm.error}'));
                }
                // loading indicator
                if (vm.activityList.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                // show list

                final filteredList = vm.activityList.where((activity) {
                  final matchesType =
                      _filterType == null || activity.type == _filterType;
                  final activityDate = DateTime.tryParse(activity.date);
                  final matchesStart =
                      _filterStartDate == null ||
                      (activityDate != null &&
                          !activityDate.isBefore(_filterStartDate!));
                  final matchesEnd =
                      _filterEndDate == null ||
                      (activityDate != null &&
                          !activityDate.isAfter(_filterEndDate!));
                  return matchesType && matchesStart && matchesEnd;
                }).toList();

                return ListView.builder(
                  itemCount: filteredList.length,
                  itemBuilder: (ctx, i) {
                    final activity = filteredList[i];
                    return ActivityCard(
                      item: activity,
                      onTap: () {
                        // for example: Navigator.push(...)
                      },
                      onMenuTap: () async {
                        final option = await showModalBottomSheet<String>(
                          context: context,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(16),
                            ),
                          ),
                          builder: (_) => Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                leading: const Icon(Icons.edit),
                                title: const Text('Edit'),
                                onTap: () => Navigator.pop(context, 'edit'),
                              ),
                              ListTile(
                                leading: const Icon(Icons.delete),
                                title: const Text('Delete'),
                                onTap: () => Navigator.pop(context, 'delete'),
                              ),
                            ],
                          ),
                        );
                        if (!context.mounted) return;
                        if (option == 'edit') {
                          await showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20),
                              ),
                            ),
                            builder: (_) => Padding(
                              padding: EdgeInsets.only(
                                bottom: MediaQuery.of(
                                  context,
                                ).viewInsets.bottom,
                              ),
                              child: ActivityFormController(
                                existingActivity: activity,
                              ),
                            ),
                          );
                          if (!context.mounted) return;
                          _vm.getAll();
                        } else if (option == 'delete') {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Delete Activity'),
                              content: Text(
                                'Are you sure you want to delete this activity?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx, false),
                                  child: const Text('Cancel'),
                                ),
                                ElevatedButton(
                                  onPressed: () => Navigator.pop(ctx, true),
                                  child: const Text('Delete'),
                                ),
                              ],
                            ),
                          );
                          if (confirm == true) {
                            await context.read<ActivitiesViewModel>().delete(
                              activity.id,
                            );
                            if (!context.mounted) return;
                            _vm.getAll();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Activity deleted')),
                            );
                          }
                        }
                      },
                    );
                  },
                );
              },
            ),
            if (_isRefreshing)
              Container(
                color: Colors.black.withOpacity(0.2),
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          label: const Text('Add Activity'),
          icon: const FaIcon(FontAwesomeIcons.plus),
          backgroundColor: Colors.blueAccent,
          onPressed: () => showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (_) => Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: const ActivityFormController(),
            ),
          ),
        ),
      ),
    );
  }
}

class ActivityCard extends StatelessWidget {
  final Activity item;
  final VoidCallback? onTap;
  final VoidCallback? onMenuTap;

  const ActivityCard({
    super.key,
    required this.item,
    this.onTap,
    this.onMenuTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 4,
              color: Colors.black12,
              offset: Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _fieldsFor(item, context),
              ),
            ),
            IconButton(icon: const Icon(Icons.more_vert), onPressed: onMenuTap),
          ],
        ),
      ),
    );
  }
}

Text _text(BuildContext ctx, String value, {bool isBold = false}) {
  return Text(
    value,
    style: Theme.of(ctx).textTheme.bodyMedium?.copyWith(
      fontWeight: isBold ? FontWeight.bold : FontWeight.w300,
    ),
  );
}

/// Re‑uses your existing `_text()` builder but skips empty content.
Widget _info(
  BuildContext ctx, {
  required String label,
  String? value,
  bool isBold = false,
}) {
  if (value == null || value.trim().isEmpty) return const SizedBox.shrink();
  return _text(ctx, '$label: $value', isBold: isBold);
}

/// Same for lists →  “a, b, c”
Widget _infoList(
  BuildContext ctx, {
  required String label,
  List<String>? values,
}) {
  if (values == null || values.isEmpty) return const SizedBox.shrink();
  return _text(ctx, '$label: ${values.join(", ")}');
}

List<Widget> _fieldsFor(Activity item, BuildContext ctx) {
  final w = <Widget>[];

  // Always show the headline type
  w.add(_text(ctx, item.type, isBold: true));

  // Common fields
  w
    ..add(_info(ctx, label: 'Date', value: item.date))
    ..add(_info(ctx, label: 'Cattle', value: '${item.cattleName} '))
    ..add(_info(ctx, label: 'Performed by', value: item.performedBy));

  switch (item.type) {
    case 'Vaccination':
      w
        ..add(_info(ctx, label: 'Vaccine', value: item.vaccineName))
        ..add(_info(ctx, label: 'Dose', value: item.vaccineDose));
      break;

    case 'Breeding':
      w
        ..add(_info(ctx, label: 'Breeding type', value: item.breedingType))
        ..add(_info(ctx, label: 'Sire tag', value: item.sireTag))
        ..add(_info(ctx, label: 'Next check‑up', value: item.nextCheckupDate));
      break;

    case 'Disease':
      w
        ..add(_info(ctx, label: 'Diagnosis', value: item.diagnosis))
        ..add(_infoList(ctx, label: 'Symptoms', values: item.symptoms))
        ..add(_infoList(ctx, label: 'Medications', values: item.medications))
        ..add(_info(ctx, label: 'Treatment', value: item.treatmentMethod))
        ..add(_info(ctx, label: 'Recovery status', value: item.recoveryStatus));
      break;

    default: // fallback for any other record
      w
        ..add(_info(ctx, label: 'Notes', value: item.notes))
        ..add(_info(ctx, label: 'Treatment', value: item.treatmentMethod));
  }

  return w;
}
