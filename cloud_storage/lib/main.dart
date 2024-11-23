import 'package:cloud_storage/model/CSModel.dart';
import 'package:cloud_storage/screens/CSSplashScreen.dart';
import 'package:flutter/material.dart';

List<CSDataModel> getCloudboxList = getCloudboxData();
List<CSDrawerModel> getCSDrawerList = getCSDrawer();

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cloud Storage',
      home: CSSplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
