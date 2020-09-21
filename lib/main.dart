import 'package:flutter/material.dart';
import 'package:mesio_map_view/map_view.dart';
import 'package:mesio_map_view/utils/colors.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MAP VIEW',
      theme: ThemeData(
        primarySwatch: PRIMARY_COLOR,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        secondaryHeaderColor: SECONDARY_COLOR,
      ),
      home: MapView(),
    );
  }
}
