import 'package:flutter/material.dart';
import 'package:mesio_map_view/utils/colors.dart';

class Misc {
  static debugP({dynamic tag, dynamic message}) {
    return print("$tag >>>>>>>>> $message");
  }

  static reload({Function func}) {
    return Center(
      child: IconButton(
          onPressed: func,
          icon: Icon(
            Icons.refresh,
            color: SECONDARY_COLOR,
            size: 35.0,
          )),
    );
  }

  static empty({String message}) {
    return Center(
      child: Text(
        "$message",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 25.0, color: Colors.grey[400]),
      ),
    );
  }

  static loader() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
