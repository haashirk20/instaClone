
import "package:flutter/material.dart";

class DesktopLayout extends StatefulWidget {
  const DesktopLayout({super.key});

  @override
  State<DesktopLayout> createState() => _DesktopLayoutState();
}

class _DesktopLayoutState extends State<DesktopLayout> {
  @override
  Widget build(BuildContext context) {

    return const Scaffold(
      body: Center(child:Text("Desktop Layout"))
    );
  }
}