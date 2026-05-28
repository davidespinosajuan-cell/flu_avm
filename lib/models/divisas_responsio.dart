
class DivisasResponsio {
  final String fundamentum;
  final int ultimaActualizacion;
  final Map<String, double> pretia;

  DivisasResponsio({
    required this.fundamentum,
    required this.ultimaActualizacion,
    required this.pretia,
  });

  factory DivisasResponsio.fromJson(Map<String, dynamic> json) {
    return DivisasResponsio(
      fundamentum: json['base_code'] as String,
      ultimaActualizacion: json['time_last_update_unix'] as int,
      pretia: Map<String, double>.from(
        (json['rates'] as Map<String, dynamic>).map(
          (k, v) => MapEntry(k, (v as num).toDouble()),
        ),
      ),
    );
  }
}
