import 'package:flutter/material.dart';

class ClothingSuggestionCard extends StatelessWidget {
  final double temperature;
  final String condition;
  final double windSpeed;

  const ClothingSuggestionCard({
    super.key,
    required this.temperature,
    required this.condition,
    required this.windSpeed,
  });

  String _getClothingSuggestion() {
    if (temperature < 0) {
      return '🧥 Heavy winter coat, gloves, scarf, and warm boots required!';
    } else if (temperature < 10) {
      return '🧥 Wear a warm jacket, long pants, and closed shoes.';
    } else if (temperature < 18) {
      return '👔 Light jacket or sweater recommended.';
    } else if (temperature < 25) {
      return '👕 Comfortable shirt and pants. Perfect weather!';
    } else if (temperature < 30) {
      return '👕 Light clothing. T-shirt and shorts are good.';
    } else {
      return '🩳 Very hot! Wear minimal, breathable clothing. Stay hydrated!';
    }
  }

  String _getAccessorySuggestion() {
    final suggestions = <String>[];
    
    if (condition.toLowerCase().contains('rain')) {
      suggestions.add('☂️ Umbrella essential!');
    }
    
    if (temperature > 25) {
      suggestions.add('😎 Sunglasses recommended');
      suggestions.add('🧴 Apply sunscreen');
    }
    
    if (windSpeed > 10) {
      suggestions.add('🧢 Secure your hat!');
    }
    
    if (suggestions.isEmpty) {
      return '✨ No special accessories needed today!';
    }
    
    return suggestions.join(' • ');
  }

  IconData _getClothingIcon() {
    if (temperature < 10) return Icons.ac_unit;
    if (temperature < 18) return Icons.checkroom;
    if (temperature < 25) return Icons.checkroom_outlined;
    return Icons.wb_sunny;
  }

  Color _getSuggestionColor(bool isDark) {
    if (temperature < 10) {
      return isDark ? const Color(0xFF5E92F3) : const Color(0xFF2979FF);
    } else if (temperature < 25) {
      return isDark ? const Color(0xFF4CAF50) : const Color(0xFF00C853);
    } else {
      return isDark ? const Color(0xFFFF9800) : const Color(0xFFFF6D00);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = _getSuggestionColor(isDark);

    return Card(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withOpacity(0.8),
              color,
            ],
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getClothingIcon(),
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    '👔 What to Wear',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${temperature.round()}°',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Clothing Suggestion',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white70,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _getClothingSuggestion(),
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.category_outlined,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _getAccessorySuggestion(),
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
