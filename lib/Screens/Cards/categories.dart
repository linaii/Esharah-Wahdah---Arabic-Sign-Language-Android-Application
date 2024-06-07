// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:adaptive_speech/Screens/Cards/cardsmodelnormal.dart';
import 'package:adaptive_speech/Screens/Cards/mydata.dart';

class categoriesState extends StatelessWidget {
  static String routeName = "/categoriesState";
  var data = mydate();
  static List categList = [
    'أرقام',
    'حروف',
    'أماكن',
    'حروف جر',
    'المرور والنقل',
    'اتجاهات',
    'التحية',
    'الكميات',
  ];
  List imagesData = [
    'assets/numbers.png',
    'assets/alphabet.png',
    'assets/places.png',
    "assets/preposition.png",
    'assets/transport.png',
    'assets/directions.png',
    'assets/greet.png',
    'assets/quantities.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          actions: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.3),
                    spreadRadius: 0.0,
                    blurRadius: 5.0,
                    offset: Offset(1.0, 1.0),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage("assets/backBtn.png"),
                backgroundColor: Colors.transparent,
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_forward,
                    color: const Color.fromARGB(255, 255, 255, 255),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),

          ],
          title:
              Text(
            " معجم ",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 255, 255, 255),
            ),
          ),
        ),
      ),
      backgroundColor: const Color.fromRGBO(56, 60, 90, 1),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: 
        GridView.builder(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 350,
                childAspectRatio: 2.5 / 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 30),
            itemCount: categList.length,
            itemBuilder: (BuildContext ctx, index) {
              return InkWell(
                onTap: () {
                  if (categList[index] == 'أرقام') {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                CardsModelNormal(data.familyDate)));
                  } else if (categList[index] == 'حروف') {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                CardsModelNormal(data.expressionData)));
                  } else if (categList[index] == 'أماكن') {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                CardsModelNormal(data.placesDate)));
                  } else if (categList[index] == 'حروف جر') {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                CardsModelNormal(data.timeDate)));
                  } else if (categList[index] == 'المرور والنقل') {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                CardsModelNormal(mydate().requestsDate)));
                  } else if (categList[index] == 'اتجاهات') {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                CardsModelNormal(mydate().foodData)));
                  } else if (categList[index] == 'التحية') {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                CardsModelNormal(mydate().feelingDate)));
                  } else if (categList[index] == 'الكميات') {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                CardsModelNormal(mydate().clothesDate)));
                  }
                },
                customBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                splashColor: Color.fromARGB(112, 125, 223, 247),
                highlightColor: Color.fromARGB(111, 56, 60, 90),
                child: Ink(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.3),
                        spreadRadius: 0.0,
                        blurRadius: 10.0,
                        offset: Offset(10.0, 10.0),
                      ),
                    ],
                    image: DecorationImage(
                      
                        fit: BoxFit.cover,
                        image: AssetImage('assets/dictBtn.png')),
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    color: Colors.transparent,
                  ),
                  child: Column(
                    children: [
                      Image.asset(
                        imagesData[index],
                      ),
                      Text(
                        categList[index],
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 24,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}
