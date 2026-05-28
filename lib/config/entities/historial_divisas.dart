
class PuntoHistorial {
  final DateTime fecha;
  final double valor;

  PuntoHistorial({required this.fecha, required this.valor});
}

class HistorialDivisas {
  final List<PuntoHistorial> usd;
  final List<PuntoHistorial> eur;
  final List<PuntoHistorial> mxn;

  HistorialDivisas({required this.usd, required this.eur, required this.mxn});
}
