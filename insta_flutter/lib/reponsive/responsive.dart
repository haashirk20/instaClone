import 'package:flutter/material.dart';
import 'package:insta_flutter/utils/dimensions.dart';

class ResponsiveLayout extends StatelessWidget{
  final Widget desktopLayout;
  final Widget mobileLayout;

  const ResponsiveLayout({
    Key? key,
    required this.desktopLayout,
    required this.mobileLayout
    }): super(key: key);

  @override
  Widget build (BuildContext context){
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints){
        if(constraints.maxWidth > webScreenSize){
          return desktopLayout;
        }
        else{
          return mobileLayout;
        }
      },
    );
  }
}