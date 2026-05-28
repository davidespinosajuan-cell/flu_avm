
import 'package:flu_avm/config/entities/divisa.dart';
import 'package:flu_avm/config/entities/historial_divisas.dart';
import 'package:flu_avm/services/divisas_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final divisasProvider = StreamProvider<Divisa>((ref) async* {
  final (divisa, error) = await DivisasService.obtenerDivisas();
  if (divisa != null) {
    yield divisa;
  } else {
    throw Exception(error);
  }

  await for (final _ in Stream.periodic(const Duration(seconds: 30))) {
    final (divisaActual, errorActual) = await DivisasService.obtenerDivisas();
    if (divisaActual != null) {
      yield divisaActual;
    } else {
      throw Exception(errorActual);
    }
  }
});

final historialDivisasProvider = FutureProvider<HistorialDivisas>((ref) async {
  final (historial, error) = await DivisasService.obtenerHistorial();
  if (historial != null) return historial;
  throw Exception(error);
});
