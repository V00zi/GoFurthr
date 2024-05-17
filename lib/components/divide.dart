import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:gofurthr/components/globals.dart';

Widget custDiv(double scrWidth,String data) {
  return Column(
    children: [
      const SizedBox(height: 5),
      FittedBox(
        fit: BoxFit.contain,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            
            DottedLine(
              direction: Axis.horizontal,
              alignment: WrapAlignment.center,
              lineLength: scrWidth/4,
              lineThickness: 2,
              dashLength: 4.0,
              dashColor: primary,
              dashRadius: 5.0,
              dashGapLength: 4.0,
              dashGapRadius: 0.0,
            ),
            Text(data,style: const TextStyle(fontSize: 14,color: primary,letterSpacing: 5,)),
            DottedLine(
              direction: Axis.horizontal,
              alignment: WrapAlignment.center,
              lineLength: scrWidth-(scrWidth/4),
              lineThickness: 2,
              dashLength: 4.0,
              dashColor: primary,
              dashRadius: 5.0,
              dashGapLength: 4.0,
              dashGapRadius: 0.0,
            ),
            
          ],
        ),
      ),
      const SizedBox(height: 5),
    ],
  );
}


