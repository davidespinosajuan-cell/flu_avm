import 'package:flu_avm/presentation/providers/providers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flu_avm/config/config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pie_chart/pie_chart.dart';



class BandsScreen extends ConsumerWidget {
  const BandsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final bandsState = ref.watch(bandsProvider);

    final serverStatus = ref.watch(bandsProvider).serverStatus;
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Bandas'),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: (serverStatus == ServerStatus.Online) 
              ? Icon(Icons.check_circle, color: Colors.blue[300])
              : Icon(Icons.offline_bolt, color: Colors.red[600]),
          )
        ]
      ),

      body: Column(
        children: [
          _videreData(bandsState.bands, bandsState.serverStatus),
          const SizedBox(height: 20),

          Expanded(
            child: ListView.builder(
              itemCount: bandsState.bands.length,
              itemBuilder: (context, i) {
                return _bandTile(context, ref, bandsState.bands[i]);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Visibility(
        visible: bandsState.bands.length < 7 ? true : false,
        child: FloatingActionButton(
          onPressed: () => addereNovumBand(context, ref),
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _videreData(List<Band> bands, ServerStatus status) {

    if (status == ServerStatus.Connecting) {
      return const LinearProgressIndicator();
    }

    if (status == ServerStatus.Offline) {
      return const SizedBox(
        height: 50,
        child: Center(child: Text('Sin conexión al servidor')),
      );
    }

    // ignore: prefer_collection_literals
    Map<String, double> dataMap = Map();

    for (var band in bands) {
      dataMap.putIfAbsent(band.nomen, () => band.numerusVotum.toDouble());
    }

    if (dataMap.isEmpty) {
      return const SizedBox(
        height: 50,
        child: Center(child: Text('No hay bandas aún')),
      );
    }

    final List<Color> colorList = [
      Colors.pink.shade100,
      Colors.pink.shade300,
      Colors.blue.shade200,
      Colors.blue.shade600,
      Colors.lightGreen.shade200,
      Colors.lightGreen.shade600,
    ];

    return Container(
      padding: const EdgeInsets.only(left: 5, top: 5),
      width: double.infinity,
      height: 200.0,
      child: PieChart(
        dataMap: dataMap,
        animationDuration: const Duration(milliseconds: 800),
        colorList: colorList,
        chartType: ChartType.ring,
        legendOptions: const LegendOptions(
          showLegendsInRow: false,
          legendPosition: LegendPosition.right,
          showLegends: true,
          legendTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: "CupertinoSystemText",
            fontSize: 17,
          ),
        ),
        chartValuesOptions: ChartValuesOptions(
          showChartValues: dataMap.length <= 6,
          showChartValueBackground: true,
          showChartValuesInPercentage: false,
          showChartValuesOutside: false,
        ),
      ),
    );
  }

  Widget _bandTile(BuildContext context, WidgetRef ref, Band band) {
    return Dismissible(
      key: Key(band.id),
       direction: DismissDirection.startToEnd,
       onDismissed: (direction) {
        ref.read(bandsProvider.notifier).delereBand(band.id);
       },
       background: Container(
        padding: EdgeInsets.only(left: 8.0),
        color: Colors.red,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text('Delete Band', style: TextStyle(color: Colors.white)),
        ),
       ),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(band.nomen.substring(0, 2).toUpperCase()),
        ),
        title: Text(band.nomen),
        trailing: Text(
          '${band.numerusVotum}',
          style: TextStyle(fontSize: 20),
        ),
        onTap: () {
          ref.read(bandsProvider.notifier).addereVotum(band.id);
        },
      ),
    );
  }

  addereNovumBand(BuildContext context, WidgetRef ref) {

    final TextEditingController textumController = TextEditingController();
/*
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('New band name'),
          content: TextField(
            controller: textumController,
            decoration: InputDecoration(
              hintText: 'Band name',
            ),
          ),
          actions: [
            MaterialButton(
              onPressed: () {
                addereBandaAdCollection(context, textumController.text);
              
              },
              textColor: Colors.blue,
              child: Text('Add'),
            ),
          ],
        );
      },
    ); */

showCupertinoDialog(
  context: context, 
  builder: ( BuildContext context ) => CupertinoAlertDialog(
    title: const Text('New band name'),
    content:  CupertinoTextField(
      controller: textumController,
      style: TextStyle(
        color: Theme.of(context).brightness == Brightness.dark 
          ? Colors.white 
          : Colors.black
        )
      ),
      actions: [
        CupertinoDialogAction(
          isDefaultAction: true,
          child: const Text('Add'),
          onPressed: () {
           /* addereBandaAdCollection(context, ref, textumController.text); */
           ref.read(bandsProvider.notifier).addereBand(textumController.text);
           context.pop();

          }
        ),
        CupertinoDialogAction(
          isDestructiveAction: true,
          child: const Text('Close'),
          onPressed: () => context.pop()
        ),
      ],
   )
);
  }

  /* void addereBandaAdCollection(BuildContext context, WidgetRef ref, String nomen) {
   
   if (nomen.length > 1) {
    ref.read(bandsProvider.notifier).addereBand(
      Band(
        id: DateTime.now().toString(), 
        nomen: nomen, 
        numerusVotum: 0
        ));             
   }

  } */

}