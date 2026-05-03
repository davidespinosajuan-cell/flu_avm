import 'package:flu_avm/config/config.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:go_router/go_router.dart';

class DomusScreen extends StatelessWidget {
  const DomusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flu Avm App'),
      ),
      body: _DomusView(),

    );
  }
}

class _DomusView extends StatelessWidget {
  const _DomusView();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: appMenuItem.length,
      itemBuilder:(context, index) {
        final menuItem = appMenuItem[index];
        return _PropriumListTile( menuItem: menuItem );
      }, 
    );
  }
}

class _PropriumListTile extends StatelessWidget {
  final MenuItem menuItem;
  const _PropriumListTile({
    required this.menuItem
  });

  @override
  Widget build(BuildContext context) {
    final colorum = Theme.of(context).colorScheme;

    return ListTile(
      title: Text(menuItem.titulus), //Ya se hizo ajuste
      subtitle: Text(menuItem.subtitulus),
      trailing: Icon(Icons.arrow_forward_rounded, color: colorum.primary,),
      leading: CircleAvatar(
        backgroundColor: Color.fromARGB(
          100, 
          math.Random().nextInt(256), 
          math.Random().nextInt(256), 
          math.Random().nextInt(256)
          ),
        child: Icon(Icons.add, color: Colors.black,),
        ),
        onTap: () {
          context.push(menuItem.link);
        },
    );
  }
}