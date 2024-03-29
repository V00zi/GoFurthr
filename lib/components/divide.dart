import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';

Widget custDiv(double len, double thic, Color col) {
  return DottedLine(
    direction: Axis.horizontal,
    alignment: WrapAlignment.center,
    lineLength: len,
    lineThickness: thic,
    dashLength: 4.0,
    dashColor: col,
    dashRadius: 5.0,
    dashGapLength: 4.0,
    dashGapRadius: 0.0,
  );
}
