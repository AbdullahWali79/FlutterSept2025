import 'dart:convert';
import 'dart:ui';
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
      title: 'Weather Forecast',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1),
          brightness: Brightness.light,
        ),
        fontFamily: 'Inter',
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
          headlineMedium: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.25,
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.15,
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.25,
          ),
        ),
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    // Modern gradient background
    const topColor = Color(0xFF667EEA);
    const middleColor = Color(0xFF764BA2);
    const bottomColor = Color(0xFF6B73FF);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [topColor, middleColor, bottomColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Header with animation
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 800),
                      curve: Curves.easeOutCubic,
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          Text(
                            'Weather Forecast',
                            style: theme.textTheme.headlineLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Get real-time weather updates',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: Colors.white.withOpacity(0.9),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    // Search Bar
                    _ModernSearchBar(
                      controller: _cityCtrl,
                      onSearch: () => _fetchWeather(_cityCtrl.text),
                    ),
                    const SizedBox(height: 24),
                    
                    // Content with animations
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      transitionBuilder: (child, animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0, 0.3),
                              end: Offset.zero,
                            ).animate(CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeOutCubic,
                            )),
                            child: child,
                          ),
                        );
                      },
                      child: _buildContent(context, theme),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, ThemeData theme) {
    if (_loading) {
      return Container(
        key: const ValueKey('loading'),
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            const CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 3,
            ),
            const SizedBox(height: 16),
            Text(
              'Fetching weather data...',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: Colors.white.withOpacity(0.8),
              ),
            ),
          ],
        ),
      );
    }

    if (_error != null) {
      return Container(
        key: const ValueKey('error'),
        child: _ModernErrorCard(error: _error!),
      );
    }

    if (_data != null) {
      return Container(
        key: const ValueKey('weather'),
        child: _ModernWeatherCard(data: _data!),
      );
    }

    return Container(
      key: const ValueKey('empty'),
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Icon(
            Icons.location_on_outlined,
            size: 64,
            color: Colors.white.withOpacity(0.6),
          ),
          const SizedBox(height: 16),
          Text(
            'Search for a city to get started',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }
}

// Modern search bar with glassmorphism effect and micro-interactions
class _ModernSearchBar extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onSearch;
  const _ModernSearchBar({required this.controller, required this.onSearch});

  @override
  State<_ModernSearchBar> createState() => _ModernSearchBarState();
}

class _ModernSearchBarState extends State<_ModernSearchBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: widget.controller,
                          textInputAction: TextInputAction.search,
                          onSubmitted: (_) => widget.onSearch(),
                          onTap: () {
                            setState(() => _isFocused = true);
                          },
                          onChanged: (value) {
                            if (value.isEmpty) {
                              setState(() => _isFocused = false);
                            }
                          },
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Search for a city...',
                            hintStyle: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 18,
                            ),
                            prefixIcon: Icon(
                              Icons.search_rounded,
                              color: Colors.white.withOpacity(0.8),
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(right: 8),
                        child: Material(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                          child: InkWell(
                            onTap: () {
                              _animationController.forward().then((_) {
                                _animationController.reverse();
                              });
                              widget.onSearch();
                            },
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              child: const Icon(
                                Icons.search_rounded,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// Modern weather card with glassmorphism and weather icons
class _ModernWeatherCard extends StatelessWidget {
  final WeatherData data;
  const _ModernWeatherCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.25),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1,
              ),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header with city and weather icon
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data.city,
                            style: theme.textTheme.headlineMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            data.description.toUpperCase(),
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withOpacity(0.9),
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _WeatherIcon(description: data.description),
                  ],
                ),
                const SizedBox(height: 24),
                
                // Temperature display
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${data.temp.toStringAsFixed(0)}',
                      style: theme.textTheme.headlineLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 72,
                        height: 0.9,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        '°C',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: Colors.white.withOpacity(0.8),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                // Weather details grid
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _WeatherDetailItem(
                              icon: Icons.thermostat_outlined,
                              label: 'Feels like',
                              value: '${data.feelsLike.toStringAsFixed(0)}°C',
                            ),
                          ),
                          Expanded(
                            child: _WeatherDetailItem(
                              icon: Icons.water_drop_outlined,
                              label: 'Humidity',
                              value: '${data.humidity}%',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _WeatherDetailItem(
                              icon: Icons.air_outlined,
                              label: 'Wind',
                              value: '${data.wind.toStringAsFixed(1)} m/s',
                            ),
                          ),
                          Expanded(
                            child: _WeatherDetailItem(
                              icon: Icons.access_time_outlined,
                              label: 'Updated',
                              value: _formatTime(data.updatedAt),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatTime(String dateTime) {
    try {
      final dt = DateTime.parse(dateTime);
      return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return 'Now';
    }
  }
}

// Weather icon based on description
class _WeatherIcon extends StatelessWidget {
  final String description;
  const _WeatherIcon({required this.description});

  @override
  Widget build(BuildContext context) {
    IconData iconData;
    Color iconColor;
    
    final desc = description.toLowerCase();
    
    if (desc.contains('sun') || desc.contains('clear')) {
      iconData = Icons.wb_sunny_rounded;
      iconColor = Colors.orange;
    } else if (desc.contains('cloud')) {
      iconData = Icons.cloud_rounded;
      iconColor = Colors.grey;
    } else if (desc.contains('rain')) {
      iconData = Icons.grain_rounded;
      iconColor = Colors.blue;
    } else if (desc.contains('snow')) {
      iconData = Icons.ac_unit_rounded;
      iconColor = Colors.lightBlue;
    } else if (desc.contains('storm') || desc.contains('thunder')) {
      iconData = Icons.thunderstorm_rounded;
      iconColor = Colors.purple;
    } else if (desc.contains('fog') || desc.contains('mist')) {
      iconData = Icons.blur_on_rounded;
      iconColor = Colors.grey;
    } else {
      iconData = Icons.wb_cloudy_rounded;
      iconColor = Colors.grey;
    }
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Icon(
        iconData,
        size: 32,
        color: iconColor,
      ),
    );
  }
}

// Weather detail item
class _WeatherDetailItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  
  const _WeatherDetailItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      children: [
        Icon(
          icon,
          color: Colors.white.withOpacity(0.8),
          size: 20,
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: Colors.white.withOpacity(0.7),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

// Modern error card
class _ModernErrorCard extends StatelessWidget {
  final String error;
  const _ModernErrorCard({required this.error});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.red.withOpacity(0.3),
                width: 1,
              ),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.error_outline_rounded,
                  color: Colors.red,
                  size: 48,
                ),
                const SizedBox(height: 16),
                Text(
                  'Oops! Something went wrong',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  error,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.red.withOpacity(0.8),
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
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
  final String updatedAt;

  WeatherData({
    required this.city,
    required this.temp,
    required this.feelsLike,
    required this.humidity,
    required this.wind,
    required this.description,
    required this.updatedAt,
  });

  factory WeatherData.fromJson(Map<String, dynamic> j) {
    final weather = (j['weather'] as List).isNotEmpty ? j['weather'][0] : null;
    final main = j['main'] ?? {};
    final wind = j['wind'] ?? {};
    final city = j['name'] ?? '';

    final dt = j['dt'] is int ? DateTime.fromMillisecondsSinceEpoch(j['dt'] * 1000, isUtc: true).toLocal() : DateTime.now();

    return WeatherData(
      city: city,
      temp: (main['temp'] as num?)?.toDouble() ?? 0,
      feelsLike: (main['feels_like'] as num?)?.toDouble() ?? 0,
      humidity: (main['humidity'] as num?)?.toInt() ?? 0,
      wind: (wind['speed'] as num?)?.toDouble() ?? 0,
      description: (weather != null ? (weather['description'] ?? '') : '').toString(),
      updatedAt: dt.toLocal().toString(),
    );
  }
}
