import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mycowmanager/presentation/viewmodels/activities_view_model.dart';
import 'package:mycowmanager/presentation/views/activity_form_controller.dart';
import 'package:provider/provider.dart';

import '../../models/activities/activity.dart';

class ActivityScreen extends StatefulWidget{
  const ActivityScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen>{
  late final ActivitiesViewModel _vm;

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
    return ChangeNotifierProvider.value(value: _vm,
    child: Scaffold(
      appBar: AppBar(title: const Text('Farm Activities'),),
      body: Consumer<ActivitiesViewModel>(
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

          return ListView.builder(
            itemCount: vm.activityList.length,
            itemBuilder: (ctx, i) {
              final activity = vm.activityList[i];
              return ActivityCard(
                item: activity,
                onTap: () {
                  // for example: Navigator.push(...)
                },
                onMenuTap: () {
                  // open bottom‑sheet / popup menu
                },
              );
            },
          );

        }
        ),
      floatingActionButton: FloatingActionButton.extended(
          label: const Text('Add Activity'),
          icon: const FaIcon(FontAwesomeIcons.plus),
          backgroundColor: Colors.blueAccent,
          onPressed: ()=>showModalBottomSheet(
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
          )),
      ),

    );

  }

}

class ActivityCard extends StatelessWidget{
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
    ],),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(child:
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _fieldsFor(item, context),

            )),
          ]
        )

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
  w..add(_info(ctx, label: 'Date', value: item.date))
    ..add(_info(ctx, label: 'Cattle', value: item.cattleName))
    ..add(_info(ctx, label: 'Farm', value: item.farmName))
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
