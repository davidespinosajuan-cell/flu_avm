
import 'package:flu_avm/config/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'presentation/providers/providers.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MainApp(),
    )
  );
}

class MainApp extends ConsumerWidget{
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) { 

    final tenebrisModusEst = ref.watch(estTenebrisModusProvider);

    return MaterialApp.router(
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      theme: AppTheme(
        tenebristModusEts : tenebrisModusEst).getTheme(),
      );
  }
}
