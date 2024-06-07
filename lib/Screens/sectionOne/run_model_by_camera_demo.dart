import 'package:flutter/material.dart';
import 'package:pytorch_lite/pytorch_lite.dart';
import 'package:adaptive_speech/Screens/sectionOne/ui/box_widget.dart';

import 'ui/camera_view.dart';

/// [RunModelByCameraDemo] stacks [CameraView] and [BoxWidget]s with bottom sheet for stats
class RunModelByCameraDemo extends StatefulWidget {
  const RunModelByCameraDemo({Key? key}) : super(key: key);

  @override
  _RunModelByCameraDemoState createState() => _RunModelByCameraDemoState();
}

class _RunModelByCameraDemoState extends State<RunModelByCameraDemo> {
  List<ResultObjectDetection>? results;
  Duration? objectDetectionInferenceTime;

  String? classification;
  Duration? classificationInferenceTime;

  /// Scaffold Key
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          // Camera View
          Center(
            child: CameraView(resultsCallback, resultsCallbackClassification)),
          // Bounding boxes
          boundingBoxes2(results),
        ],
      ),
    );
  }

  /// Returns Stack of bounding boxes
  Widget boundingBoxes2(List<ResultObjectDetection>? results) {
    if (results == null) {
      return Container();
    }
    return Stack(
      children: results.map((e) => BoxWidget(result: e)).toList(),
    );
  }

  void resultsCallback(
      List<ResultObjectDetection> results, Duration inferenceTime) {
    if (!mounted) {
      return;
    }
    setState(() {
      this.results = results;
      objectDetectionInferenceTime = inferenceTime;
      for (var element in results) {
        print({
          "rect": {
            "left": element.rect.left,
            "top": element.rect.top,
            "width": element.rect.width,
            "height": element.rect.height,
            "right": element.rect.right,
            "bottom": element.rect.bottom,
          },
        });
      }
    });
  }

  void resultsCallbackClassification(
      String classification, Duration inferenceTime) {
    if (!mounted) {
      return;
    }
    setState(() {
      this.classification = classification;
      classificationInferenceTime = inferenceTime;
    });
  }
}