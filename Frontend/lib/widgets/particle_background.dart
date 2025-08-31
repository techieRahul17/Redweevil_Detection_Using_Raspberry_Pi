import 'package:flutter/material.dart';
import 'dart:math';

class Particle {
  Offset position;
  Color color;
  double speed;
  double size;

  Particle({
    required this.position,
    required this.color,
    required this.speed,
    required this.size,
  });
}

class ParticleBackground extends StatefulWidget {
  final int numberOfParticles;

  ParticleBackground({this.numberOfParticles = 50});

  @override
  _ParticleBackgroundState createState() => _ParticleBackgroundState();
}

class _ParticleBackgroundState extends State<ParticleBackground>
    with SingleTickerProviderStateMixin {
  List<Particle> particles = [];
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 10),
    )..repeat();

    _initializeParticles();
  }

  void _initializeParticles() {
    final random = Random();
    for (int i = 0; i < widget.numberOfParticles; i++) {
      particles.add(
        Particle(
          position: Offset(
            random.nextDouble() * MediaQuery.of(context).size.width,
            random.nextDouble() * MediaQuery.of(context).size.height,
          ),
          color: Color.fromRGBO(
            255,
            215,
            random.nextInt(100) + 100,
            random.nextDouble() * 0.8 + 0.2,
          ),
          speed: random.nextDouble() * 20 + 10,
          size: random.nextDouble() * 4 + 1,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: ParticlePainter(particles, _controller.value),
          child: Container(),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double animationValue;

  ParticlePainter(this.particles, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      final paint = Paint()..color = particle.color;
      final newY = (particle.position.dy + particle.speed * animationValue) % size.height;
      canvas.drawCircle(
        Offset(particle.position.dx, newY),
        particle.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) => true;
}

