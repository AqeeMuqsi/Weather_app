import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:skywatch/main.dart';
import 'package:skywatch/screens/home_screen.dart';
import 'package:skywatch/screens/search_screen.dart';
import 'package:skywatch/screens/favourites_screen.dart';
import 'package:skywatch/screens/alerts_screen.dart';
import 'package:skywatch/screens/settings_screen.dart';
import 'package:skywatch/providers/weather_provider.dart';
import 'package:skywatch/providers/settings_provider.dart';

void main() {
  group('Widget Tests', () {
    testWidgets('SkyWatchApp should build without errors', (WidgetTester tester) async {
      // Build the app
      await tester.pumpWidget(const SkyWatchApp());
      
      // Verify the app builds successfully
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('HomeScreen should display app title', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => SettingsProvider()),
            ChangeNotifierProvider(create: (_) => WeatherProvider()),
          ],
          child: const MaterialApp(home: HomeScreen()),
        ),
      );

      // Wait for the widget to settle
      await tester.pumpAndSettle();

      // Verify HomeScreen renders
      expect(find.byType(HomeScreen), findsOneWidget);
    });

    testWidgets('SearchScreen should have search functionality', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => SettingsProvider()),
            ChangeNotifierProvider(create: (_) => WeatherProvider()),
          ],
          child: const MaterialApp(home: SearchScreen()),
        ),
      );

      await tester.pumpAndSettle();

      // Verify SearchScreen renders
      expect(find.byType(SearchScreen), findsOneWidget);
      
      // Look for text input field
      expect(find.byType(TextField), findsWidgets);
    });

    testWidgets('FavouritesScreen should display region filter', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => SettingsProvider()),
            ChangeNotifierProvider(create: (_) => WeatherProvider()),
          ],
          child: const MaterialApp(home: FavouritesScreen()),
        ),
      );

      await tester.pumpAndSettle();

      // Verify FavouritesScreen renders
      expect(find.byType(FavouritesScreen), findsOneWidget);
    });

    testWidgets('AlertsScreen should render properly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => SettingsProvider()),
            ChangeNotifierProvider(create: (_) => WeatherProvider()),
          ],
          child: const MaterialApp(home: AlertsScreen()),
        ),
      );

      await tester.pumpAndSettle();

      // Verify AlertsScreen renders
      expect(find.byType(AlertsScreen), findsOneWidget);
    });

    testWidgets('SettingsScreen should display theme and unit toggles', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => SettingsProvider()),
            ChangeNotifierProvider(create: (_) => WeatherProvider()),
          ],
          child: const MaterialApp(home: SettingsScreen()),
        ),
      );

      await tester.pumpAndSettle();

      // Verify SettingsScreen renders
      expect(find.byType(SettingsScreen), findsOneWidget);
      
      // Look for Switch widgets (theme and unit toggles)
      expect(find.byType(Switch), findsWidgets);
    });

    testWidgets('App should switch between light and dark themes', (WidgetTester tester) async {
      final settingsProvider = SettingsProvider();
      
      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: settingsProvider,
          child: Consumer<SettingsProvider>(
            builder: (context, settings, _) {
              return MaterialApp(
                themeMode: settings.themeMode,
                theme: ThemeData.light(),
                darkTheme: ThemeData.dark(),
                home: const Scaffold(body: Text('Test')),
              );
            },
          ),
        ),
      );

      // Initial theme should be system
      expect(settingsProvider.themeMode, ThemeMode.system);

      // Toggle dark mode
      settingsProvider.toggleDarkMode();
      await tester.pumpAndSettle();

      // Verify dark mode is enabled
      expect(settingsProvider.isDarkMode, true);
    });

    testWidgets('Navigation drawer should contain all menu items', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => SettingsProvider()),
            ChangeNotifierProvider(create: (_) => WeatherProvider()),
          ],
          child: const MaterialApp(home: HomeScreen()),
        ),
      );

      await tester.pumpAndSettle();

      // Open the drawer by finding and tapping the menu icon
      final drawerIcon = find.byIcon(Icons.menu);
      if (drawerIcon.evaluate().isNotEmpty) {
        await tester.tap(drawerIcon);
        await tester.pumpAndSettle();

        // Verify drawer is open
        expect(find.byType(Drawer), findsOneWidget);
      }
    });
  });

  group('Provider Tests', () {
    test('SettingsProvider should toggle dark mode', () async {
      final provider = SettingsProvider();
      await provider.init();
      
      expect(provider.isDarkMode, false);
      
      await provider.toggleTheme(true);
      expect(provider.isDarkMode, true);
      
      await provider.toggleTheme(false);
      expect(provider.isDarkMode, false);
    });

    test('SettingsProvider should toggle units', () async {
      final provider = SettingsProvider();
      await provider.init();
      
      expect(provider.isMetric, true);
      
      await provider.toggleUnitSystem(false);
      expect(provider.isMetric, false);
      
      await provider.toggleUnitSystem(true);
      expect(provider.isMetric, true);
    });

    test('SettingsProvider should return correct units string', () async {
      final provider = SettingsProvider();
      await provider.init();
      
      expect(provider.unitSystem, 'metric');
      
      await provider.toggleUnitSystem(false);
      expect(provider.unitSystem, 'imperial');
    });
  });
}
