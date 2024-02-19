import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:weather/weather.dart';
import 'package:weatherforecast/controller/weathercontroller.dart';
import 'package:weatherforecast/repositories/maps.dart';
import 'package:weatherforecast/utils/colors.dart';
import 'package:weatherforecast/utils/toaster.dart';

class GoogleMapsScreen extends StatelessWidget {
  final double lat;
  final double long;
  GoogleMapsScreen({super.key, required this.lat, required this.long});
  final Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: AppBar(
            title: const Text("Search Places"),
          )),
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: Stack(
          children: [
            SizedBox(
              height: Get.height * 0.02,
            ),
            SizedBox(
                height: Get.height * 0.8,
                child: GoogleMap(
                  // myLocationEnabled: true,

                  initialCameraPosition:
                      CameraPosition(target: LatLng(lat, long), zoom: 14),
                  mapType: MapType.normal,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  zoomControlsEnabled: false,

                  onMapCreated: (controller) async {
                    final GoogleMapController controller =
                        await _controller.future;
                    controller.animateCamera(CameraUpdate.newCameraPosition(
                        CameraPosition(
                            target: LatLng(Weathercontroller.i.lat,
                                Weathercontroller.i.long),
                            zoom: 14)));
                  },
                )),
            GetBuilder<Weathercontroller>(builder: (cnt) {
              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          onChanged: (value) async {
                            cnt.updateplaces(
                                await Googlemapsrepo().getSuggestion(value));
                          },
                          decoration:
                              const InputDecoration(hintText: "Enter Address"),
                        ),
                      ),
                    ],
                  ),
                  ListView.builder(
                      itemCount: cnt.currentPlaceList.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return InkWell(
                            onTap: () async {
                              if (cnt.currentPlaceList.isNotEmpty) {
                                List<Location> lst = await locationFromAddress(
                                    cnt.currentPlaceList[index]['description']);
                                if (lst.isNotEmpty) {
                                  Weathercontroller.i
                                      .updatelat(lst.first.latitude);
                                  Weathercontroller.i
                                      .updatelong(lst.first.longitude);
                                  Get.back();
                                } else {
                                  Toaster.showtoast(
                                      "No Location Found", ColorManager.red);
                                }
                              } else {
                                Toaster.showtoast(
                                    "No Location Found", ColorManager.red);
                              }
                            },
                            child: Container(
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  cnt.currentPlaceList[index]['description'],
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ));
                      })
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
