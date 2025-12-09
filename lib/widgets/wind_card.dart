import 'package:flutter/material.dart';
import 'dart:math' as math;

class WindCard extends StatefulWidget {
  final double windSpeed;
  final int windDegree;

  const WindCard({
    super.key,
    required this.windSpeed,
    required this.windDegree,
  });

  @override
  State<WindCard> createState() => _WindCardState();
}

class _WindCardState extends State<WindCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _getWindDirection() {
    if (widget.windDegree >= 337.5 || widget.windDegree < 22.5) return 'N';
    if (widget.windDegree >= 22.5 && widget.windDegree < 67.5) return 'NE';
    if (widget.windDegree >= 67.5 && widget.windDegree < 112.5) return 'E';
    if (widget.windDegree >= 112.5 && widget.windDegree < 157.5) return 'SE';
    if (widget.windDegree >= 157.5 && widget.windDegree < 202.5) return 'S';
    if (widget.windDegree >= 202.5 && widget.windDegree < 247.5) return 'SW';
    if (widget.windDegree >= 247.5 && widget.windDegree < 292.5) return 'W';
    return 'NW';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Card(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            colors: isDark
                ? [const Color(0xFF4ECDC4), const Color(0xFF44A08D)]
                : [const Color(0xFF43E97B), const Color(0xFF38F9D7)],
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Wind Speed',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${widget.windSpeed.toStringAsFixed(1)}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Padding(
                          padding: EdgeInsets.only(bottom: 8),
                          child: Text(
                            'm/s',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: widget.windDegree * math.pi / 180,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.navigation_rounded,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Direction: ${_getWindDirection()} (${widget.windDegree}°)',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
