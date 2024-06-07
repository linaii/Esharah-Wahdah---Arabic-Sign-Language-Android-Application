
import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:adaptive_speech/Screens/Cards/model.dart';
import 'package:adaptive_speech/Screens/Cards/categories.dart';
import 'package:connectivity/connectivity.dart';
class CardsModelNormal extends StatelessWidget {
  final model data;

  CardsModelNormal(this.data);

  @override
  Widget build(BuildContext context) {
    final FlutterTts flutterTts = FlutterTts();

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
          title: Text(
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
      body: FutureBuilder(
        future: Connectivity().checkConnectivity(),
        builder:
            (BuildContext context, AsyncSnapshot<ConnectivityResult> snapshot) {
          if (snapshot.hasData && snapshot.data == ConnectivityResult.none) {
            // No internet connection
            return Center(
              child: Text(
                'الرجاء التحقق من اتصال الانترنت الخاص بك',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            );
          } else {
            return Padding(
              padding: EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 350,
                  childAspectRatio: 2.5 / 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 30,
                ),
                itemCount: data.cardsname.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    child: FlipCard(
                      front: Card(
                        color: Color.fromRGBO(56, 60, 90, 1),
                        elevation: 0,
                        shape: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                        child: Container(
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
                              image: AssetImage('assets/dictBtn.png'),
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
                            color: Color.fromRGBO(56, 60, 90, 1),
                          ),
                          child: Center(
                            child: InkWell(
                              onTap: () async {
                                await flutterTts.speak(data.cardsname[index]);
                              },
                              child: Text(
                                data.cardsname[index],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      back: Card(
                        elevation: 0,
                        color: Color.fromRGBO(56, 60, 90, 1),
                        shape: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                        child: Container(
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
                              image: NetworkImage(
                                data.src[index],
                              ),
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
                            color: Colors.transparent,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}

