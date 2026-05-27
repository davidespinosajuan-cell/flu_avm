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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _DiagramaConexion(isDark: isDark),
                    const SizedBox(height: 16),
                    _DescripcionSection(isDark: isDark),
                    const SizedBox(height: 16),
                    _EjemplosGrid(isDark: isDark),
                    const SizedBox(height: 16),
                    _EstadisticasRow(isDark: isDark),
                    const SizedBox(height: 24),
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
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: const Color(0xFF4F6BF6),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Text(
                '{ }',
                style: textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Flu Avm',
                style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              
            ],
          ),
          const Spacer(),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDark ? const Color(0xFF21262D) : Colors.white,
              border: Border.all(
                color: isDark ? Colors.white12 : Colors.black12,
              ),
            ),
            child: IconButton(
              onPressed: () {
                ref.read(estTenebrisModusProvider.notifier).state = !estTenebrisModus;
              },

              icon: Icon(
                estTenebrisModus
                    ? Icons.dark_mode_outlined
                    : Icons.light_mode_outlined,
                color: isDark ? Colors.amber : Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComenzarButton(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: double.infinity,
        height: 52,

        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF4F6BF6), Color(0xFF9B59B6)],
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          child: TextButton(
            onPressed: () => context.go('/home'),
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.play_arrow_rounded, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  'Comenzar',
                  style: textTheme.titleMedium?.copyWith(
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
  final bool isDark;
  const _DiagramaConexion({required this.isDark});

  @override
  Widget build(BuildContext context) {
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
                const CircleAvatar(
                  radius: 4,
                  backgroundColor: Color(0xFF3FB950),
                ),
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
              _ImagenBox(assetPath: 'assets/images/movil.png', isDark: isDark),
              Expanded(
                child: Container(
                  height: 20,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/puntos.png'),
                      repeat: ImageRepeat.repeatX,
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
              ),
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: Color(0xFF4F6BF6),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    'WS',
                    style: textTheme.labelLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 20,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/puntos.png'),
                      repeat: ImageRepeat.repeatX,
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
              ),
              _ImagenBox(assetPath: 'assets/images/servidor.png', isDark: isDark),
            ],
          ),
        ],
      ),
    );
  }
}

class _ImagenBox extends StatelessWidget {
  final String assetPath;
  final bool isDark;
  const _ImagenBox({required this.assetPath, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      height: 72,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF21262D) : const Color(0xFFF0F2F5),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isDark ? Colors.white12 : Colors.black12),
      ),
      child: Image.asset(
        assetPath,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => Icon(
          Icons.image_not_supported_outlined,
          color: isDark ? Colors.white38 : Colors.black26,
          size: 32,
        ),
      ),
    );
  }
}

class _DescripcionSection extends StatelessWidget {
  final bool isDark;
  const _DescripcionSection({required this.isDark});

  @override
  Widget build(BuildContext context) {
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
            TextSpan(
              children: [
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
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Aprende a construir apps con datos en tiempo real\nen Flutter. Dos ejemplos prácticos te esperan dentro.',
            style: textTheme.bodyMedium?.copyWith(height: 1.5),
          ),
        ],
      ),
    );
  }
}

class _EjemplosGrid extends StatelessWidget {
  final bool isDark;
  const _EjemplosGrid({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _EjemploCard(
            isDark: isDark,
            imagenPath: 'assets/images/mapa.jpg',
            titulo: 'Mapas',
            subtitulo: 'Ubicación en tiempo real',
            ruta: '/charta',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _EjemploCard(
            isDark: isDark,
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
  final bool isDark;
  final String imagenPath;
  final String titulo;
  final String subtitulo;
  final String ruta;

  const _EjemploCard({
    required this.isDark,
    required this.imagenPath,
    required this.titulo,
    required this.subtitulo,
    required this.ruta,
  });

  @override
  Widget build(BuildContext context) {
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
            child: Image.asset(
              imagenPath,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(subtitulo, style: textTheme.bodySmall),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => context.go(ruta),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF6C3FC1)),
                      foregroundColor: const Color(0xFF6C3FC1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Abrir ejemplo', style: textTheme.labelMedium?.copyWith(color: const Color(0xFF6C3FC1))),
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
  final bool isDark;
  const _EstadisticasRow({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatBox(
            isDark: isDark,
            valor: '5',
            etiqueta: 'PANTALLAS',
            
            icon: Icons.monitor_outlined,
            valorColor: const Color(0xFF4F6BF6),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatBox(
            isDark: isDark,
            valor: '2',
            etiqueta: 'WEBSOCKETS',
            icon: Icons.code_outlined,
            valorColor: const Color(0xFF4F6BF6),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatBox(
            isDark: isDark,
            valor: 'JDME',
            etiqueta: 'JUAN MUÑOZ',
            
            icon: Icons.person_outline,
            valorColor: const Color(0xFF3FB950),
          ),
        ),
      ],
    );
  }
}

class _StatBox extends StatelessWidget {
  final bool isDark;
  final String valor;
  final String etiqueta;
  
  final IconData icon;
  final Color valorColor;

  const _StatBox({
    required this.isDark,
    required this.valor,
    required this.etiqueta,
   
    required this.icon,
    required this.valorColor,
  });

  @override
  Widget build(BuildContext context) {
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
              Text(
                valor,
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: valorColor,
                ),
              ),
              Icon(
                icon,
                color: isDark ? Colors.white38 : Colors.black26,
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            etiqueta,
            style: textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
