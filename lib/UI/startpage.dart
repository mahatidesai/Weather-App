import 'package:flutter/material.dart';

import '../Models/Constants.dart';
import 'Welcome.dart';

class startpage extends StatelessWidget
{
  const startpage({super.key});

  @override
  Widget build(BuildContext context) {

    Constants con = Constants();
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration:BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: con.grad,
          )
        ),
        height: size.height,
        width: size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
              InkWell(
                onTap: (){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const Welcome()));
                },
                child: Material(
                  elevation: 40,
                  shape: const CircleBorder(),
                  shadowColor: Colors.black87,
                  child: Image.asset('assets/weather.png'),
                ),
              ),
          ],
        )
      )
    );
  }
}