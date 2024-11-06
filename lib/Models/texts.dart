import 'package:flutter/material.dart';

class texts extends StatelessWidget
{
  String txt;
  double txtsize;
  texts(
      this.txt,
      this.txtsize, {super.key}
      );
  @override
  Widget build(BuildContext context) {
    return Text(
      txt,
      style: TextStyle(
        color: Colors.white,
        fontSize: txtsize
      ),
    );

  }
}

class location extends StatelessWidget
{
  String city_name;
  String country;
  location(this.city_name, this.country, {super.key});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.location_on_outlined,
          color: Colors.white,
          size: 35,
        ),
        texts("$city_name, $country", 30),
      ],
    );
  }
}

class iconTemp extends StatelessWidget
{
  String iconUrl;
  String temperature;
  String description;
  iconTemp(this.iconUrl, this.temperature, this.description, {super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.network(iconUrl),
        texts('${description[0].toUpperCase()}${description.substring(1)}',28),
        texts(temperature, 30),
      ],
    );
  }
}

class hourlyIconTemp extends StatelessWidget
{
  String iconUrl;
  String datetime;
  String temperature;
  String description;
  hourlyIconTemp(
      this.iconUrl,
      this.datetime,
      this.temperature,
      this.description, {super.key}
      );
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        texts("Date: ${datetime.substring(0,10)}",15),
        texts("Time: ${datetime.substring(11)}",15),
        Image.network(iconUrl),
        texts(temperature, 20),
        texts('${description[0].toUpperCase()}${description.substring(1)}',15),


      ],

    );

  }
}

class MinMaxTemp extends StatelessWidget
{
  String temp_type;
  String temp;
  MinMaxTemp(this.temp_type, this.temp, {super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        texts(temp_type,18),
        texts(temp,18),
      ],
    );

  }
}