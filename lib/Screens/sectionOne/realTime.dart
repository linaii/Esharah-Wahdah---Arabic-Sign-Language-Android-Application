import 'package:flutter/material.dart';
import 'package:adaptive_speech/Screens/sectionOne/run_model_by_camera_demo.dart';
import 'package:adaptive_speech/Screens/sectionOne/run_model_by_image_demo.dart';


Future<void> main() async {
  runApp(const RealTime());
}

class RealTime extends StatefulWidget {
  static String routeName = "/RealTime";
  const RealTime({Key? key}) : super(key: key);

  @override
  _RealTime createState() => _RealTime();
}

class _RealTime extends State<RealTime> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WillPopScope(
        onWillPop: () async {
          // Handle the back button press
          Navigator.pop(context);
          return true;
        },
        child: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(100),
              child: AppBar(
                centerTitle: true,
                automaticallyImplyLeading: false,
                backgroundColor: const Color.fromRGBO(56, 60, 90, 1),
                elevation: 1.0,
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
                  'لغة إشارة إلى نص',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
                bottom: TabBar(
                  indicatorColor: Color(0xFF2196F3),
                  tabs: [
                    Tab(text: "الالتقاط المباشر"),
                    Tab(text: "ألبوم الكاميرا"),
                  ],
                ),
              ),
            ),
            body: TabBarView(
              children: [
                RunModelByCameraDemo(),
                RunModelByImageDemo(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
