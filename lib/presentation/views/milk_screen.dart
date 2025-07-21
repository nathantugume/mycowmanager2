import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mycowmanager/models/milk/milking_record.dart';
import 'package:provider/provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../viewmodels/milk_view_model.dart';
import 'add_milk_record_sheet.dart';
import '../viewmodels/cattle_group_view_model.dart';
import '../viewmodels/farm_view_model.dart';

class MilkScreen extends StatefulWidget {
  const MilkScreen({super.key});
  @override
  State<MilkScreen> createState() => _MilkScreenState();
}

class _MilkScreenState extends State<MilkScreen> {
  late final MilkViewModel _vm;
  late final CattleGroupViewModel _groupVm;
  String? _filterCowName;
  String? _filterCowTag;
  String? _filterGroup;
  DateTime? _filterStartDate;
  DateTime? _filterEndDate;
  bool _isRefreshing = false;
  bool _isExporting = false;
  bool _groupsLoaded = false;

  @override
  void initState() {
    super.initState();
    _vm = MilkViewModel();
    _groupVm = CattleGroupViewModel();
    _vm.getAll();
    // Fetch groups for current farm
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final farm = context.read<CurrentFarm>().farm;
      if (farm != null) {
        _groupVm.getByFarmId(farm.id);
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_groupsLoaded) {
      final farm = context.read<CurrentFarm>().farm;
      if (farm != null) {
        debugPrint('Loading cattle groups for farm: ${farm.id} (${farm.name})');
        _groupVm.getByFarmId(farm.id).then((_) {
          debugPrint(
            'Loaded groups: ${_groupVm.cattleList.map((g) => g.name).toList()}',
          );
        });
        _groupsLoaded = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _vm),
        ChangeNotifierProvider.value(value: _groupVm),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Milk Records'),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: 'Refresh',
              onPressed: () async {
                setState(() {
                  _isRefreshing = true;
                  _filterCowName = null;
                  _filterCowTag = null;
                  _filterGroup = null;
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
                final groupVm = context.read<CattleGroupViewModel>();
                if (groupVm.isLoading) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please wait, loading groups...'),
                    ),
                  );
                  return;
                }
                if (groupVm.cattleList.isEmpty) {
                  final farm = context.read<CurrentFarm>().farm;
                  if (farm != null) {
                    await groupVm.getByFarmId(farm.id);
                    if (groupVm.cattleList.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('No groups found for this farm.'),
                        ),
                      );
                      return;
                    }
                  }
                }
                final milkList = _vm.milkList;
                final uniqueCows = <String, String>{}; // cowId -> cowName
                for (final m in milkList) {
                  if ((m.cowId ?? '').isNotEmpty) {
                    uniqueCows[m.cowId!] = m.cowName ?? '';
                  }
                }
                final cowIdList = uniqueCows.keys.toList();

                String? selectedCowId = _filterCowTag;
                String? selectedGroup = _filterGroup;
                DateTime? startDate = _filterStartDate;
                DateTime? endDate = _filterEndDate;
                await showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  builder: (ctx) {
                    return Consumer<CattleGroupViewModel>(
                      builder: (context, groupVm, _) {
                        final groups = groupVm.cattleList
                            .map((g) => g.name)
                            .toList();

                        if (groupVm.isLoading) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        return StatefulBuilder(
                          builder: (context, setModalState) {
                            return Padding(
                              padding: const EdgeInsets.all(16),
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    DropdownButtonFormField<String?>(
                                      decoration: const InputDecoration(
                                        labelText: 'Cow',
                                        border: OutlineInputBorder(),
                                      ),
                                      value: selectedCowId,
                                      items:
                                          [
                                            const DropdownMenuItem<String?>(
                                              value: null,
                                              child: Text('All'),
                                            ),
                                          ] +
                                          cowIdList
                                              .map(
                                                (
                                                  id,
                                                ) => DropdownMenuItem<String?>(
                                                  value: id,
                                                  child: Text(
                                                    '${uniqueCows[id]} - $id',
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                      onChanged: (val) => setModalState(
                                        () => selectedCowId = val,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    DropdownButtonFormField<String?>(
                                      decoration: const InputDecoration(
                                        labelText: 'Group',
                                        border: OutlineInputBorder(),
                                      ),
                                      value: selectedGroup,
                                      items:
                                          [
                                            const DropdownMenuItem<String?>(
                                              value: null,
                                              child: Text('All'),
                                            ),
                                          ] +
                                          groupVm.cattleList
                                              .map(
                                                (g) =>
                                                    DropdownMenuItem<String?>(
                                                      value: g.id,
                                                      child: Text(g.name),
                                                    ),
                                              )
                                              .toList(),
                                      onChanged: (val) => setModalState(
                                        () => selectedGroup = val,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            (startDate == null ||
                                                    endDate == null)
                                                ? 'Range: Not selected'
                                                : 'Range: ${startDate!.toLocal().toString().split(' ')[0]} - ${endDate!.toLocal().toString().split(' ')[0]}',
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            final picked =
                                                await showDateRangePicker(
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
                                    const SizedBox(height: 20),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(ctx);
                                          },
                                          child: const Text('Cancel'),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            setState(() {
                                              _filterCowName =
                                                  null; // No longer filtering by cowName
                                              _filterCowTag = selectedCowId;
                                              _filterGroup = selectedGroup;
                                              _filterStartDate = startDate;
                                              _filterEndDate = endDate;
                                            });
                                            Navigator.pop(ctx);
                                          },
                                          child: const Text('Apply'),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.picture_as_pdf),
              tooltip: 'Export to PDF',
              onPressed: () async {
                setState(() => _isExporting = true);
                final filteredList = _vm.milkList.where((milk) {
                  final matchesCow =
                      _filterCowTag == null || milk.cowId == _filterCowTag;
                  final matchesGroup =
                      _filterGroup == null ||
                      ((milk.cattleGroupId ?? '').trim().toLowerCase() ==
                          _filterGroup!.trim().toLowerCase());
                  final milkDate = DateTime.tryParse(milk.date);
                  final matchesStart =
                      _filterStartDate == null ||
                      (milkDate != null &&
                          !milkDate.isBefore(_filterStartDate!));
                  final matchesEnd =
                      _filterEndDate == null ||
                      (milkDate != null && !milkDate.isAfter(_filterEndDate!));
                  return matchesCow &&
                      matchesGroup &&
                      matchesStart &&
                      matchesEnd;
                }).toList();
                final pdf = pw.Document();
                pdf.addPage(
                  pw.Page(
                    build: (pw.Context context) {
                      return pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            'Milk Records',
                            style: pw.TextStyle(
                              fontSize: 24,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                          pw.SizedBox(height: 16),
                          pw.Table.fromTextArray(
                            headers: [
                              'Cow',
                              'Tag',
                              'Group',
                              'Date',
                              'Morning',
                              'Noon',
                              'Evening',
                              'Total',
                            ],
                            data: filteredList
                                .map(
                                  (m) => [
                                    m.cowName ?? '',
                                    m.cowId ?? '',
                                    m.cattleGroupName ?? '',
                                    m.date,
                                    m.morning.toStringAsFixed(2),
                                    m.afternoon.toStringAsFixed(2),
                                    m.evening.toStringAsFixed(2),
                                    m.total.toStringAsFixed(2),
                                  ],
                                )
                                .toList(),
                          ),
                        ],
                      );
                    },
                  ),
                );
                await Printing.layoutPdf(
                  onLayout: (format) async => pdf.save(),
                );
                if (mounted) setState(() => _isExporting = false);
              },
            ),
          ],
        ),
        body: Stack(
          children: [
            Consumer<MilkViewModel>(
              builder:
                  (BuildContext context, MilkViewModel value, Widget? child) {
                    if (value.error != null) {
                      return Center(child: Text('⚠️ ${value.error}'));
                    }
                    if (value.milkList.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final filteredList = value.milkList.where((milk) {
                      final matchesCow =
                          _filterCowTag == null || milk.cowId == _filterCowTag;
                      final matchesGroup =
                          _filterGroup == null ||
                          ((milk.cattleGroupId ?? '').trim().toLowerCase() ==
                              _filterGroup!.trim().toLowerCase());
                      final milkDate = DateTime.tryParse(milk.date);
                      final matchesStart =
                          _filterStartDate == null ||
                          (milkDate != null &&
                              !milkDate.isBefore(_filterStartDate!));
                      final matchesEnd =
                          _filterEndDate == null ||
                          (milkDate != null &&
                              !milkDate.isAfter(_filterEndDate!));
                      return matchesCow &&
                          matchesGroup &&
                          matchesStart &&
                          matchesEnd;
                    }).toList();
                    return ListView.builder(
                      itemCount: filteredList.length,
                      itemBuilder: (ctx, i) {
                        final milk = filteredList[i];
                        return MilkCard(
                          item: milk,
                          onTap: () {},
                          onMenuTap: () => _showMilkOptions(context, milk),
                        );
                      },
                    );
                  },
            ),
            if (_isRefreshing || _isExporting)
              Container(
                color: Colors.black.withOpacity(0.2),
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          label: const Text('Add Milk'),
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
              child: const AddMilkRecordSheet(),
            ),
          ),
        ),
      ),
    );
  }

  void _showMilkOptions(BuildContext context, MilkingRecord record) async {
    final result = await showModalBottomSheet<String>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit'),
              onTap: () => Navigator.pop(ctx, 'edit'),
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Delete'),
              onTap: () => Navigator.pop(ctx, 'delete'),
            ),
          ],
        ),
      ),
    );
    if (result == 'edit') {
      await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (_) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: AddMilkRecordSheet(initialRecord: record),
        ),
      );
      if (!mounted) return;
      _vm.getAll();
    } else if (result == 'delete') {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Delete Record'),
          content: const Text('Are you sure you want to delete this record?'),
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
        await context.read<MilkViewModel>().delete(record.id ?? '');
        if (!mounted) return;
        _vm.getAll();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Record deleted')));
      }
    }
  }
}

class MilkCard extends StatelessWidget {
  final MilkingRecord item;
  final VoidCallback? onTap;
  final VoidCallback? onMenuTap;
  const MilkCard({super.key, required this.item, this.onTap, this.onMenuTap});

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
                children: [
                  //   _text(context, 'Farm: ${item.farmName}',isBold:true),
                  _text(context, 'Cow: ${item.cowName} - Tag-${item.cowId}'),
                  _text(context, 'Date: ${item.date}'),
                  _text(
                    context,
                    'Morning : ${item.morning} | Noon : ${item.afternoon} | Evening : ${item.evening}',
                  ),
                  _text(context, 'Total: ${item.total}'),
                ],
              ),
            ),
            IconButton(
              icon: const FaIcon(FontAwesomeIcons.ellipsisVertical),
              onPressed: onMenuTap,
            ),
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
