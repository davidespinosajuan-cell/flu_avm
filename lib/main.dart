import 'package:flu_avm/config/config.dart';
import 'package:flu_avm/presentation/providers/modus_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MainApp(),
    ) 
  );
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tenebristModusEst = ref.watch(estTenebrisModusProvider);

    return MaterialApp.router(
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      theme: AppTheme(
        tenebristModusEts: tenebristModusEst,
        electusColor: Colors.pink.shade900
        ).getTheme(),
         ); 
  }
}
