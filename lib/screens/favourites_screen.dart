import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/weather_provider.dart';
import '../widgets/app_background.dart';

class FavouritesScreen extends StatelessWidget {
  const FavouritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WeatherProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('⭐ Favourite Cities'),
      ),
      body: AppBackground(
        isDark: isDark,
        child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              value: provider.selectedRegion,
              items: const [
                DropdownMenuItem(value: 'All', child: Text('All Regions')),
                DropdownMenuItem(value: ', Europe', child: Text('Europe')),
                DropdownMenuItem(value: ', Asia', child: Text('Asia')),
                DropdownMenuItem(value: ', America', child: Text('America')),
              ],
              onChanged: (value) {
                if (value != null) {
                  provider.setRegionFilter(value);
                }
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: provider.getFilteredFavourites().length,
              itemBuilder: (context, index) {
                final city = provider.getFilteredFavourites()[index];
                return Dismissible(
                  key: Key(city),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) => provider.removeFavourite(index),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: ListTile(
                    title: Text(city),
                    trailing: const Icon(Icons.chevron_right),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      ),
    );
  }
}
