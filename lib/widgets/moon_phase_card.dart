import 'package:flutter/material.dart';
import 'dart:math';

class MoonPhaseCard extends StatelessWidget {
  const MoonPhaseCard({super.key});

  @override
  Widget build(BuildContext context) {
    final phase = _calculateMoonPhase(DateTime.now());
    
    return Card(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: const LinearGradient(
            colors: [Color(0xFF2C3E50), Color(0xFF4CA1AF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.shade200,
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.5),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                   // Simple representation of moon phase with an icon or shape
                   // Ideally we'd draw the phase, but for now we use an icon
                   Icon(
                     _getMoonIcon(phase),
                     size: 40,
                     color: Colors.amber.shade700,
                   ),
                ],
              ),
            ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Moon Phase',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  phase,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Illumination: ${_getIllumination(phase)}',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _calculateMoonPhase(DateTime date) {
    // Simple Moon Phase Calculation
    int year = date.year;
    int month = date.month;
    int day = date.day;

    if (month < 3) {
      year--;
      month += 12;
    }

    ++month;
    
    double days = 365.25 * year + 30.6 * month + day - 694039.09; // Days since 1900
    days /= 29.53; // Moon cycle length
    
    double phaseIndex = days - days.floor(); // Fractional part is phase (0-1)
    
    // Convert to phase name
    int index = (phaseIndex * 8).round() & 7;
    
    switch (index) {
      case 0: return 'New Moon';
      case 1: return 'Waxing Crescent';
      case 2: return 'First Quarter';
      case 3: return 'Waxing Gibbous';
      case 4: return 'Full Moon';
      case 5: return 'Waning Gibbous';
      case 6: return 'Last Quarter';
      case 7: return 'Waning Crescent';
      default: return 'Unknown';
    }
  }

  IconData _getMoonIcon(String phase) {
      // Just some approximations for icons, Material icons are limited for phases
      if (phase == 'Full Moon') return Icons.circle;
      if (phase == 'New Moon') return Icons.circle_outlined;
      return Icons.nightlight_round;
  }

  String _getIllumination(String phase) {
    // Rough approximations
    switch (phase) {
      case 'New Moon': return '0%';
      case 'Waxing Crescent': return '10-40%';
      case 'First Quarter': return '50%';
      case 'Waxing Gibbous': return '60-90%';
      case 'Full Moon': return '100%';
      case 'Waning Gibbous': return '60-90%';
      case 'Last Quarter': return '50%';
      case 'Waning Crescent': return '10-40%';
      default: return '-';
    }
  }
}
