
import 'package:fl_chart/fl_chart.dart';
import 'package:flu_avm/config/entities/divisa.dart';
import 'package:flu_avm/config/entities/historial_divisas.dart';
import 'package:flu_avm/presentation/providers/divisas_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class CambioDivisasScreen extends StatelessWidget {
  const CambioDivisasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: _DivisasVisum(),
    );
  }
}

class _DivisasVisum extends ConsumerStatefulWidget {
  const _DivisasVisum();

  @override
  ConsumerState<_DivisasVisum> createState() => _DivisasVisumState();
}

class _DivisasVisumState extends ConsumerState<_DivisasVisum> {
  final _controller = TextEditingController(text: '100000');
  double _copAmount = 100000;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final divisasAsync = ref.watch(divisasProvider);

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          floating: true,
          title: const Text('Cambio de Divisas'),
          backgroundColor:
              Theme.of(context).secondaryHeaderColor.withValues(alpha: 0.5),
          actions: [
            divisasAsync.when(
              data: (_) => const Padding(
                padding: EdgeInsets.only(right: 12),
                child: _IndicadorEnVivo(),
              ),
              loading: () => const Padding(
                padding: EdgeInsets.only(right: 12),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
              error: (e, st) => const SizedBox.shrink(),
            ),
          ],
        ),
        SliverToBoxAdapter(
          child: _CopInputField(
            controller: _controller,
            onChanged: (raw) {
              setState(() {
                _copAmount = double.tryParse(raw) ?? 0;
              });
            },
          ),
        ),
        divisasAsync.when(
          data: (divisa) => SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _TarjetaDivisa(
                  moneda: 'Dólar',
                  simbolo: 'USD',
                  bandera: '🇺🇸',
                  copPorUnidad: divisa.copPorUsd,
                  copAmount: _copAmount,
                  colorInicial: const Color(0xFF3949AB),
                ),
                const SizedBox(height: 16),
                _TarjetaDivisa(
                  moneda: 'Euro',
                  simbolo: 'EUR',
                  bandera: '🇪🇺',
                  copPorUnidad: divisa.copPorEur,
                  copAmount: _copAmount,
                  colorInicial: const Color(0xFF43A047),
                ),
                const SizedBox(height: 16),
                _TarjetaDivisa(
                  moneda: 'Peso Mexicano',
                  simbolo: 'MXN',
                  bandera: '🇲🇽',
                  copPorUnidad: divisa.copPorMxn,
                  copAmount: _copAmount,
                  colorInicial: const Color(0xFFE91E8C),
                ),
                const SizedBox(height: 24),
                _PieUltimaDivisa(divisa: divisa),
              ]),
            ),
          ),
          loading: () => const SliverFillRemaining(
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (error, st) => SliverFillRemaining(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.wifi_off_rounded,
                      size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    'No se pudo obtener los datos',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Verifica tu conexión a internet',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 24, 16, 32),
            child: _GraficaHistorial(),
          ),
        ),
      ],
    );
  }
}

// Campo de entrada COP
class _CopInputField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const _CopInputField({required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Introduce un valor en pesos colombianos',
            style: Theme.of(context)
                .textTheme
                .labelLarge
                ?.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: onChanged,
            style: Theme.of(context).textTheme.headlineSmall,
            decoration: InputDecoration(
              prefixIcon: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 14),
                child: Text('🇨🇴', style: TextStyle(fontSize: 28)),
              ),
              prefixIconConstraints:
                  const BoxConstraints(minWidth: 60, minHeight: 56),
              suffixText: 'COP',
              suffixStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              filled: true,
            ),
          ),
        ],
      ),
    );
  }
}

// Tarjeta de divisa 
class _TarjetaDivisa extends StatelessWidget {
  final String moneda;
  final String simbolo;
  final String bandera;
  final double copPorUnidad;
  final double copAmount;
  final Color colorInicial;

  const _TarjetaDivisa({
    required this.moneda,
    required this.simbolo,
    required this.bandera,
    required this.copPorUnidad,
    required this.copAmount,
    required this.colorInicial,
  });

  @override
  Widget build(BuildContext context) {
    final fmtCop = NumberFormat('#,##0.##', 'es_CO');
    final fmtForeign = NumberFormat('#,##0.####', 'es_CO');

    final tasaStr = fmtCop.format(copPorUnidad);
    final resultado =
        copAmount > 0 && copPorUnidad > 0 ? copAmount / copPorUnidad : 0.0;
    final resultadoStr = fmtForeign.format(resultado);

    final colorTexto = Theme.of(context).colorScheme.onSurface;
    final colorSubtexto = colorTexto.withValues(alpha: 0.55);

    return Container(
      decoration: BoxDecoration(
        color: colorInicial.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: colorInicial.withValues(alpha: 0.15),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      child: Row(
        children: [
          Text(bandera, style: const TextStyle(fontSize: 44)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  moneda,
                  style: TextStyle(
                    color: colorTexto,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '1 $simbolo = \$$tasaStr COP',
                  style: TextStyle(color: colorSubtexto, fontSize: 12),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                resultadoStr,
                style: TextStyle(
                  color: colorTexto,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                simbolo,
                style: TextStyle(color: colorSubtexto, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

//  Gráfica de historial 

class _GraficaHistorial extends ConsumerWidget {
  const _GraficaHistorial();

  static const _colorUsd = Color(0xFF5C6BC0);
  static const _colorEur = Color(0xFF66BB6A);
  static const _colorMxn = Color(0xFFEC407A);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historialAsync = ref.watch(historialDivisasProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Variación últimos 30 días',
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        const Text(
          'Cambio porcentual del COP frente a cada divisa',
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
        const SizedBox(height: 16),
        historialAsync.when(
          data: (historial) => _buildChart(context, historial),
          loading: () => const SizedBox(
            height: 200,
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (e, st) => const SizedBox(
            height: 80,
            child: Center(
              child: Text(
                'No se pudo cargar el historial',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChart(BuildContext context, HistorialDivisas historial) {
    final usdSpots = _spots(historial.usd);
    final eurSpots = _spots(historial.eur);
    final mxnSpots = _spots(historial.mxn);

    final allY = [...usdSpots, ...eurSpots, ...mxnSpots].map((s) => s.y);
    final minY = (allY.reduce((a, b) => a < b ? a : b) - 0.3).floorToDouble();
    final maxY = (allY.reduce((a, b) => a > b ? a : b) + 0.3).ceilToDouble();

    return Container(
      height: 220,
      padding: const EdgeInsets.fromLTRB(8, 16, 16, 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Expanded(
            child: LineChart(
              LineChartData(
                minX: 0,
                maxX: (historial.usd.length - 1).toDouble(),
                minY: minY,
                maxY: maxY,
                clipData: const FlClipData.all(),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 1,
                  getDrawingHorizontalLine: (v) => FlLine(
                    color: Colors.grey.withValues(alpha: 0.15),
                    strokeWidth: 1,
                  ),
                ),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 42,
                      interval: 1,
                      getTitlesWidget: (v, meta) => Text(
                        '${v > 0 ? '+' : ''}${v.toStringAsFixed(1)}%',
                        style: const TextStyle(
                            color: Colors.grey, fontSize: 10),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 22,
                      interval: 4,
                      getTitlesWidget: (v, meta) {
                        final idx = v.round();
                        if (idx < 0 || idx >= historial.usd.length) {
                          return const SizedBox.shrink();
                        }
                        final f = historial.usd[idx].fecha;
                        return Text(
                          '${f.day}/${f.month}',
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 10),
                        );
                      },
                    ),
                  ),
                ),
                lineBarsData: [
                  _linea(usdSpots, _colorUsd),
                  _linea(eurSpots, _colorEur),
                  _linea(mxnSpots, _colorMxn),
                ],
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipItems: (spots) => spots.map((s) {
                      final labels = ['USD', 'EUR', 'MXN'];
                      final colors = [_colorUsd, _colorEur, _colorMxn];
                      final i = s.barIndex;
                      return LineTooltipItem(
                        '${labels[i]}: ${s.y > 0 ? '+' : ''}${s.y.toStringAsFixed(2)}%',
                        TextStyle(
                            color: colors[i],
                            fontWeight: FontWeight.bold,
                            fontSize: 12),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          _Leyenda(),
        ],
      ),
    );
  }

  List<FlSpot> _spots(List<PuntoHistorial> puntos) {
    if (puntos.isEmpty) return [];
    final base = puntos.first.valor;
    return puntos.asMap().entries.map((e) {
      final pct = base > 0 ? (e.value.valor - base) / base * 100 : 0.0;
      return FlSpot(e.key.toDouble(), pct);
    }).toList();
  }

  LineChartBarData _linea(List<FlSpot> spots, Color color) {
    return LineChartBarData(
      spots: spots,
      isCurved: true,
      curveSmoothness: 0.3,
      color: color,
      barWidth: 2,
      isStrokeCapRound: true,
      dotData: const FlDotData(show: false),
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          colors: [
            color.withValues(alpha: 0.25),
            color.withValues(alpha: 0.0),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }
}

class _Leyenda extends StatelessWidget {
  const _Leyenda();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        _ItemLeyenda(color: Color(0xFF5C6BC0), label: 'USD'),
        SizedBox(width: 20),
        _ItemLeyenda(color: Color(0xFF66BB6A), label: 'EUR'),
        SizedBox(width: 20),
        _ItemLeyenda(color: Color(0xFFEC407A), label: 'MXN'),
      ],
    );
  }
}

class _ItemLeyenda extends StatelessWidget {
  final Color color;
  final String label;

  const _ItemLeyenda({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}

//  Widgets auxiliares 
class _IndicadorEnVivo extends StatelessWidget {
  const _IndicadorEnVivo();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            color: Colors.greenAccent,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        const Text(
          'En vivo',
          style: TextStyle(fontSize: 13, color: Colors.greenAccent),
        ),
      ],
    );
  }
}

class _PieUltimaDivisa extends StatelessWidget {
  final Divisa divisa;

  const _PieUltimaDivisa({required this.divisa});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.update_rounded, size: 16, color: Colors.grey),
        const SizedBox(width: 6),
        Text(
          'Última actualización: ${divisa.dies}  •  Actualiza cada 30 s',
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ],
    );
  }
}
