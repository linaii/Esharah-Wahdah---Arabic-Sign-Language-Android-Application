
import 'package:flutter/material.dart';

class DefaultButton extends StatelessWidget {
  const DefaultButton({
    required this.text,
    required this.press,
    required this.height,
    required this.width,



  });

  final String text;
  final Function press;
  final double height;
  final double width;
  @override
  Widget build(BuildContext context) {
    return 
    SizedBox(
      child: InkWell(
                  onTap: press as void Function(),
                  customBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  splashColor: Color.fromARGB(112, 125, 223, 247),
                  highlightColor: Color.fromARGB(111, 56, 60, 90),
                  child: Ink(
                    height: height,
                    width: width,
                    child: Center(
                      child: Text(
                        text,
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
    );
    // SizedBox(
    //   width: 350,
    //   height: 60,
    //   child: TextButton(
    //     style: TextButton.styleFrom(
    //       shape: RoundedRectangleBorder(
    //         borderRadius: BorderRadius.circular(20),
    //       ),
    //       fixedSize: const Size(250, 50),
    //       // Remove the solid background color
    //     ),
    //     onPressed: press as void Function(),
    //     child: Container(
    //       decoration: BoxDecoration(
    //         boxShadow: [
    //           BoxShadow(
    //             color: Color.fromRGBO(0, 0, 0, 0.3),
    //             spreadRadius: 0.0,
    //             blurRadius: 10.0,
    //             offset: Offset(10.0, 10.0),
    //           ),
    //         ],
    //         image: DecorationImage(
    //             fit: BoxFit.cover, image: AssetImage('assets/Variant5.png')),
    //         borderRadius: BorderRadius.all(Radius.circular(10.0)),
    //         color: Colors.transparent,
    //       ),
    //       child: Center(
    //         child: Text(
    //           text,
    //           style: const TextStyle(
    //             fontSize: 22,
    //             color: Colors.white,
    //             fontWeight: FontWeight.bold,
    //           ),
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }
}


