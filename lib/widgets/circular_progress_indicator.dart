import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget getCircularProgressInd() {
  return Container(
    child: Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const <Widget>[
          SizedBox(
            height: 30.0,
            width: 30.0,
            child: CircularProgressIndicator(),
          ),
        ],
      ),
    ),
  );
}
