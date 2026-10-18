# Weather App - Flutter

A modern Weather Application built with **Flutter** and **Dart** that fetches real-time weather information, hourly forecasts, and additional weather details using OpenWeatherMap API.

## 📁 Project Structure

The project code inside `lib/` consists of the following key files:

* **`main.dart`**: The entry point of the Flutter application. Initializes the app settings and sets up the primary theme (Dark/Light).
* **`weatherapp.dart`**: The primary screen displaying real-time weather data, temperature, conditions, hourly forecast scroll view, and additional details.
* **`secrets.dart`**: Contains API keys and sensitive configuration credentials used for fetching live weather data.
* **`hourlyforcastitem.dart`**: A reusable UI component (Card Widget) representing hourly forecast information (Time, Icon, Temperature).
* **`additionalinfoitem.dart`**: A reusable UI component for displaying additional weather statistics such as Humidity, Wind Speed, and Pressure.

## 🚀 Features

* **Real-Time Weather Data**: Displays current temperature and weather conditions (e.g., Rain, Clouds, Clear sky).
* **Hourly Forecast**: Interactive horizontal scroll displaying weather predictions for upcoming hours.
* **Additional Weather Details**: Shows key metrics such as Humidity, Wind Speed, and Atmospheric Pressure.
* **Refresh Support**: Easily refresh the latest weather conditions.

## 🛠️ Tech Stack & API

* **Language**: [Dart](https://dart.dev/)
* **Framework**: [Flutter](https://flutter.dev/)
* **API**: [OpenWeatherMap API](https://openweathermap.org/api)

## 🔑 Setup & API Key Configuration

Before running the application, you need to add your OpenWeatherMap API key:

1. Sign up on [OpenWeatherMap](https://home.openweathermap.org/users/sign_up) and generate a free API key.
2. Create `secrets.dart` in the lib folder and insert your API key:
   ```dart
   const String openWeatherMapApiKey = 'YOUR_API_KEY_HERE';
   ```

> ⚠️ **Note**: Make sure to add `secrets.dart` to your `.gitignore` file to avoid exposing your personal API key publicly!

## 💻 Getting Started

### Prerequisites

* Install [Flutter SDK](https://docs.flutter.dev/get-started/install).
* An IDE such as VS Code or Android Studio.

### Run the App

1. **Clone the repository:**
   ```bash
   git clone https://github.com/Yuonos-alesrawi/Weather-App-Flutter
   ```
2. **Navigate to project directory:**
   ```bash
   cd Weather-App-Flutter
   ```
3. **Get dependencies:**
   ```bash
   flutter pub get
   ```
4. **Run application:**
   ```bash
   flutter run
   ```