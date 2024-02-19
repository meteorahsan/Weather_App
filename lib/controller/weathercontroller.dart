import 'package:get/get.dart';
import 'package:weather/weather.dart';

class Weathercontroller extends GetxController {
  double lat = 0, long = 0;
  updatelat(lt) {
    lat = lt;
    update();
  }

  updatestate(st) {
    state = st;
    update();
  }

  DateTime selecteddate = DateTime.now();
  updatedate(dt) {
    selecteddate = dt;
    update();
  }

  List<dynamic> currentPlaceList = [];
  updateplaces(dt) async {
    currentPlaceList = dt;
    update();
  }

  AppState state = AppState.NOT_DOWNLOADED;

  WeatherFactory ws = WeatherFactory(key);
  static String key = 'd1f71324dc4fceb9460b25f15398f5c0';
  updatelong(lt) {
    long = lt;
    update();
  }

  List<Weather> data = [];
  updateweatherdata(dt) {
    data = dt;
    update();
  }

  bool dark = false;
  updatemode(d) {
    dark = d;
    update();
  }

  static Weathercontroller get i => Get.put(Weathercontroller());
}

enum AppState { NOT_DOWNLOADED, DOWNLOADING, FINISHED_DOWNLOADING }
