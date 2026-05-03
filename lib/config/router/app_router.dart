import 'package:flu_avm/presentation/screens/bands/bands_screen.dart';
import 'package:flu_avm/presentation/screens/domus/domus_screen.dart';
import 'package:flu_avm/presentation/screens/numerator/numerator_screen.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: '/', 
  routes: [
    GoRoute(
      path: '/' ,
      builder: (context, state) => const DomusScreen(),
      ),
    GoRoute(
      path: '/numerator-river' ,
      builder: (context, state) => const NumeratorScreen(),
      ),
    GoRoute(
      path: '/bands' ,
      builder: (context, state) => const BandsScreen(),
      ),
    
    
  ] 

);