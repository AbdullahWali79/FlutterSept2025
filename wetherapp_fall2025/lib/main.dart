import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const WeatherApp());
}

// The root widget of the weather application.
// It sets up the MaterialApp with the title, theme, and home screen.
class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Weather',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        fontFamily: 'Roboto',
      ),
      home: const WeatherHome(),
    );
  }
}

// The home screen of the weather app. It is a stateful widget, so it can
// manage its own state, such as the current weather data.
class WeatherHome extends StatefulWidget {
  const WeatherHome({super.key});

  @override
  State<WeatherHome> createState() => _WeatherHomeState();
}

// The state for the WeatherHome widget. This class handles the business logic,
// such as fetching weather data from the API, managing the loading and error states,
// and building the UI based on the current state.
class _WeatherHomeState extends State<WeatherHome> {
  final TextEditingController _cityCtrl = TextEditingController();
  bool _loading = false;
  String? _error;
  WeatherData? _data;

  static const String _apiKey = '6e825bd12e3b14c47cc76f6a31bbdae0'; // <-- Replace this
  // OpenWeatherMap current weather endpoint
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  Future<void> _fetchWeather(String city) async {
    if (city.trim().isEmpty) {
      setState(() {
        _error = 'Please enter a city name.';
        _data = null;
      });
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    final uri = Uri.parse('$_baseUrl?q=$city&appid=$_apiKey&units=metric');

    try {
      final res = await http.get(uri);
      if (res.statusCode == 200) {
        final json = jsonDecode(res.body) as Map<String, dynamic>;
        final parsed = WeatherData.fromJson(json);
        setState(() => _data = parsed);
      } else {
        // Parse error message if present
        String msg = 'Failed to fetch weather.';
        try {
          final j = jsonDecode(res.body);
          if (j is Map && j['message'] is String) msg = j['message'];
        } catch (_) {}
        setState(() {
          _error = 'Error: $msg';
          _data = null;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Network error. Please check your connection.';
        _data = null;
      });
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  void dispose() {
    _cityCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Background gradient colors
    const topColor = Color(0xFF56CCF2);
    const bottomColor = Color(0xFF2F80ED);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [topColor, bottomColor],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  Text(
                    'Simple Weather',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _SearchBar(
                    controller: _cityCtrl,
                    onSearch: () => _fetchWeather(_cityCtrl.text),
                  ),
                  const SizedBox(height: 20),
                  if (_loading)
                    const Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                  if (_error != null && !_loading)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: _InfoCard(
                        child: Text(
                          _error!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.redAccent, fontSize: 16),
                        ),
                      ),
                    ),
                  if (_data != null && !_loading)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: WeatherCard(data: _data!),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// A custom search bar widget that includes a text field for the city name
// and a search button.
class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSearch;
  const _SearchBar({required this.controller, required this.onSearch});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Material(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(16),
            child: TextField(
              controller: controller,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => onSearch(),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Type city name (e.g., Karachi)',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.85)),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: onSearch,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black87,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          child: const Text('Search'),
        ),
      ],
    );
  }
}

// A widget that displays the fetched weather data in a formatted card.
// It shows information like city name, temperature, weather description, and more.
class WeatherCard extends StatelessWidget {
  final WeatherData data;
  const WeatherCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return _InfoCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            data.city,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            data.description,
            style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 14),
          if (data.iconUrl != null)
            Image.network(
              data.iconUrl!,
              width: 100,
              height: 100,
            ),
          const SizedBox(height: 10),
          Text(
            '${data.temp.toStringAsFixed(1)}°C',
            style: const TextStyle(fontSize: 44, fontWeight: FontWeight.w800),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 14,
            runSpacing: 6,
            children: [
              _ChipText(label: 'Feels like: ${data.feelsLike.toStringAsFixed(1)}°C'),
              _ChipText(label: 'Humidity: ${data.humidity}%'),
              _ChipText(label: 'Wind: ${data.wind.toStringAsFixed(1)} m/s'),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Updated: ${data.updatedAt}',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// A reusable card widget with a standard design (white background, rounded corners,
// and a box shadow). It is used to wrap content like the weather details or error messages.
class _InfoCard extends StatelessWidget {
  final Widget child;
  const _InfoCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: child,
    );
  }
}

// A small, styled widget that displays a piece of text within a decorative
// chip-like container. Used for displaying secondary weather information.
class _ChipText extends StatelessWidget {
  final String label;
  const _ChipText({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label, style: const TextStyle(fontSize: 13)),
    );
  }
}

// A data model class that represents the weather data fetched from the API.
// It includes a factory constructor to parse the JSON response into a WeatherData object.
class WeatherData {
  final String city;
  final double temp;
  final double feelsLike;
  final int humidity;
  final double wind;
  final String description;
  final String? iconUrl;
  final String updatedAt;

  WeatherData({
    required this.city,
    required this.temp,
    required this.feelsLike,
    required this.humidity,
    required this.wind,
    required this.description,
    required this.iconUrl,
    required this.updatedAt,
  });

  factory WeatherData.fromJson(Map<String, dynamic> j) {
    final weather = (j['weather'] as List).isNotEmpty ? j['weather'][0] : null;
    final main = j['main'] ?? {};
    final wind = j['wind'] ?? {};
    final city = j['name'] ?? '';
    final iconCode = (weather != null && weather['icon'] != null) ? weather['icon'] as String : '';
    final iconUrl = iconCode.isNotEmpty
        ? 'https://openweathermap.org/img/wn/$iconCode@4x.png'
        : null;

    final dt = j['dt'] is int ? DateTime.fromMillisecondsSinceEpoch(j['dt'] * 1000, isUtc: true).toLocal() : DateTime.now();

    return WeatherData(
      city: city,
      temp: (main['temp'] as num?)?.toDouble() ?? 0,
      feelsLike: (main['feels_like'] as num?)?.toDouble() ?? 0,
      humidity: (main['humidity'] as num?)?.toInt() ?? 0,
      wind: (wind['speed'] as num?)?.toDouble() ?? 0,
      description: (weather != null ? (weather['description'] ?? '') : '').toString(),
      iconUrl: iconUrl,
      updatedAt: dt.toLocal().toString(),
    );
  }
}
