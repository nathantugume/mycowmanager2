import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mycowmanager/models/milk/milking_record.dart';
import 'package:provider/provider.dart';

import '../viewmodels/milk_view_model.dart';
import 'add_milk_record_sheet.dart';

class MilkScreen extends StatefulWidget{
  const MilkScreen({super.key});
  @override
  State<MilkScreen> createState() => _MilkScreenState();

}

class _MilkScreenState extends State<MilkScreen>{
  late final MilkViewModel _vm;
  
  @override
  void initState() {
    super.initState();
    _vm = MilkViewModel();
    // kick off the fetch once
    _vm.getAll(); // or fetchAll() if you renamed it
  }

  @override
  Widget build(BuildContext context) {
  return ChangeNotifierProvider.value(
    value: _vm,
    child: Scaffold(
      appBar: AppBar(title: const Text('Milk Records'),),
      body: Consumer<MilkViewModel>(builder: (BuildContext context, MilkViewModel value, Widget? child) { 
        if(value.error != null){
          return Center(child: Text('⚠️ ${value.error}'));
        }
        if(value.milkList.isEmpty){
          return const Center(child: CircularProgressIndicator());
        }
        
        // show list
        return ListView.builder(
            itemCount: _vm.milkList.length,
            itemBuilder: (ctx, i){
              final milk = _vm.milkList[i];
              return MilkCard(item: milk,
                  onTap: () {},
                  onMenuTap: () {},
              );
            }
        );
        
    },),
      floatingActionButton: FloatingActionButton.extended(
          label: const Text('Add Milk'),
          icon: const FaIcon(FontAwesomeIcons.plus),
          backgroundColor: Colors.blueAccent,
          onPressed: ()=> showModalBottomSheet(context: context,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (_)=> Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: const AddMilkRecordSheet(),

    )),
    )));
    
  }
}

class MilkCard extends StatelessWidget{
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
            Expanded(child:
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _text(context, 'Farm: ${item.farmName}',isBold:true),
                _text(context, 'Cow: ${item.cowName}'),
                _text(context, 'Date: ${item.date}'),
                _text(context, 'Morning : ${item.morning} | Afternoon : ${item.afternoon} | Evening : ${item.evening}'),
                _text(context, 'Notes: ${item.notes}'),
              ],
            ),
            ),
            IconButton(
              icon: const FaIcon(FontAwesomeIcons.ellipsisVertical),
              onPressed: onMenuTap,
            ),
          ]

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