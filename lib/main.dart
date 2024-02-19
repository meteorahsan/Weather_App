import 'dart:developer';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:weatherforecast/controller/weathercontroller.dart';
import 'package:weatherforecast/repositories/weatherrepo.dart';
import 'package:weatherforecast/utils/colors.dart';
import 'package:weatherforecast/utils/images.dart';
import 'package:weatherforecast/utils/toaster.dart';
import 'package:weatherforecast/widgets/contentwidgets.dart';

import 'package:weatherforecast/widgets/googlemaps.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Widget _resultView(ctx) =>
      Weathercontroller.i.state == AppState.FINISHED_DOWNLOADING
          ? contentFinishedDownload(ctx)
          : Weathercontroller.i.state == AppState.DOWNLOADING
              ? contentDownloading()
              : contentNotDownloaded();
  getweatherdata() async {
    WeatherRepo.getcurrentlocation();
  }

  static BuildContext? cntx;
  @override
  Widget build(BuildContext context) {
    cntx = context;
    final ctr = Get.put(Weathercontroller());
    getweatherdata();
    return AdaptiveTheme(
      debugShowFloatingThemeButton: true,
      light: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.amber,
      ),
      dark: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.amber,
        primaryIconTheme: const IconThemeData(color: Colors.white),
      ),
      initial: AdaptiveThemeMode.light,
      builder: (theme, darkTheme) => GetMaterialApp(
        theme: theme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(Images.backgroundiamge),
              ),
            ),
            child: GetBuilder<Weathercontroller>(builder: (cnt) {
              return Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  title: const Text('Weather App'),
                  actions: [
                    IconButton(
                        onPressed: () async {
                          await Get.to(() => GoogleMapsScreen(
                                lat: Weathercontroller.i.lat,
                                long: Weathercontroller.i.long,
                              ));
                          WeatherRepo.queryForecast();
                        },
                        icon: const Icon(Icons.search)),
                  ],
                ),
                backgroundColor: Colors.transparent,
                body: Column(
                  children: <Widget>[
                    Expanded(
                      child: _resultView(context),
                    )
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
// class MyApp extends StatelessWidget {

//   MyApp({super.key});
// }
