import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gloucester_weather_app/models/weather_model.dart';
import 'package:gloucester_weather_app/services/weather_service.dart';
import 'package:lottie/lottie.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _weatherService = WeatherService(dotenv.env['OWM_API_KEY'] ?? '');
  Weather? _weather;

  // fetch weather data
  Future<void> _fetchWeather() async {
    try {
      String cityName = await _weatherService.getCurrentCity();
      Weather weather = await _weatherService.fetchWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print('Error fetching weather: $e');
    }
  }

  // weather animations
  String getAnimationNightOrDayWhenClear() {
    final hour = DateTime.now().hour;
    if (hour >= 6 && hour < 18) {
      return 'assets/sunny.json';
    } else {
      return 'assets/night.json';
    }
  }

  String getWeatherAnimation(String condition) {
    if (condition.isEmpty) return 'assets/sunny.json';
    switch (condition.toLowerCase()) {
      case 'clear':
        return getAnimationNightOrDayWhenClear();
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/cloudy.json';
      case 'rain':
      case 'drizzle':
      case 'show rain':
        return 'assets/rainy.json';
      case 'thunderstorm':
        return 'assets/stormy.json';
      case 'snow':
        return 'assets/snowy.json';
      default:
        return getAnimationNightOrDayWhenClear();
    }
  }

  // init state
  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  @override
  Widget build(BuildContext) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _weather?.cityName ?? 'Loading...',
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
            Text(
              _weather?.temperature != null
                  ? '${_weather?.temperature.round().toString()}°F'
                  : '',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            Lottie.asset(
              getWeatherAnimation(_weather?.mainCondition ?? ''),
              width: 200,
              height: 200,
              fit: BoxFit.fill,
            ),
            Text(
              _weather?.mainCondition ?? '',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
