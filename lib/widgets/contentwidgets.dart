import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';
import 'package:weatherforecast/controller/weathercontroller.dart';
import 'package:weatherforecast/utils/colors.dart';

Widget contentFinishedDownload(ctx) {
  return GetBuilder<Weathercontroller>(builder: (cnt) {
    var count = Weathercontroller.i.data
        .where((c) =>
            c.date?.toString().split(' ')[0] ==
            Weathercontroller.i.selecteddate.toString().split(' ')[0])
        .length;

    Weather weather = Weathercontroller.i.data.firstWhere((element) =>
        element.date?.toString().split(' ')[0] ==
        Weathercontroller.i.selecteddate.toString().split(' ')[0]);
    return Center(
      child: Column(
        children: [
          SizedBox(
            height: Get.height * 0.28,
            width: Get.width * 0.82,
            child: Card(
              color: ColorManager.cardcolor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () async {
                      List<DateTime> uniqueList = [];
                      for (var v in Weathercontroller.i.data) {
                        if (!uniqueList.contains(
                            DateTime.parse(v.date.toString().split(' ')[0]))) {
                          uniqueList.add(
                              DateTime.parse(v.date.toString().split(' ')[0]));
                        }
                      }
                      await showDialog(
                        context: ctx,
                        builder: (context) {
                          return StatefulBuilder(
                            builder: (context, setState) {
                              return AlertDialog(
                                content: SizedBox(
                                  height: Get.height * 0.3,
                                  width: Get.width * 0.8,
                                  child: Center(
                                    child: ListView.builder(
                                        padding: const EdgeInsets.all(0),
                                        shrinkWrap: true,
                                        itemCount: uniqueList.length,
                                        itemBuilder: (xtc, index) {
                                          return InkWell(
                                            onTap: () {
                                              Weathercontroller.i.updatedate(
                                                  DateTime.parse(
                                                      uniqueList[index]
                                                          .toString()
                                                          .split(' ')[0]));
                                              Navigator.pop(context);
                                            },
                                            child: Center(
                                              child: Text(
                                                uniqueList[index]
                                                    .toString()
                                                    .split(' ')[0],
                                                style: TextStyle(
                                                    color:
                                                        ColorManager.textColor,
                                                    fontSize: 26),
                                              ),
                                            ),
                                          );
                                        }),
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text("Cancel"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Weathercontroller.i.data.first.date
                                    ?.toString()
                                    .split(' ')[0] !=
                                Weathercontroller.i.selecteddate
                                    .toString()
                                    .split(' ')[0]
                            ? Text(
                                Weathercontroller.i.selecteddate
                                    .toString()
                                    .split(' ')[0],
                                style: TextStyle(
                                  color: ColorManager.textColor,
                                  fontSize: 20,
                                ),
                              )
                            : Text(
                                "Today",
                                style: TextStyle(
                                  color: ColorManager.textColor,
                                  fontSize: 20,
                                ),
                              ),
                        SizedBox(
                          width: Get.width * 0.02,
                        ),
                        const Icon(Icons.arrow_drop_down)
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      weather.weatherIcon != null
                          ? Image.network(
                              "http://openweathermap.org/img/w/${Weathercontroller.i.data.first.weatherIcon!}"
                              ".png",
                            )
                          : const SizedBox.shrink(),
                      SizedBox(
                        width: Get.width * 0.04,
                      ),
                      Text(
                        "${weather.temperature}°",
                        style: TextStyle(
                          color: ColorManager.textColor,
                          fontSize: 32,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "${weather.weatherDescription?.toString().split(' ')[0]}",
                    style: TextStyle(
                      color: ColorManager.textColor,
                      fontSize: 22,
                    ),
                  ),
                  Text(
                    "${weather.areaName}",
                    style: TextStyle(
                      color: ColorManager.textColor,
                      fontSize: 22,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Feels Like ${weather.tempFeelsLike?.toString().split(' ')[0]}°",
                        style: TextStyle(
                          color: ColorManager.textColor,
                          fontSize: 22,
                        ),
                      ),
                      weather.sunrise != null
                          ? SizedBox(
                              width: Get.width * 0.04,
                            )
                          : const SizedBox.shrink(),
                      weather.sunrise != null
                          ? Text(
                              "Sunset ${weather.sunrise?.toString().split(' ')[0] ?? ""}",
                              style: TextStyle(
                                color: ColorManager.textColor,
                                fontSize: 22,
                              ),
                            )
                          : const SizedBox.shrink(),
                    ],
                  ),
                  Text(
                    "Wind Speed ${weather.windSpeed}",
                    style: TextStyle(
                      color: ColorManager.textColor,
                      fontSize: 22,
                    ),
                  ),
                  Text(
                    "Humidity ${weather.humidity}",
                    style: TextStyle(
                      color: ColorManager.textColor,
                      fontSize: 22,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: Get.height * 0.02,
          ),
          Container(
              height: Get.height * 0.2,
              width: Get.width * 0.8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: RadialGradient(
                  colors: [
                    ColorManager.radialleftop.withOpacity(0.9),
                    ColorManager.radialrightbottom.withOpacity(0.5)
                  ],
                ),
              ),
              child: GridView.builder(
                padding: const EdgeInsets.all(0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4),
                itemBuilder: (_, ind) => Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(DateFormat('hh:mm a').format(DateTime.parse(
                        "${Weathercontroller.i.data[ind].date}"))),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Weathercontroller.i.data[ind].weatherIcon != null
                            ? Image.network(
                                "http://openweathermap.org/img/w/${Weathercontroller.i.data[ind].weatherIcon!}"
                                ".png",
                                height: Get.height * 0.05,
                              )
                            : const SizedBox.shrink(),
                        Text(
                          "${Weathercontroller.i.data[ind].tempFeelsLike?.toString().split(' ')[0]}°",
                          style: TextStyle(
                            color: ColorManager.textColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                itemCount: count,
              )),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Description",
                style: TextStyle(
                  color: ColorManager.white,
                  fontSize: 22,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                weather.weatherDescription ?? "",
                style: TextStyle(
                  color: ColorManager.white,
                  fontSize: 22,
                ),
              ),
            ),
          )
        ],
      ),
    );
  });
}

Widget contentDownloading() {
  return Container(
    margin: const EdgeInsets.all(25),
    child: Column(children: [
      const Text(
        'Fetching Weather...',
        style: TextStyle(fontSize: 20),
      ),
      Container(
          margin: const EdgeInsets.only(top: 50),
          child: const Center(child: CircularProgressIndicator(strokeWidth: 5)))
    ]),
  );
}

Widget contentNotDownloaded() {
  return const Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Wait...',
        ),
      ],
    ),
  );
}
