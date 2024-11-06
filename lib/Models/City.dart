import 'dart:convert';
import 'package:http/http.dart' as http;

class City {
  bool isSelected;
  final String city;
  final String country;
  final bool isDefault;
  final String country_name;

  City({
    required this.isSelected,
    required this.city,
    required this.country,
    required this.isDefault,
    required this.country_name,
  });

  static List<City> citiesList = [];
  static Map<String,dynamic> citiesListMap = {};
  static Future<void> fetchCityData() async {
    final response =
    await http.get(Uri.parse("https://countriesnow.space/api/v0.1/countries"));
    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      for (var country in data) {
        final iso2 = country['iso2'];
        final countryName = country['country'];
        for (var city in country['cities']) {
          citiesList.add(
            City(
              isSelected: false,
              city: city,
              country: iso2,
              isDefault: false,
              country_name: countryName,
            ),
          );
        }
      }
    } else {
      throw Exception("Failed to load city data");
    }
  }

  // Get the selected cities
  static List<City> getSelectedCities() {
    return citiesList.where((city) => city.isSelected == true).toList();
  }
}
