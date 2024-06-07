import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pytorch_lite/pytorch_lite.dart';

import 'camera_view_singleton.dart';

/// [CameraView] sends each frame for inference
class CameraView extends StatefulWidget {
  /// Callback to pass results after inference to [HomeView]
  final Function(
          List<ResultObjectDetection> recognitions, Duration inferenceTime)
      resultsCallback;
  final Function(String classification, Duration inferenceTime)
      resultsCallbackClassification;

  /// Constructor
  const CameraView(this.resultsCallback, this.resultsCallbackClassification,
      {Key? key})
      : super(key: key);
  @override
  _CameraViewState createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> with WidgetsBindingObserver {
  /// List of available cameras
  late List<CameraDescription> cameras;

  /// Controller
  CameraController? cameraController;

  /// true when inference is ongoing
  bool predicting = false;

  /// true when inference is ongoing
  bool predictingObjectDetection = false;

  ModelObjectDetection? _objectModel;
  // ClassificationModel? _imageModel;
  
  // bool classification = false;
  int _camFrameRotation = 0;
  String errorMessage = "";
  bool _isBackCamera = true; // Variable to track camera direction

  @override
  void initState() {
    super.initState();
    initStateAsync();
  }
 
  //load your model
  Future loadModel() async {
    String pathObjectDetectionModel = "assets/models/Lastbest.torchscript";
    try {
      _objectModel = await PytorchLite.loadObjectDetectionModel(
          pathObjectDetectionModel, 8, 640, 640,
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

  void initStateAsync() async {
    WidgetsBinding.instance.addObserver(this);
    await loadModel();

    // Camera initialization
    try {
      initializeCamera();
    } on CameraException catch (e) {
      switch (e.code) {
        case 'CameraAccessDenied':
          errorMessage = ('You have denied camera access.');
          break;
        case 'CameraAccessDeniedWithoutPrompt':
          // iOS only
          errorMessage = ('Please go to Settings app to enable camera access.');
          break;
        case 'CameraAccessRestricted':
          // iOS only
          errorMessage = ('Camera access is restricted.');
          break;
        case 'AudioAccessDenied':
          errorMessage = ('You have denied audio access.');
          break;
        case 'AudioAccessDeniedWithoutPrompt':
          // iOS only
          errorMessage = ('Please go to Settings app to enable audio access.');
          break;
        case 'AudioAccessRestricted':
          // iOS only
          errorMessage = ('Audio access is restricted.');
          break;
        default:
          errorMessage = (e.toString());
          break;
      }
      setState(() {});
    }
    // Initially predicting = false
    setState(() {
      predicting = false;
    });
  }

  /// Initializes the camera by setting [cameraController]
  void initializeCamera() async {
    cameras = await availableCameras();

    var idx =
        cameras.indexWhere((c) => c.lensDirection == CameraLensDirection.back);
    if (idx < 0) {
      log("No Back camera found - weird");
      return;
    }

    var desc = cameras[idx];
    _camFrameRotation = Platform.isAndroid ? desc.sensorOrientation : 0;
    // cameras[0] for rear-camera
    cameraController = CameraController(desc, ResolutionPreset.high,
        imageFormatGroup: Platform.isAndroid
            ? ImageFormatGroup.yuv420
            : ImageFormatGroup.bgra8888,
        enableAudio: false);

    cameraController?.initialize().then((_) async {
      // Stream of image passed to [onLatestImageAvailable] callback
      await cameraController?.startImageStream(onLatestImageAvailable);

      /// previewSize is size of each image frame captured by controller
      ///
      /// 352x288 on iOS, 240p (320x240) on Android with ResolutionPreset.low
      Size? previewSize = cameraController?.value.previewSize;

      /// previewSize is size of raw input image to the model
      CameraViewSingleton.inputImageSize = previewSize!;

      // the display width of image on screen is
      // same as screenWidth while maintaining the aspectRatio
      Size screenSize = MediaQuery.of(context).size;
      CameraViewSingleton.screenSize = screenSize;
      CameraViewSingleton.ratio = cameraController!.value.aspectRatio;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Return empty container while the camera is not initialized
    if (cameraController == null || !cameraController!.value.isInitialized) {
      return Container();
    }
    return Stack(
      children: [
        CameraPreview(cameraController!),
        
      ],
    );
  }
  void _toggleCameraDirection() async {
    if (predicting || cameraController == null) {
      return;
    }
    predicting =
        true; // Set predicting to true to prevent toggling while camera is in use

    // Dispose current camera controller
    await cameraController!.dispose();

    // Toggle between front and back cameras
    _isBackCamera = !_isBackCamera;

    // Initialize new camera controller with the toggled camera
    cameraController = CameraController(
      cameras[_isBackCamera ? 0 : 1], // 0 for back camera, 1 for front camera
      ResolutionPreset.high,
    );

    // Initialize the new camera controller
    await cameraController!.initialize();

    // Start streaming images from the new camera
    await cameraController!.startImageStream(onLatestImageAvailable);

    // Set predicting back to false after camera initialization
    predicting = false;
  }
  Future<void> runObjectDetection(CameraImage cameraImage) async {
    if (predictingObjectDetection) {
      return;
    }
    if (!mounted) {
      return;
    }

    setState(() {
      predictingObjectDetection = true;
    });
    if (_objectModel != null) {
      // Start the stopwatch
      Stopwatch stopwatch = Stopwatch()..start();

      List<ResultObjectDetection> objDetect =
          await _objectModel!.getCameraImagePrediction(
        cameraImage,
        _camFrameRotation,
        minimumScore: 0.3,
        iOUThreshold: 0.3,
      );

      // Stop the stopwatch
      stopwatch.stop();
      print("-------------------------------------------------------data outputted ");
      widget.resultsCallback(objDetect, stopwatch.elapsed);
    }
    if (!mounted) {
      return;
    }

    setState(() {
      predictingObjectDetection = false;
    });
  }

  /// Callback to receive each frame [CameraImage] perform inference on it
  onLatestImageAvailable(CameraImage cameraImage) async {
    // Make sure we are still mounted, the background thread can return a response after we navigate away from this
    // screen but before bg thread is killed
    if (!mounted) {
      return;
    }

    // log("will start prediction");
    // log("Converted camera image");

    // runClassification(cameraImage);
    runObjectDetection(cameraImage);

    // log("done prediction camera image");
    // Make sure we are still mounted, the background thread can return a response after we navigate away from this
    // screen but before bg thread is killed
    if (!mounted) {
      return;
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (!mounted) {
      return;
    }
    switch (state) {
      case AppLifecycleState.paused:
        cameraController?.stopImageStream();
        break;
      case AppLifecycleState.resumed:
        if (!cameraController!.value.isStreamingImages) {
          await cameraController?.startImageStream(onLatestImageAvailable);
        }
        break;
      default:
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    cameraController?.dispose();
    super.dispose();
  }
}
