// ignore_for_file: prefer_const_constructors, file_names

import 'package:adaptive_speech/Screens/Cards/categories.dart';
import 'package:adaptive_speech/Screens/sectionOne/realTime.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/card/gf_card.dart';
import 'package:getwidget/getwidget.dart';
import 'package:adaptive_speech/Screens/sectionOne/realTime.dart';
import 'package:adaptive_speech/Screens/firstSection.dart';
import 'package:glass/glass.dart';


class getStarted extends StatefulWidget {
  const getStarted({super.key});
  // const getStarted({Key key}) : super(key: key);
  static String routeName = "/getStarted";
  @override
  _getStartedState createState() => _getStartedState();
}

class _getStartedState extends State<getStarted> {
  @override
  Widget build(BuildContext context) {
    // String personType1 = 'Deaf';
    String personType2 = 'Normal';
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(70),
          child: AppBar(
            centerTitle: true,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            title: Text(
              "إختر من الخيارات",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
            ),
          ),
        ),
        backgroundColor: Color.fromRGBO(56, 60, 90, 1),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //////////////////////////////////////////////////////////////////////////////////////
              MouseRegion(
                onHover: (s){
                  // color:Colors.white;
                  

                },
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: ((context) => RealTime())),
                    );
                  },
                  child: Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            right: 20, left: 20, bottom: 20, top: 30),
                        child: Container(
                            width: 379.0,
                            height: 186.0,
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
                                  image: AssetImage('assets/categoryBtn.png')),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0)),
                              color: Colors.transparent,
                            ),
              
                            child: Padding(
                              padding: EdgeInsets.only(top: 135),
                              child: Text(
                                'لغة إشارة إلى نص ',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 24,
                                ),
                              ),
                            )

                            ),
                      ),
                      Center(
                        child: Container(
                          height: 156,
                          width: 159,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage(
                                'assets/firstSection.png',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              //////////////////////////////////////////////////////////////////////////////////////
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, SpeechScreen.routeName);
                },
                child: Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          right: 20, left: 20, bottom: 20, top: 30),
                      child: Container(
                          width: 379.0,
                          height: 186.0,
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
                                image: AssetImage('assets/categoryBtn.png')),
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
                            color: Colors.transparent,
                          ),


                          child: Padding(
                            padding: EdgeInsets.only(top: 135),
                            child: Text(
                              'نص أو صوت إلى لغة إشارة',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 24,
                              ),
                            ),
                          )

                          ),
                    ),
                    Center(
                      child: Container(
                        height: (167),
                        width: (176),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage(
                              'assets/secondSection.png',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              //////////////////////////////////////////////////////////////////////////////////////
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => categoriesState(),
                    ),
                  );
                },
                child: Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          right: 20, left: 20, bottom: 20, top: 30),
                      child: Container(
                          width: 379.0,
                          height: 186.0,
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
                                image: AssetImage('assets/categoryBtn.png')),
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
                            color: Colors.transparent,
                          ),

                          child: Padding(
                            padding: EdgeInsets.only(top: 135),
                            child: Text(
                              'معجم',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 24,
                              ),
                            ),
                          )

                          ),
                    ),
                    Center(
                      child: Container(
                        height: 151,
                        width: 176,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage(
                              'assets/thirdSection.png',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
