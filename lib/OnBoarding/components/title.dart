// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import 'package:adaptive_speech/Screens/getStarted.dart';

// This is the best practice
import '../../../components/default_button.dart';

class TitleHead extends StatelessWidget {
  const TitleHead({super.key, required this.text, required this.image,required this.head, required this.btnText });
  
  // TitleHead({Key key,this.text,this.image,}) : super(key: key);
  final String? text, image,head,btnText;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Spacer(flex: 6,),
        // Text(
        //   "إشارة واحدة",
        //   style: TextStyle(
        //     fontSize: (36),
        //     color: Colors.white,
        //     fontWeight: FontWeight.bold,
        //   ),
        // ),
        // Padding(padding: EdgeInsets.only(bottom: 10,top:50)),
        Text(
          head?? " ",
          style: TextStyle(
            fontSize: (24),
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 57.0,right: 57.0,top: 40.0),
        child: Text(
          text?? " ",
          style: TextStyle(
            fontSize: (20),
            color: Color.fromRGBO(255, 255, 255, 127),
            height: 1,
            fontWeight: FontWeight.bold
          ),
          textAlign: TextAlign.center,
          
        ),
        
        ),
        // Text(
        //   text?? " ",
        //   style: TextStyle(
        //     fontSize: (20),
        //     color: Color.fromARGB(255, 255, 255, 255),
        //   ),
        //   textAlign: TextAlign.center,
          
        // ),
        Spacer(flex: 2),
        Padding(
          padding: EdgeInsets.only(top:70.0),
        child:Image.asset(
          image?? " ",
          height: (167),
          width: (176),
          fit: BoxFit.cover,
        ),),
        // Spacer(flex: 8),

    
        // CustomButton
        // Decoration : btnFillPrimary
        // name: تخطي
        // onClick : Navigation-onTaptf
        // Alignment : Center
        // marginLeft:3
        // marginRight:3
        
  



        // DefaultButton(
        //     btnText?? "هاي ",
        //     press: () {
        //       Navigator.pushNamed(context, getStarted.routeName);
        //       },
        // ),
        //////////////////////////////////////////////
        // DefaultButton(
        //             // text: ,
        //             btnText?? " ",
                    // press: () {
                    //   Navigator.pushNamed(context, getStarted.routeName);
                    // },
                  // ),
      ],
    );
  }
}

