import 'package:flutter/material.dart';

class AnimatedGradientBackground extends StatefulWidget {
  final String weatherCondition;
  final bool isDark;
  final Widget child;

  const AnimatedGradientBackground({
    super.key,
    required this.weatherCondition,
    required this.isDark,
    required this.child,
  });

  @override
  State<AnimatedGradientBackground> createState() => _AnimatedGradientBackgroundState();
}

class _AnimatedGradientBackgroundState extends State<AnimatedGradientBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Alignment> _topAlignmentAnimation;
  late Animation<Alignment> _bottomAlignmentAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(reverse: true);

    _topAlignmentAnimation = TweenSequence<Alignment>([
      TweenSequenceItem(
        tween: Tween<Alignment>(
          begin: Alignment.topLeft,
          end: Alignment.topRight,
        ),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween<Alignment>(
          begin: Alignment.topRight,
          end: Alignment.bottomRight,
        ),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween<Alignment>(
          begin: Alignment.bottomRight,
          end: Alignment.bottomLeft,
        ),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween<Alignment>(
          begin: Alignment.bottomLeft,
          end: Alignment.topLeft,
        ),
        weight: 1,
      ),
    ]).animate(_controller);

    _bottomAlignmentAnimation = TweenSequence<Alignment>([
      TweenSequenceItem(
        tween: Tween<Alignment>(
          begin: Alignment.bottomRight,
          end: Alignment.bottomLeft,
        ),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween<Alignment>(
          begin: Alignment.bottomLeft,
          end: Alignment.topLeft,
        ),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween<Alignment>(
          begin: Alignment.topLeft,
          end: Alignment.topRight,
        ),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween<Alignment>(
          begin: Alignment.topRight,
          end: Alignment.bottomRight,
        ),
        weight: 1,
      ),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<Color> _getGradientColors() {
    if (widget.isDark) {
      switch (widget.weatherCondition.toLowerCase()) {
        case 'clear':
          // Deep Blue to Purple (Night Sky)
          return [const Color(0xFF0F2027), const Color(0xFF203A43), const Color(0xFF2C5364)]; 
        case 'clouds':
          // Dark Gray to Blue Gray
          return [const Color(0xFF232526), const Color(0xFF414345)];
        case 'rain':
        case 'drizzle':
          // Deep Indigo
          return [const Color(0xFF373B44), const Color(0xFF4286f4)];
        case 'thunderstorm':
           // Very Dark Violet
          return [const Color(0xFF141E30), const Color(0xFF243B55)];
        case 'snow':
           // Cool Dark Gray
          return [const Color(0xFF3E5151), const Color(0xFFDECBA4)];
        default:
          return [const Color(0xFF0F0F1E), const Color(0xFF1A1A2E)];
      }
    } else {
      switch (widget.weatherCondition.toLowerCase()) {
        case 'clear':
          // Bright Blue to Cyan (Sunny Day)
          return [const Color(0xFF2980B9), const Color(0xFF6DD5FA), const Color(0xFFFFFFFF)];
        case 'clouds':
          // Light Blue to Gray
          return [const Color(0xFF89F7FE), const Color(0xFF66A6FF)];
        case 'rain':
        case 'drizzle':
          // Muted Blue
          return [const Color(0xFF00c6ff), const Color(0xFF0072ff)];
        case 'thunderstorm':
           // Energetic Dark Blue
          return [const Color(0xFF485563), const Color(0xFF29323c)];
        case 'snow':
           // Icy White/Blue
          return [const Color(0xFFE6DADA), const Color(0xFF274046)];
        default:
          // Default Bright
           return [const Color(0xFF12c2e9), const Color(0xFFc471ed), const Color(0xFFf64f59)];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: _topAlignmentAnimation.value,
              end: _bottomAlignmentAnimation.value,
              colors: _getGradientColors(),
            ),
          ),
          child: widget.child,
        );
      },
    );
  }
}
