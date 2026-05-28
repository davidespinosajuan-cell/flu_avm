
import 'package:dio/dio.dart';
import 'package:flu_avm/config/entities/divisa.dart';
import 'package:flu_avm/config/entities/historial_divisas.dart';
import 'package:flu_avm/mappers/divisas_mapper.dart';
import 'package:flu_avm/models/divisas_responsio.dart';

class DivisasService {
  static Future<(Divisa?, String)> obtenerDivisas() async {
    final dio = Dio();
    try {
      final respuesta = await dio.get('https://open.er-api.com/v6/latest/USD');
      final modelo = DivisasResponsio.fromJson(respuesta.data);
      final divisa = DivisasMapper.divisasResponsioADivisa(modelo);
      return (divisa, 'Datos obtenidos correctamente');
    } catch (e) {
      return (null, 'No se pudieron obtener las divisas');
    }
  }

  static Future<(HistorialDivisas?, String)> obtenerHistorial() async {
    final dio = Dio();
    final ahora = DateTime.now();

    // 15 puntos: cada 2 días durante los últimos 30 días
    final fechas = List.generate(
      15,
      (i) => ahora.subtract(Duration(days: 28 - i * 2)),
    );

    try {
      final futures = fechas.map<Future<Response<dynamic>?>>((fecha) async {
        try {
          final fechaStr = _fmtFecha(fecha);
          return await dio.get(
            'https://cdn.jsdelivr.net/npm/@fawazahmed0/currency-api@$fechaStr/v1/currencies/usd.min.json',
          );
        } catch (_) {
          return null;
        }
      }).toList();

      final respuestas = await Future.wait(futures);

      final puntosUsd = <PuntoHistorial>[];
      final puntosEur = <PuntoHistorial>[];
      final puntosMxn = <PuntoHistorial>[];

      for (int i = 0; i < respuestas.length; i++) {
        final resp = respuestas[i];
        if (resp == null) continue;
        try {
          final tasas = resp.data['usd'] as Map<String, dynamic>;
          final cop = (tasas['cop'] as num).toDouble();
          final eur = (tasas['eur'] as num).toDouble();
          final mxn = (tasas['mxn'] as num).toDouble();

          puntosUsd.add(PuntoHistorial(fecha: fechas[i], valor: cop));
          puntosEur.add(PuntoHistorial(fecha: fechas[i], valor: cop / eur));
          puntosMxn.add(PuntoHistorial(fecha: fechas[i], valor: cop / mxn));
        } catch (_) {
          continue;
        }
      }

      if (puntosUsd.length < 2) return (null, 'Sin datos históricos suficientes');

      return (HistorialDivisas(usd: puntosUsd, eur: puntosEur, mxn: puntosMxn), 'ok');
    } catch (e) {
      return (null, 'Error al obtener historial');
    }
  }

  static String _fmtFecha(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}
