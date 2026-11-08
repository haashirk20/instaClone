import 'package:flutter/material.dart';
import 'package:insta_flutter/providers/user_provider.dart';
import 'package:insta_flutter/utils/global_variables.dart';
import 'package:provider/provider.dart';

class ResponsiveLayout extends StatefulWidget{
  final Widget desktopLayout;
  final Widget mobileLayout;

  const ResponsiveLayout({
    Key? key,
    required this.desktopLayout,
    required this.mobileLayout
    }): super(key: key);

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {

  @override
  void initState() {
    super.initState();
    addData();
  }

  addData() async {
   UserProvider userProvider = Provider.of(context, listen: false);
   await userProvider.refreshUser();
  }

  
  @override
  Widget build (BuildContext context){
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints){
        if(constraints.maxWidth > webScreenSize){
          return widget.desktopLayout;
        }
        else{
          return widget.mobileLayout;
        }
      },
    );
  }
}