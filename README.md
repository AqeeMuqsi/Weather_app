# SkyWatch - Premium Weather App ☀️🌧️

![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)
![Dart](https://img.shields.io/badge/Dart-3.0+-blue.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)

**Developed by: Aqeela**

A beautiful, feature-rich weather application built with Flutter, featuring stunning gradient designs, real-time weather data, and comprehensive forecasting capabilities.

---

## ✨ Features

### 🌟 Core Features
- 🏠 **Real-time Weather** - Current weather with location detection
- 🔍 **City Search** - Search weather for any city worldwide
- ⭐ **Favorites** - Save and manage favorite cities
- ⚠️ **Weather Alerts** - Severe weather warnings
- ⚙️ **Settings** - Dark/Light theme & Unit preferences

### 🎨 Premium Features
- ⏰ **24-Hour Forecast** - Hourly weather with beautiful cards
- 📅 **7-Day Forecast** - Interactive chart visualization
- 🗺️ **Weather Map** - Interactive location map
- 💨 **Wind Visualization** - Animated compass with direction
- 🌅 **Sunrise & Sunset** - Timeline with progress indicator
- 💨 **Air Quality Index** - Color-coded AQI levels
- 🌡️ **Detailed Metrics** - Feels-like, Humidity, Pressure
- 🎨 **Dynamic Backgrounds** - Weather-responsive gradients
- 🌓 **Dark Mode** - Beautiful dark theme support
- 🌡️ **Unit Toggle** - Metric/Imperial conversion

---

## 📱 Screenshots

*(Add your app screenshots here)*

---

## 🏗️ Architecture

### Design Pattern: MVVM (Model-View-ViewModel)
- **Models**: Data structures (`Weather`, `DailyForecast`, `HourlyForecast`)
- **Views**: UI screens and widgets
- **ViewModels**: State management with Provider
- **Services**: API communication layer

### Project Structure
```
lib/
├── main.dart
├── models/
│   ├── weather.dart
│   ├── daily_forecast.dart
│   └── hourly_forecast.dart
├── providers/
│   ├── weather_provider.dart
│   └── settings_provider.dart
├── screens/
│   ├── home_screen.dart
│   ├── search_screen.dart
│   ├── favourites_screen.dart
│   ├── alerts_screen.dart
│   └── settings_screen.dart
├── services/
│   └── api_service.dart
└── widgets/
    ├── weather_card.dart
    ├── hourly_forecast_widget.dart
    ├── temperature_chart.dart
    ├── weather_map.dart
    ├── animated_gradient_background.dart
    ├── wind_card.dart
    ├── sunrise_sunset_card.dart
    ├── air_quality_card.dart
    └── weather_details_grid.dart
```

---

## 🛠️ Technologies & Libraries

### Core
- **Flutter 3.0+**
- **Dart 3.0+**
- **Material Design 3**

### State Management
- **provider (^6.1.2)** - State management

### Networking & Storage
- **dio (^5.7.0)** - HTTP client
- **hive (^2.2.3)** - NoSQL database
- **hive_flutter (^1.1.0)** - Hive Flutter integration

### Location & Maps
- **geolocator (^12.0.0)** - Location services
- **flutter_map (^6.1.0)** - Interactive maps
- **latlong2 (^0.9.1)** - Coordinates utilities

### Visualization
- **syncfusion_flutter_charts (^26.1.40)** - Beautiful charts
- **lottie (^3.1.0)** - Animations

### Utilities
- **intl (^0.19.0)** - Date formatting

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.0+)
- Dart SDK (3.0+)
- OpenWeatherMap API Key

### Installation

1. **Clone the repository**
```bash
git clone https://github.com/yourusername/skywatch_app.git
cd skywatch_app
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Add your API Key**
   - Open `lib/services/api_service.dart`
   - Replace `YOUR_API_KEY` with your OpenWeatherMap API key

4. **Run the app**
```bash
flutter run
```

---

## 📦 Build APK

```bash
flutter build apk --release
```

The APK will be generated at: `build/app/outputs/flutter-apk/app-release.apk`

---

## 🧪 Testing

Run tests with:
```bash
flutter test
```

---

## 📄 API Integration

### OpenWeatherMap API Endpoints Used
- **Current Weather**: `/data/2.5/weather`
- **Forecast**: `/data/2.5/onecall`
- **Alerts**: `/data/2.5/onecall`

### Features
- Location-based weather detection
- City search functionality
- Metric/Imperial unit conversion
- Real-time data updates
- Error handling & fallbacks

---

## 🎨 Design Highlights

### Color Schemes
**Light Theme**
- Primary: Cyan (#00B4DB)
- Secondary: Yellow (#FFD93D)
- Background: Light Blue (#F0F4FF)

**Dark Theme**
- Primary: Purple (#667EEA)
- Secondary: Pink (#F093FB)
- Background: Dark Navy (#0F0F1E)

### UI/UX Principles
- Material Design 3 guidelines
- Consistent 8px spacing grid
- 24px border radius for cards
- Gradient overlays for premium feel
- Smooth animations & transitions
- High contrast for accessibility

---

## 📝 License

This project is licensed under the MIT License.

---

## 👨‍💻 Developer

**Aqeela**

Mobile Application Development Coursework
Cross-Platform Development with Flutter

---

## 🙏 Acknowledgments

- OpenWeatherMap for weather data API
- Flutter team for the amazing framework
- Syncfusion for charting library
- OpenStreetMap for map tiles

---

## 📧 Contact

For any queries or feedback, please reach out to the developer.

---

**Made with ❤️ using Flutter**
"# https---github.com-AqeeMuqsi-Mobile_course-B" 
