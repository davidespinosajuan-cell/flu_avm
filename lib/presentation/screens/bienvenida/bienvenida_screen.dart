import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flu_avm/presentation/providers/providers.dart';

class BienvenidaScreen extends ConsumerWidget {
  const BienvenidaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool estTenebrisModus = ref.watch(estTenebrisModusProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0D1117) : const Color(0xFFF0F2F5),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, ref, estTenebrisModus, isDark),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _DiagramaConexion(),
                    SizedBox(height: 16),
                    _DescripcionSection(),
                    SizedBox(height: 16),
                    _EjemplosGrid(),
                    SizedBox(height: 16),
                    _EstadisticasRow(),
                    SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            _buildComenzarButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref, bool estTenebrisModus, bool isDark) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.asset(
              'assets/icon/icon.png',
              width: 52,
              height: 52,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              'Flu Avm',
              style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const Spacer(),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDark ? const Color(0xFF21262D) : Colors.white,
              border: Border.all(
          color: isDark ? Colors.grey.shade600 : Colors.black12,
          width: 1.5,
        ),
            ),
            child: IconButton(
              onPressed: () => ref.read(estTenebrisModusProvider.notifier).state = !estTenebrisModus,
              icon: Icon(
                estTenebrisModus ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
                color: isDark ? Colors.amber : Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComenzarButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: const Color(0xFF4F6BF6),
            borderRadius: BorderRadius.circular(14),
          ),
          child: TextButton(
            onPressed: () => context.go('/home'),
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.play_arrow_rounded, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  'Comenzar',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DiagramaConexion extends StatelessWidget {
  const _DiagramaConexion();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF161B22) : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0D2A0D) : const Color(0xFFE6F4EA),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF3FB950)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircleAvatar(radius: 4, backgroundColor: Color(0xFF3FB950)),
                const SizedBox(width: 6),
                Text(
                  'CONECTADO',
                  style: textTheme.labelMedium?.copyWith(
                    color: const Color(0xFF3FB950),
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              _ImagenBox('assets/images/movil.png'),
              Expanded(child: _Conector()),
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(color: Color(0xFF4F6BF6), shape: BoxShape.circle),
                child: Center(
                  child: Text(
                    'WS',
                    style: textTheme.labelLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Expanded(child: _Conector()),
              _ImagenBox('assets/images/servidor.png'),
            ],
          ),
        ],
      ),
    );
  }
}

class _Conector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/puntos.png'),
          repeat: ImageRepeat.repeatX,
          fit: BoxFit.fitHeight,
        ),
      ),
    );
  }
}

class _ImagenBox extends StatelessWidget {
  final String assetPath;
  const _ImagenBox(this.assetPath);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: 72,
      height: 72,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF30363D) : const Color(0xFFF0F2F5),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? Colors.grey.shade600 : Colors.black12,
          width: 1.5,
        ),
      ),
      child: Image.asset(
        assetPath,
        fit: BoxFit.contain,
        errorBuilder: (context, _, _) => Icon(
          Icons.image_not_supported_outlined,
          color: isDark ? Colors.white38 : Colors.black26,
          size: 32,
        ),
      ),
    );
  }
}

class _DescripcionSection extends StatelessWidget {
  const _DescripcionSection();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF161B22) : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(children: [
              TextSpan(
                text: 'WebSockets ',
                style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: 'en vivo',
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF3FB950),
                ),
              ),
            ]),
          ),
          const SizedBox(height: 8),
          Text(
            'Aprende a construir apps con datos en tiempo real en Flutter. Dos ejemplos prácticos te esperan dentro.',
            style: textTheme.bodyMedium?.copyWith(height: 1.5),
          ),
        ],
      ),
    );
  }
}

class _EjemplosGrid extends StatelessWidget {
  const _EjemplosGrid();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: _EjemploCard(
            imagenPath: 'assets/images/mapa.jpg',
            titulo: 'Mapas',
            subtitulo: 'Ubicación en tiempo real',
            ruta: '/charta',
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _EjemploCard(
            imagenPath: 'assets/images/votaciones.jpg',
            titulo: 'Votaciones',
            subtitulo: 'Gráfico que se actualiza',
            ruta: '/bands',
          ),
        ),
      ],
    );
  }
}

class _EjemploCard extends StatelessWidget {
  final String imagenPath;
  final String titulo;
  final String subtitulo;
  final String ruta;

  const _EjemploCard({
    required this.imagenPath,
    required this.titulo,
    required this.subtitulo,
    required this.ruta,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textTheme = Theme.of(context).textTheme;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF161B22) : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.asset(imagenPath, height: 120, width: double.infinity, fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(titulo, style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(subtitulo, style: textTheme.bodySmall),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => context.go(ruta),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF4F6BF6)),
                      foregroundColor: const Color(0xFF4F6BF6),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Abrir ejemplo', style: textTheme.labelMedium?.copyWith(color: const Color(0xFF4F6BF6))),
                        const SizedBox(width: 4),
                        const Icon(Icons.arrow_forward, size: 14),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EstadisticasRow extends StatelessWidget {
  const _EstadisticasRow();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(child: _StatBox(valor: '5', etiqueta: 'PANTALLAS', icon: Icons.monitor_outlined, valorColor: Color(0xFF4F6BF6))),
        SizedBox(width: 12),
        Expanded(child: _StatBox(valor: '2', etiqueta: 'WEBSOCKETS', icon: Icons.code_outlined, valorColor: Color(0xFF4F6BF6))),
        SizedBox(width: 12),
        Expanded(child: _StatBox(valor: 'JDME', etiqueta: 'JUAN MUÑOZ', icon: Icons.person_outline, valorColor: Color(0xFF3FB950))),
      ],
    );
  }
}

class _StatBox extends StatelessWidget {
  final String valor;
  final String etiqueta;
  final IconData icon;
  final Color valorColor;

  const _StatBox({
    required this.valor,
    required this.etiqueta,
    required this.icon,
    required this.valorColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF161B22) : Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(valor, style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: valorColor)),
              Icon(icon, color: isDark ? Colors.white38 : Colors.black26, size: 20),
            ],
          ),
          const SizedBox(height: 4),
          Text(etiqueta, style: textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold, letterSpacing: 0.5)),
        ],
      ),
    );
  }
}
