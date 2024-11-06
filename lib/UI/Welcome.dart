import 'package:flutter/material.dart';

import '../Models/City.dart';
import '../Models/Constants.dart';
import '../Models/texts.dart';
import 'Home.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  Constants con = Constants();
  List<City> cities = [];
  @override
  void initState() {
    super.initState();
    fetchCityData();
  }

  Future<void> fetchCityData() async {
    await City.fetchCityData();
    setState(() {
      cities =
          City.citiesList.where((city) => city.isDefault == false).toList();
      print(cities);
    });
  }

  @override
  Widget build(BuildContext context) {
    List<City> selectedCities = City.getSelectedCities();

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: texts("${selectedCities.length} Selected", 25),
          backgroundColor: con.grad.first,
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: con.grad)),
          child: cities.isNotEmpty
              ? ListView.builder(
                  itemCount: cities.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(
                          top: 8.0, bottom: 8.0, left: 15, right: 15),
                      child: Container(
                        height: 80,
                        decoration: BoxDecoration(
                          border: cities[index].isSelected == true
                              ? Border.all(color: Colors.white)
                              : Border.all(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: CircleAvatar(
                              radius: 18,
                              backgroundColor: Colors.white,
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    cities[index].isSelected =
                                        !cities[index].isSelected;
                                  });
                                },
                                child: CircleAvatar(
                                  radius: 11,
                                  backgroundColor:
                                      cities[index].isSelected == true
                                          ? con.grad.last
                                          : Colors.transparent,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          texts(
                              "${cities[index].city},${cities[index].country}",
                              26),
                        ]),
                      ),
                    );
                  },
                )
              : const SizedBox(
                  height: 100, // Specify the desired height
                  width: 100, // Specify the desired width
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ),
                ),
        ),
        floatingActionButton: SizedBox(
          height: 70,
          width: 70,
          child: FloatingActionButton(
            elevation: 10,
            backgroundColor: con.grad[1],
            shape: const CircleBorder(),
            onPressed: () {
              if (selectedCities.isNotEmpty) {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => const Home()));
              }
            },
            child: const Icon(
              Icons.location_on,
              size: 40,
              color: Colors.white,
            ),
          ),
        ));
  }
}
