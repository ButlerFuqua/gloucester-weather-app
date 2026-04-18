# gloucester_weather_app

A small weather app built as a Flutter refresher — the main point was to get something working quickly and knock the rust off.

## What it does

Grabs your current location, resolves it to a city, and shows the temperature and conditions from OpenWeatherMap with a matching Lottie animation (sunny/night/cloudy/rainy/stormy/snowy).

## Stack

- Flutter (SDK `^3.11.4`)
- `http` for the OpenWeatherMap API
- `geolocator` + `geocoding` for device location → city name
- `lottie` for the weather animations

## Running it

```bash
flutter pub get
flutter run
```

The OpenWeatherMap API key is currently hardcoded in [lib/pages/weather_page.dart](lib/pages/weather_page.dart) — fine for a practice project, but would be moved out for anything real.
