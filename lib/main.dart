import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'providers/weather_provider.dart';
import 'providers/settings_provider.dart';
import 'screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox<String>('favourites');
  runApp(const SkyWatchApp());
}

class SkyWatchApp extends StatelessWidget {
  const SkyWatchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsProvider()..init()),
        ChangeNotifierProxyProvider<SettingsProvider, WeatherProvider>(
          create: (_) => WeatherProvider()..init(),
          update: (_, settings, weatherProvider) {
            weatherProvider ??= WeatherProvider();
            weatherProvider.setSettingsProvider(settings);
            return weatherProvider;
          },
        ),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settings, child) {
          return MaterialApp(
            title: 'SkyWatch',
            debugShowCheckedModeBanner: false,
            themeMode: settings.themeMode,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF00B4DB),
                primary: const Color(0xFF00B4DB),
                secondary: const Color(0xFFFFD93D),
                tertiary: const Color(0xFFFF6B6B),
                brightness: Brightness.light,
              ),
              scaffoldBackgroundColor: const Color(0xFFF0F4FF),
              useMaterial3: true,
              appBarTheme: const AppBarTheme(
                centerTitle: true,
                elevation: 0,
                backgroundColor: Colors.transparent,
                foregroundColor: Color(0xFF1A237E),
                titleTextStyle: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1A237E),
                  letterSpacing: 1.2,
                ),
              ),
              cardTheme: CardThemeData(
                elevation: 10,
                shadowColor: const Color(0xFF00B4DB).withOpacity(0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                color: Colors.white.withOpacity(0.9), // Glassmorphism hint
              ),
              textTheme: const TextTheme(
                headlineMedium: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A237E),
                ),
                titleLarge: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A237E),
                ),
                bodyLarge: TextStyle(
                  color: Color(0xFF2C3E50),
                  fontSize: 16,
                ),
              ),
            ),
            darkTheme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF667EEA),
                brightness: Brightness.dark,
                primary: const Color(0xFF667EEA),
                secondary: const Color(0xFFF093FB),
                tertiary: const Color(0xFF4AC29A),
              ),
              scaffoldBackgroundColor: const Color(0xFF0F0F1E),
              useMaterial3: true,
              appBarTheme: const AppBarTheme(
                centerTitle: true,
                elevation: 0,
                backgroundColor: Colors.transparent,
                titleTextStyle: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
              cardTheme: CardThemeData(
                elevation: 10,
                shadowColor: const Color(0xFF667EEA).withOpacity(0.3),
                color: const Color(0xFF1A1A2E).withOpacity(0.8), // Glassmorphism hint
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              textTheme: const TextTheme(
                headlineMedium: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                titleLarge: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
                bodyLarge: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
            ),
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
