import 'package:geolocator/geolocator.dart';
import 'package:weather/weather.dart';
import 'package:weatherforecast/controller/weathercontroller.dart';

class WeatherRepo {
  static getweatherdata() async {
    List<Weather> forecasts = await Weathercontroller.i.ws
        .fiveDayForecastByLocation(
            Weathercontroller.i.lat, Weathercontroller.i.long);
    Weathercontroller.i.updateweatherdata(forecasts);
  }

  void queryWeather() async {
    /// Removes keyboard

    // log("data is+${_markers.first.position}");
    Weather weather = await Weathercontroller.i.ws.currentWeatherByLocation(
        Weathercontroller.i.lat, Weathercontroller.i.long);

    Weathercontroller.i.updateweatherdata([weather]);
  }

  static getcurrentlocation() {
    getUserCurrentLocation().then((value) async {
      Weathercontroller.i.updatelat(value.latitude);
      Weathercontroller.i.updatelong(value.longitude);
      queryForecast();
    });
  }

  static queryForecast() async {
    Weathercontroller.i.updatestate(AppState.DOWNLOADING);
    await getweatherdata();
    Weathercontroller.i.updatestate(AppState.FINISHED_DOWNLOADING);
  }

  static Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      // print("ERROR$error");
    });
    return await Geolocator.getCurrentPosition();
  }
}
