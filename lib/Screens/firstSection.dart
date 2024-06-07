import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';

void main() {
  runApp(SpeechScreen());
}

class SpeechScreen extends StatefulWidget {
  static String routeName = "/SpeechScreen";
  @override
  _SpeechScreen createState() => _SpeechScreen();
}

class _SpeechScreen extends State<SpeechScreen> {
  TextEditingController _textEditingController = TextEditingController();
  late stt.SpeechToText _speech;
  bool _isListening = false;
  List<String> _imagePaths = [];
  int _currentIndex = 0;

  final Map<String, List<String>> _wordToImageMap = {
    "اب.gif": ["ابوي","أبوي","ابي", "ابيك", "ابانا", "والد", "أبو", "الوالد"],
    "إحتقار.gif": ["ازدراء ", " استصغار", " استهانة", "تحقير"],
    "السعودية.gif": ["السعوديه", "سعودية", "سعوديه"],
    "اخ.gif": ["اخوي","أخوي","أخو", "أخي", "شقيق", "اخي", "اخو"],
    "اخت.gif": ["أختي", "أخت", "شقيقة", "شقيقه", "اختي"],
    "ارمل.gif": ["أرملة", "ارملة", "أرامل", "ارامل"],
    "اسبوع.gif": ["أسبوع", "أسابيع", "اسابيع"],
    "اسد.gif": ["أسد", "اسود", "أسود"],
    "اسمك.gif": ["اسم"],
    "اعزب.gif": ["أعزب", "عازب", "عزباء"],
    "الأذن.gif": ["الاذن", "أذن", "اذن", "اذان", "أذان"],
    "الأنف.gif": ["الانف", "انف", "أنف"],
    "التاريخ.gif": ["تاريخ"],
    "الجلد.gif": ["جلد"],
    "الحق.gif": ["حق", "حقيقة", "حقيقه", "الحقيقة", "الحقيقه"],
    "الخريف.gif": ["خريف"],
    "الربيع.gif": ["ربيع"],
    "الشتاء.gif": ["شتاء"],
    "الصيف.gif": ["صيف"],
    "العين.gif": ["عين", "عيون", "العيون"],
    "الفهد.gif": ["فهد", "فهود", "الفهود"],
    "اللسان.gif": ["لسان"],
    "ام.gif": ["أم", "امي", "أمي", "والدة", "والده"],
    "اين.gif": ["أين", "أينما", "اينما"],
    "برد.gif": ["البرد", "برودة", "بروده"],
    "برق.gif": ["صاعقه", "صاعقة", "البرق", "بروق"],
    "تسكن.gif": ["يسكن", "تسكنون", "يسكنون"],
    "تعمل.gif": ["يعمل", "نعمل", "تعملون", "يعملون", "اعمل", "أعمل"],
    "ثعبان.gif": ["ثعابين", "الثعبان", "الثعابين"],
    "ثعلب.gif": ["الثعلب", "الثعالب", "ثعالب"],
    "ثقيل.gif": ["ثقيلة", "الثقل"],
    "جد.gif": ["جدي", "الجد", "جدك"],
    "جده.gif": ["جدته", "الجده", "جدتي"],
    "جمل.gif": ["الجمل", "جمال", "ناقة", "الناقة", "ناقه", "ناقة"],
    "حالك.gif": ["حال", "الحال", "حالكم"],
    "حر.gif": ["حرارة", "الحرارة"],
    "حسد.gif": ["الحسد", "غيرة", "غيره", "الغيره", "الغيرة"],
    "حلاق.gif": ["حلاقه", "حلاقة", "الحلاق"],
    "خطوبة.gif": ["خطوبه", "خطبة", "خطبه", "الخطبة", "الخطبه"],
    "خفيف.gif": ["خفيفه", "خفيفة"],
    "خيانة.gif": ["خيانه", "الخيانه", "الخيانة", "غدر", "الغدر", "خذلان"],
    "دقيقة.gif": ["دقيقه", "الدقيقة", "الدقيقه"],
    "ذئب.gif": ["الذئب", "ذئاب", "الذئاب"],
    "ذكي.gif": ["ذكية", "ذكيه", "الذكي"],
    "رئتان.gif": ["الرئتان", "الرئتين", "رئتين"],
    "رسام.gif": ["الرسام", "الرسامة", "رسامة"],
    "زرافة.gif": ["زرافه", "الزرافة", "الزرافه", "الزرافات", "زرافات"],
    "زفير.gif": ["الزفير"],
    "زواج.gif": ["الزواج"],
    "ساعة.gif": ["ساعه", "ساعات", "الساعات", "الساعه", "الساعة"],
    "ستارة.gif": ["ستاره", "الستاره", "الستارة", "ستائر", "الستائر"],
    "سنة.gif": ["السنة", "السنه", "عام", "العام", "سنه"],
    "شفقة.gif": ["شفقه", "الشفقه", "الشفقة", "تعاطف", "التعاطف"],
    "شكرا.gif": ["الشكر"],
    "شمس.gif": ["الشمس"],
    "شهر.gif": ["الشهر", "شهور", "الشهور"],
    "شهيق.gif": ["الشهيق", "شهقه", "الشهقه", "الشهقة", "شهقة"],
    "صبر.gif": ["الصبر"],
    "صدق.gif": ["الصدق", "صادق"],
    "طاولة.gif": ["الطاولة", "طاوله", "الطاوله", "طاولات", "الطاولات"],
    "طباخ.gif": [
      "الطباخ",
      "طباخة",
      "الطباخة",
      "طباخين",
      "الطباخين",
      "طهاه",
      "طاه"
    ],
    "طلاق.gif": ["الطلاق", "انفصال"],
    "طيار.gif": ["الطيار", "طيارة", "الطيارة", "طيارين"],
    "عقرب.gif": ["العقرب", "عقارب", "العقارب"],
    "غدر.gif": ["الغدر", "شهقه", "الشهقه", "الشهقة", "شهقة"],
    "غزال.gif": ["غزلان", "الغزلان", "الغزال"],
    "فلاح.gif": [
      "الفلاح",
      "مزارع",
      "المزارع",
      "فلاحه",
      "فلاحة",
      "مزارعه",
      "المزارعه"
    ],
    "فيل.gif": ["الفيل", "فيله", "فيلة", "الفيلة", "الفيله"],
    "قديم.gif": ["القديم", "قديمة", "قديمه", "القديمة", "القديمه"],
    "قلب.gif": ["القلب", "قلوب", "القلوب"],
    "قمر.gif": ["القمر"],
    "كنب.gif": ["الكنب", "كنبه", "الكنبة", "كنبة", "الكنبه"],
    "لوم.gif": ["اللوم", "اتهام", "الاتهام", "الإتهام"],
    "ليل.gif": ["الليل", "المساء", "مساء"],
    "ما.gif": ["ماذا"],
    "مزهرية.gif": ["مزهريه", "المزهرية", "المزهريه"],
    "مستشفى.gif": ["المستشفى", "مستوصف", "المستوصف"],
    "مطر.gif": ["المطر", "أمطار", "امطار", "الامطار", "الأمطار"],
    "معلم.gif": [
      "معلمه",
      "المعلمه",
      "المعلم",
      "معلمة",
      "استاذ",
      "أستاذ",
      "أستاذه",
      "أستاذة",
      "المعلمة"
    ],
    "مكانك.gif": ["موقعك", "مكانكم", "موقعكم"],
    "مكيف.gif": ["المكيف"],
    "نجار.gif": ["النجار"],
    "نهار.gif": ["النهار", "صباح", "الصباح"],
    "وجه.gif": ["الوجه", "وجوه", "الوجوه"],
    "وقت.gif": ["الوقت", "زمن", "الزمن"],
    "يبني.gif": ["يشيد", "تبني"],
    "يختار.gif": [
      "تختار",
      "يختارون",
      "تختارون",
      "ينتقي",
      "تنتقي",
      "تنتقون",
      "ينتقون"
    ],
    "يدخن.gif": ["تدخن", "يدخنون", "تدخنون"],
    "يدعم.gif": ["يساند", "تدعم", "تساند", "يدعمون", "تدعمون"],
    "يساعد.gif": ["تساعد", "يساعدون", "تساعدون", "مساعده", "مساعدة", "اساعد"],
    "يستحم.gif": ["تستحم", "يستحمون", "تستحمون", "أستحم", "استحم"],
    "ينادي.gif": ["تنادي", "انادي", "أنادي", "ينادون", "تنادون"],
    "يوم.gif": ["أيام", "ايام", "اليوم"],
    "اسفل.gif": ["أسفل", "أدنى", "ادنى", "ادناه", "أدناه"],
    "اعلى.gif": ["أعلى", "فوق"],
    "امام.gif": ["أمام", "قدام"],
    "جنوب.gif": ["الجنوب"],
    "خلف.gif": ["وراء"],
    "شرق.gif": ["الشرق"],
    "غرب.gif": ["الغرب"],
    "يسار.gif": ["اليسار"],
    "يمين.gif": ["اليمين"],
    "فجر.gif": ["الفجر"],
    "ظهر.gif": ["الظهر"],
    "عصر.gif": ["العصر"],
    "مغرب.gif": ["المغرب"],
    "عشاء.gif": ["العشاء"],
    "صفر.gif": ["الصفر", "0"],
    "واحد.gif": ["الواحد", "1"],
    "إثنين.gif": ["زوج", "ثنائي", "ثنائية", "زوجين", "ثنائية", "2"],
    "ثلاثه.gif": ["ثلاثة", "ثلاثي", "ثلاثيه", "الثلاث", "ثلاث", "3"],
    "أربعة.gif": ["أربع", "اربع", "رباعي", "4"],
    "خمسة.gif": ["خمس", "خمسه", "خماسي", "الخمسة", "الخمسه", "5"],
    "ستة.gif": ["سته", "السته", "الستة", "ست", "6"],
    "سبعة.gif": ["سبعه", "السبعه", "السبعة", "سبع", "7"],
    "ثمانية.gif": ["ثمانية", "الثمانيه", "الثمانية", "ثمان", "8"],
    "تسعة.gif": ["تسعه", "التسعه", "التسعة", "تسع", "9"],
    "حائل.gif": ["حايل"],
    "الى.gif": ["إلى"],
    "انا.gif": ["أنا"],
    "انتم.gif": ["أنتم"],



  };

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _textEditingController.text = val.recognizedWords;
            if (val.hasConfidenceRating && val.confidence > 0) {
              _showImages(val.recognizedWords);
            }
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  void _showImages(String userInput) async {
    if (userInput.isEmpty) {
      _showErrorMessage(".يجب عليك كتابة نص أو تسجيل صوت");
      return;
    }

    // Check if the input contains non-Arabic characters
    if (!isArabic(userInput)) {
      _showErrorMessage(".يجب أن يكون النص المدخل باللغة العربية");
      return;
    }
    String directoryPathLetters = 'assets/letters/';
    String directoryPathWords = 'assets/words/';

    List<String> assetFiles = await rootBundle
        .loadString('AssetManifest.json')
        .then((String manifestContent) {
      final Map<String, dynamic> manifestMap = json.decode(manifestContent);
      return manifestMap.keys
          .where((String key) =>
              key.startsWith(directoryPathLetters) ||
              key.startsWith(directoryPathWords))
          .toList();
    });

    List<String> imageFiles = assetFiles
        .where((String assetPath) => assetPath.toLowerCase().endsWith('.gif'))
        .toList();

    List<String> words = userInput.split(' ');

    _imagePaths.clear();

    for (String word in words) {
      bool found = false;
      for (String imagePath in _wordToImageMap.keys) {
        if (_wordToImageMap[imagePath]!.contains(word.toLowerCase())) {
          String fullImagePath = '$directoryPathWords$imagePath';
          if (imageFiles.contains(fullImagePath)) {
            _imagePaths.add(fullImagePath);
            found = true;
            break;
          }
        }
      }

      if (!found) {
        String wordImagePath = '$directoryPathWords$word.gif';
        if (imageFiles.contains(wordImagePath)) {
          _imagePaths.add(wordImagePath);
        } else {
          for (int i = 0; i < word.length; i++) {
            String letter = word[i];
            String letterImagePath = imageFiles.firstWhere(
              (assetPath) => assetPath
                  .toLowerCase()
                  .endsWith('$directoryPathLetters$letter.gif'),
              orElse: () => '',
            );
            if (letterImagePath.isNotEmpty) {
              _imagePaths.add(letterImagePath);
            } else {
              print('No image found for $letter');
            }
          }
        }
      }
    }

    setState(() {
      _currentIndex = 0;
    });

    _showImageDialog();
  }
  bool isArabic(String text) {
    final arabicPattern = RegExp(r'^[\u0600-\u06FF\s]+$');
    return arabicPattern.hasMatch(text);
  }
  void _showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("!خطأ",
            textAlign: TextAlign.right,
          ),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('حسنًا'),
            ),
          ],
        );
      },
    );
  }

  void _showImageDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              insetPadding: EdgeInsets.only(left: 15, right: 15),
              contentPadding: EdgeInsets.all(8),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32.0))),
              content: Container(
                width: 392,
                height: 429.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 63,
                    ),
                    Expanded(
                      child: Image.asset(
                        _imagePaths[_currentIndex],
                        fit: BoxFit.fill,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        
                        IconButton(
                          icon: Icon(Icons.arrow_back_ios),
                          onPressed: _currentIndex < _imagePaths.length - 1
                              ? () {
                                  setState(() {
                                    _currentIndex++;
                                  });
                                }
                              : null, // Disable the button when at the end
                          color: _currentIndex < _imagePaths.length - 1
                              ? Colors.black // Normal color when enabled
                              : Colors.grey,
                          // Grey out when disabled
                        ),
                        // Text(),
                        Text(
                          '${_imagePaths.length}/', // Display current index and total count
                          style: TextStyle(
                            color: Colors.black, // Normal color when enabled
                            fontSize: 16, // Adjust the font size as needed
                          ),
                        ),
                        Text(
                          '${_currentIndex + 1}', // Display current index and total count
                          style: TextStyle(
                            color: _currentIndex + 1 == _imagePaths.length
                                ? Colors.black // Normal color when enabled
                                : Colors.grey,
                            fontSize: 16, // Adjust the font size as needed
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.arrow_forward_ios),
                          onPressed: _currentIndex > 0
                              ? () {
                                  setState(() {
                                    _currentIndex--;
                                  });
                                }
                              : null, // Disable the button when at the beginning
                          color: _currentIndex > 0
                              ? Colors.black // Normal color when enabled
                              : Colors.grey, // Grey out when disabled
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            _downloadImagesAndCreateVideo();
                            Navigator.of(context).pop();
                          },
                          customBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          splashColor: Color.fromARGB(112, 125, 223, 247),
                          highlightColor: Color.fromARGB(111, 56, 60, 90),
                          child: Ink(
                            height: 44,
                            width: 103,
                            child: Center(
                              child: Text(
                                "حفظ",
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Color.fromRGBO(33, 150, 243, 1),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
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
                                  image: AssetImage('assets/clearBtn.png')),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              color: Colors.transparent,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          customBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          splashColor: Color.fromARGB(112, 125, 223, 247),
                          highlightColor: Color.fromARGB(111, 255, 255, 255),
                          child: Ink(
                            height: 44,
                            width: 103,
                            child: Center(
                              child: Text(
                                "اغلاق",
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Color.fromRGBO(33, 150, 243, 1),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
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
                                  image: AssetImage('assets/clearBtn.png')),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              color: Colors.transparent,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _downloadImagesAndCreateVideo() async {
    try {
      final List<String> imagePaths = _imagePaths;

      final Directory appDir = await getTemporaryDirectory();
      final String tempDirPath = appDir.path;

      for (int i = 0; i < imagePaths.length; i++) {
        final String imagePath = imagePaths[i];
        final ByteData imageData = await rootBundle.load(imagePath);
        final Uint8List bytes = imageData.buffer.asUint8List();

        String extension =
            imagePath.toLowerCase().endsWith('.gif') ? '.gif' : '.jpg';

        final File imageFile = File('$tempDirPath/image$i$extension');
        await imageFile.writeAsBytes(bytes);
        imagePaths[i] = imageFile.path;
      }

      final String imageListPath = '$tempDirPath/imageList.txt';
      final File imageListFile = File(imageListPath);
      await imageListFile
          .writeAsString(imagePaths.map((e) => 'file $e').join('\n'));

      final String outputVideoPath = '${appDir.path}/video.mp4';

      final FlutterFFmpeg flutterFFmpeg = FlutterFFmpeg();
      final int rc = await flutterFFmpeg.execute(
        '-y -f concat -safe 0 -i $imageListPath -c:v mpeg4 -vf fps=10 -pix_fmt yuv420p $outputVideoPath',
      );

      if (rc == 0) {
        await saveVideoToGallery(outputVideoPath);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('تم حفظ الفيديو في ألبوم الكاميرا'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('فشل حفظ الفيديو'),
          ),
        );
      }
    } catch (e) {
      print('Error creating video: $e');
    }
  }

  Future<void> saveVideoToGallery(String videoPath) async {
    try {
      final result = await ImageGallerySaver.saveFile(videoPath);
      if (result['isSuccess']) {
        print('Video saved to gallery: $videoPath');
      } else {
        print('Failed to save video to gallery.');
      }
    } catch (e) {
      print('Error saving video to gallery: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          backgroundColor: const Color.fromRGBO(56, 60, 90, 1),
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
            ' نص أو صوت إلى لغة إشارة',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 255, 255, 255),
            ),
          ),
        ),
      ),
      backgroundColor: const Color.fromRGBO(56, 60, 90, 1),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 210.0),
              Padding(
                padding: const EdgeInsets.only(left: 180),
                child: Text(
                  'أدخل نص أو سجل صوت',
                  // textAlign: TextAlign.left,
                  style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                      // backgroundColor: const Color.fromRGBO(56, 60, 90, 1),
                      // textAlign: TextAlign.right,
                      ),
                ),
              ),
              TextField(
                controller: _textEditingController,
                textAlign: TextAlign.right,
                decoration: const InputDecoration(
                  enabledBorder: const OutlineInputBorder(
                    // borderRadius: BorderRadius.circular(8.0),
                    borderSide:
                        const BorderSide(color: Color(0xFF6B7280), width: 2.0),
                  ),

                  fillColor: Colors.white,
                  filled: true,
                  isDense: true,
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.white, width: 2.0),
                    // borderRadius: BorderRadius.circular(25.0),
                  ),
                  // ),
                ),
              ),
              SizedBox(height: 16.0),
              SizedBox(
                height: 80,
                width: 80,
                child: ElevatedButton(
                  onPressed: _listen,
                  child: Icon(
                    _isListening ? Icons.mic_none : Icons.mic_off_outlined,
                    fill: 0,
                    size: 50,
                    color: Color.fromRGBO(33, 150, 243, 1),
                  ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                        //border radius equal to or more than 50% of width
                      )),
                ),
              ),
              SizedBox(height: 190.0),
              InkWell(
                onTap: () {
                  String userInput = _textEditingController.text;
                  _showImages(userInput);
                },
                customBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                splashColor: Color.fromARGB(112, 125, 223, 247),
                highlightColor: Color.fromARGB(111, 56, 60, 90),
                child: Ink(
                  height: 55,
                  width: 132,
                  child: Center(
                    child: Text(
                      "تحويل",
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
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
                        image: AssetImage('assets/chooseImg.png')),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    color: Colors.transparent,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
