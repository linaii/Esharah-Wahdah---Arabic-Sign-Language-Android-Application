// ignore_for_file: file_names

import 'package:adaptive_speech/OnBoarding/components/title.dart';
import 'package:flutter/material.dart';
import 'package:adaptive_speech/Screens/getStarted.dart';
import 'package:dots_indicator/dots_indicator.dart';

// This is the best practice
import '../../../components/default_button.dart';

class Body extends StatefulWidget {
  const Body({super.key, required buttonText});

  // const Body({Key key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  double currentPage = 0;
  List<Map<String, String>> splashData = [
    // { "image": "assets/logo.png"},
    {
      "head": "لغة اشارة الى نص",
      "image": "assets/firstSection.png",
      "text": "التعرف على إيماءات لغة الإشارة وتحويلها إلى نص",
    },
    {
      "head": "نص او صوت الى لغة اشارة",
      "image": "assets/secondSection.png",
      "text":
          "تحويل النص المكتوب أو المنطوق إلى لغة إشارة بأشكال بصرية وإيمائية",
    },
    {
      "head": "معجم",
      "image": "assets/thirdSection.png",
      "text":
          "قاموس لغة الإشارة هو مورد يوفر مجموعة من الإشارات ومعانيها المقابلة في لغة الإشارة",
    },
  ];

  // List onboardingtitleList = [
  //   'لغة اشارة الى نص',
  //   'نص او صوت الى لغة اشارة',
  //   'معجم',

  // ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: PageView.builder(
                // controller:
                //  controller,
                onPageChanged: (value) {
                  setState(() {
                    currentPage = value.toDouble();
                  });
                },
                itemCount: splashData.length,
                itemBuilder: (context, index) => TitleHead(
                  head: splashData[index]["head"],
                  text: splashData[index]['text'],
                  image: splashData[index]["image"],
                  btnText: splashData[index]["btnText"],
                  // head: onboardingtitleList[index]
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                children: <Widget>[
                  Spacer(flex: 4),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    DotsIndicator(
                      reversed: true,
                      dotsCount: 3,
                      position: currentPage,
                      decorator: DotsDecorator(
                        spacing: const EdgeInsets.all(3.0),
                        activeColor: Color.fromRGBO(33, 150, 243, 1),
                        color: Colors.white,
                        size: const Size.square(7.0),
                        activeSize: const Size(20, 7),
                        activeShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3.0)),
                      ),
                    )
                  ]),
                  Spacer(flex: 4),
                  DefaultButton(
                    // text: ,
                    height: 55,
                    width: 342,
                    text: 'إبدأ رحلتك',
                    // btnText,
                    press: () {
                      Navigator.pushNamed(context, getStarted.routeName);
                    },
                  ),
                  Spacer(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // AnimatedContainer buildDot({required int index}) {
  //   return AnimatedContainer(
  //     duration: const Duration(milliseconds: 50),
  //     margin: EdgeInsets.only(right: 5, bottom: 0),
  //     height: 7,
  //     width: currentPage == index ? 20 : 6,
  //     decoration: BoxDecoration(
  //       color: currentPage == index?  Color.fromRGBO(33, 150, 243, 1)
  //           : Color(0xFFFFFFFF) ,
  //       borderRadius: BorderRadius.circular(3),
  //     ),
  //   );

  // }
}
