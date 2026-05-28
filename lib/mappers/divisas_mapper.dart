
import 'package:flu_avm/config/entities/divisa.dart';
import 'package:flu_avm/models/divisas_responsio.dart';

class DivisasMapper {
  static Divisa divisasResponsioADivisa(DivisasResponsio resp) {
    final cop = resp.pretia['COP'] ?? 0;
    final eur = resp.pretia['EUR'] ?? 1;
    final mxn = resp.pretia['MXN'] ?? 1;

    final fecha = DateTime.fromMillisecondsSinceEpoch(
      resp.ultimaActualizacion * 1000,
    );
    final dies =
        '${fecha.year}-${fecha.month.toString().padLeft(2, '0')}-${fecha.day.toString().padLeft(2, '0')}';

    return Divisa(
      copPorUsd: cop,
      copPorEur: cop / eur,
      copPorMxn: cop / mxn,
      dies: dies,
    );
  }
}
