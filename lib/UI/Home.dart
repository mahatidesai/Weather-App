import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../Models/City.dart';
import '../Models/Constants.dart';
import '../Models/texts.dart';
import 'Welcome.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map<String, dynamic> weatherData = {};
  Map<String, dynamic> airQualityData = {};
  Map<String, dynamic> hourlyData = {};
  final apiKey = '1ed2e4fe308f02807fc17cadc5fb6f6e';
  late List<City> selectedCities;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    selectedCities = City.getSelectedCities();
    getWeatherData();
  }

  Future<Map<String, dynamic>> fetchWeather(String city) async {
    final response = await http.get(Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey"));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<Map<String, dynamic>> fetchAirQuality(double lat, double lon) async {
    final response = await http.get(Uri.parse(
        'http://api.openweathermap.org/data/2.5/air_pollution?lat=${lat
            .toString()}&lon=${lon.toString()}&appid=$apiKey'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to Load Air Quality Data');
    }
  }

  Future<Map<String, dynamic>> fetchHourlyForecast(String city) async {
    final response = await http.get(Uri.parse(
        "https://api.openweathermap.org/data/2.5/forecast?q=$city&cnt=24&appid=$apiKey"));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to Load Hourly Data');
    }
  }

  void getWeatherData() async {
    Map<String, dynamic> data = {};
    Map<String, dynamic> airQualityMap = {};
    Map<String, dynamic> hourly = {};

    for (var city in selectedCities) {
      try {
        // getting weather data
        var weather = await fetchWeather(city.city);
        data[city.city] = weather;

        // getting airQuality data
        var air = await fetchAirQuality(
            weather['coord']['lat'], weather['coord']['lon']);
        airQualityMap[city.city] = air;

        // getting the hourly data
        var hour = await fetchHourlyForecast(city.city);
        hourly[city.city] = hour;
      } catch (e) {
        print('Error fetching weather data for ${city.city}: $e');
      }
    }
    setState(() {
      weatherData = data;
      airQualityData = airQualityMap;
      hourlyData = hourly;
      isLoading = false;
    });
  }

  String getDescriptionAQI(int aqi) {
    switch (aqi) {
      case 1:
        return "(Good)";
      case 2:
        return "(Fair)";
      case 3:
        return "(Moderate)";
      case 4:
        return "(Poor)";
      case 5:
        return "(Very Poor)";
      default:
        return " ";
    }
  }

  String getIcon(String city) {
    var iconId = weatherData[city]['weather'][0]['icon'];
    return "https://openweathermap.org/img/wn/$iconId@2x.png";
  }

  String getHourlyIcon(String city) {
    var iconId = hourlyData[city]['list'][0]['weather'][0]['icon'];
    return "https://openweathermap.org/img/wn/$iconId@2x.png";
  }

  Constants con = Constants();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: con.grad.first,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              texts("Home", 25),
              InkWell(
                onTap: () =>
                    Navigator.pushReplacement(
                        context, MaterialPageRoute(
                        builder: (context) => const Welcome())),
                child: const Icon(Icons.add, color: Colors.white, size: 30),
              ),
            ],
          ),
        ),
        body: Container(
          alignment: Alignment.center,
          height: MediaQuery
              .of(context)
              .size
              .height,
          width: MediaQuery
              .of(context)
              .size
              .width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: con.grad,
            ),
          ),
          child: isLoading
              ? const Center(
            child: CircularProgressIndicator(color: Colors.white),
          )
              : weatherData.isNotEmpty &&
              airQualityData.isNotEmpty &&
              hourlyData.isNotEmpty
              ? ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: selectedCities.length,
            itemBuilder: (context, index) {
              var city = selectedCities[index];

              return Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 20.0),
                child: Container(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.5,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.9,
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    border: Border.all(
                        color: Colors.white, style: BorderStyle.solid),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 10),
                        location(city.city, city.country_name),
                        iconTemp(
                          getIcon(city.city),
                          '${weatherData[city.city]['main']['temp']}°F',
                          weatherData[city.city]['weather'][0]
                          ['description']
                              .toString(),
                        ),
                        texts(
                          "Feels like: ${weatherData[city
                              .city]['main']['feels_like']}°F",
                          18,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment:
                            CrossAxisAlignment.center,
                            children: [
                              MinMaxTemp(
                                "Min Temperature",
                                weatherData[city.city]['main']
                                ['temp_min']
                                    .toString()+"°F",
                              ),
                              MinMaxTemp(
                                "Max Temperature",
                                weatherData[city.city]['main']
                                ['temp_max']
                                    .toString()+"°F",
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: SizedBox(
                            height: 40,
                            width: double.infinity,
                            child: Column(
                              children: [
                                texts(
                                  "AQI: ${airQualityData[city
                                      .city]['list'][0]['main']['aqi']} ${getDescriptionAQI(
                                      airQualityData[city
                                          .city]['list'][0]['main']['aqi'])}",
                                  27,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: SizedBox(
                            height: MediaQuery
                                .of(context)
                                .size
                                .height *
                                0.32,
                            width: MediaQuery
                                .of(context)
                                .size
                                .width *
                                0.82,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 12,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    width: MediaQuery
                                        .of(context)
                                        .size
                                        .width *
                                        0.37,
                                    decoration: BoxDecoration(
                                      border:
                                      Border.all(color: Colors.white),
                                      borderRadius:
                                      BorderRadius.circular(2),
                                    ),
                                    child: hourlyIconTemp(
                                      getHourlyIcon(city.city),
                                      '${hourlyData[city
                                          .city]['list'][index]['dt_txt']}',
                                      '${hourlyData[city
                                          .city]['list'][index]['main']['temp']}°F',
                                      '${hourlyData[city
                                          .city]['list'][index]['weather'][0]['description']}',
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          )
              : const Center(
            child: Text(
              'No data available',
              style: TextStyle(color: Colors.white),
            ),
          ),
        )
    );
  }
}