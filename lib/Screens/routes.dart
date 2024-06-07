

import 'package:adaptive_speech/Screens/Cards/categories.dart';
import 'package:adaptive_speech/Screens/sectionOne/realTime.dart';
import 'package:adaptive_speech/OnBoarding/onBoard.dart';
import 'package:flutter/widgets.dart';
import 'package:adaptive_speech/Screens/getStarted.dart';
import 'getStarted.dart';
import 'package:adaptive_speech/Screens/firstSection.dart';
final Map<String, WidgetBuilder> routes = {
  OnBoardScreen.routeName: (context) => OnBoardScreen(),
  getStarted.routeName: (context) => getStarted(),
  RealTime.routeName: (context) =>RealTime(),
  SpeechScreen.routeName: (context) => SpeechScreen(),
  categoriesState.routeName: (context) =>categoriesState(),
};
