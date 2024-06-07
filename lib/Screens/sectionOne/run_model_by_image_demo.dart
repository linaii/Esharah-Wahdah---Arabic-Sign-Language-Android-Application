import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:pytorch_lite/pytorch_lite.dart';

import '../../components/default_button.dart';

class RunModelByImageDemo extends StatefulWidget {
  const RunModelByImageDemo({Key? key}) : super(key: key);

  @override
  _RunModelByImageDemoState createState() => _RunModelByImageDemoState();
}

class _RunModelByImageDemoState extends State<RunModelByImageDemo> {
  late ModelObjectDetection _objectModelYoloV8;
  String? textToShow;
  List? _prediction;
  File? _image;
  final ImagePicker _picker = ImagePicker();
  bool objectDetection = false;
  List<ResultObjectDetection?> objDetect = [];
  @override
  void initState() {
    super.initState();
    loadModel();
  }

  //load your model
  Future loadModel() async {
    String pathObjectDetectionModelYolov8 =
        "assets/models/Lastbest.torchscript";
    try {
      _objectModelYoloV8 = await PytorchLite.loadObjectDetectionModel(
          pathObjectDetectionModelYolov8, 8, 640, 640,
          labelPath: "assets/labels/Lastlabels.txt",
          objectDetectionModelType: ObjectDetectionModelType.yolov8);
    } catch (e) {
      if (e is PlatformException) {
        print("only supported for android, Error is $e");
      } else {
        print("Error is $e");
      }
    }
  }

  Future runObjectDetectionYoloV8() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    Stopwatch stopwatch = Stopwatch()..start();

    objDetect = await _objectModelYoloV8.getImagePrediction(
        await File(image!.path).readAsBytes(),
        minimumScore: 0.1,
        iOUThreshold: 0.3);

    print('object executed in ${stopwatch.elapsed.inMilliseconds} ms');
    for (var element in objDetect) {
      print({
        "score": element?.score,
        "className": element?.className,
        "class": element?.classIndex,
        "rect": {
          "left": element?.rect.left,
          "top": element?.rect.top,
          "width": element?.rect.width,
          "height": element?.rect.height,
          "right": element?.rect.right,
          "bottom": element?.rect.bottom,
        },
      });
    }

    setState(() {
      //this.objDetect = objDetect;
      _image = File(image.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color.fromRGBO(56, 60, 90, 1),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: objDetect.isNotEmpty
                  ? _image == null
                      ? const Text(
                          'لم يتم تحديد أي صورة',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : _objectModelYoloV8.renderBoxesOnImage(
                          _image!, objDetect)
                  : _image == null
                      ? const Text(
                          'لم يتم تحديد أي صورة',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : Image.file(_image!),
            ),
            Center(
              child: Visibility(
                visible: textToShow != null,
                child: Text(
                  "$textToShow",
                  maxLines: 3,
                ),
              ),
            ),
        

            TextButton(
              onPressed: runObjectDetectionYoloV8,
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
                      image: AssetImage('assets/chooseImg.png')
                      ),
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  color: Colors.transparent,
                ),
                child: Center(
                  child: Text(
                    "اختر صورة",
                    style: const TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            Center(
              child: Visibility(
                visible: _prediction != null,
                child: Text(_prediction != null ? "${_prediction![0]}" : ""),
              ),
            )
          ],
        ),
      ),
    );
  }
}
