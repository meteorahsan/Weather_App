import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

class Googlemapsrepo {
  String sessionTOKEN = '1223344';
  List<dynamic> currentPlaceList = [];
  getSuggestion(String query) async {
    String kplacesApiKey = 'AIzaSyDSsTtjvdKipkgZ4s0zYp2tMRVQlAfHsKA';
    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request =
        '$baseURL?input=$query&key=$kplacesApiKey&sessiontoken=$sessionTOKEN';
    var response = await http.get(Uri.parse(request));

    try {
      if (response.statusCode == 200) {
        currentPlaceList = jsonDecode(response.body.toString())['predictions'];
        return currentPlaceList;
      } else {}
    } catch (e) {
      log(e.toString());
    }
  }
}
