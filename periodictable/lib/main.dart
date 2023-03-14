import 'dart:math';

import 'package:flutter/material.dart';
import "dart:convert";
import 'data/PeriodicTableJSON.json.dart';
import 'models/tableau.dart';
import 'models/element.dart';

void main() {
  runApp(const MyApp());
}

final _table = TableauPeriodique(jsonDecode(jsonTablePer));

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tableau Périodique',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const PeriodicTable(title: 'CAL tableau périodique'),
    );
  }
}

class PeriodicTable extends StatefulWidget {
  const PeriodicTable({super.key, required this.title});

  final String title;

  @override
  State<PeriodicTable> createState() => _PeriodicTableState();
}

class _PeriodicTableState extends State<PeriodicTable> {
  final int _tableRows = 10;
  final int _tableColumns = 18;

  Widget _periodicTableGrid(
      {required double screenSize, required bool isLandscape}) {
    final double cellSize =
        isLandscape ? screenSize / _tableColumns : screenSize / _tableRows;
    return SizedBox(
        width: cellSize * _tableColumns,
        height: cellSize * _tableRows,
        child: Stack(
          children: _table
              .getElements()
              .map((e) => _periodicTableCell(
                  element: e, screenSize: screenSize, isLandscape: isLandscape))
              .toList(),
        ));
  }

  Widget _periodicTableCell(
      {required MonElement element,
      required double screenSize,
      required bool isLandscape}) {
    final double cellSize =
        isLandscape ? screenSize / _tableColumns : screenSize / _tableRows;
    final bool fullCell = cellSize > 50;
    final double x = element.xpos - 1;
    final double y = element.ypos - 1;
    final Color bgColor = element.cpkHex == ''
        ? Colors.black
        : Color(int.parse(element.cpkHex, radix: 16) + 0xFF000000);
    final Color textColor =
        bgColor.computeLuminance() > 0.5 ? Colors.black54 : Colors.white70;
    return Positioned(
      left: x * cellSize,
      top: y * cellSize,
      width: cellSize,
      height: cellSize,
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: element.cpkHex == ''
            ? const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.red],
                  transform: GradientRotation(45 * pi / 180),
                ),
              )
            : BoxDecoration(
                color: bgColor,
              ),
        child: InkWell(
          onTap: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return _elementDialog(element: element);
                });
          },
          child: Stack(
            children: [
              fullCell
                  ? Text(
                      style: TextStyle(color: textColor),
                      element.number.toString())
                  : const SizedBox(),
              fullCell
                  ? Positioned(
                      top: 0,
                      right: 0,
                      child: Text(
                          style: TextStyle(color: textColor),
                          roundTwoDigits(element.atomicMass)),
                    )
                  : const SizedBox(),
              Center(
                  child: Text(
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: textColor),
                      element.symbol)),
              fullCell
                  ? Positioned(
                      bottom: 0,
                      child: Text(
                          style: TextStyle(
                            color: textColor,
                            fontSize: 12,
                          ),
                          element.name))
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  String roundTwoDigits(num n) {
    return n.toStringAsFixed(n.roundToDouble() == n ? 1 : 2);
  }

  Widget _elementDialog({required MonElement element}) {
    return AlertDialog(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(element.name, style: const TextStyle(fontSize: 24)),
          Text("${element.phase}, ${element.category}",
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: Colors.black54))
        ],
      ),
      content: SingleChildScrollView(
        child: Column(children: [
          Container(
            padding: const EdgeInsets.only(bottom: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Atomic mass: ${element.atomicMass} u"),
                const SizedBox(height: 10),
                Text("Boiling point: ${element.boil} K"),
                const SizedBox(height: 10),
                Text("Melting point: ${element.melt} K"),
                const SizedBox(height: 10),
                Text("Discovered by: ${element.discoveredBy}"),
              ],
            ),
          ),
          Text(element.summary,
              style: const TextStyle(fontSize: 14, color: Colors.black54)),
          const SizedBox(height: 10),
          CustomPaint(
            painter: ElementPainter(element.shells),
            size: const Size(280, 280),
          ),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final bool isLandscape = screenWidth > screenHeight;

    final double appBarHeight = AppBar().preferredSize.height;
    final double safeAreaHeight = MediaQuery.of(context).padding.top +
        MediaQuery.of(context).padding.bottom;
    final double availableHeight = screenHeight - appBarHeight - safeAreaHeight;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: SafeArea(
        child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          if (isLandscape) {
            return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: _periodicTableGrid(
                    screenSize: screenWidth, isLandscape: isLandscape));
          } else {
            return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: _periodicTableGrid(
                    screenSize: availableHeight, isLandscape: isLandscape));
          }
        }),
      ),
    );
  }
}

class ElementPainter extends CustomPainter {
  List<num> shells = [];
  ElementPainter(this.shells);

  @override
  void paint(Canvas canvas, Size size) {
    double centerX = size.width / 2;
    double centerY = size.height / 2;
    double orbitRadius = size.width / (shells.length * 2 + 2);

    // draw nucleus
    double neucleusSize = 20;
    canvas.drawCircle(Offset(centerX, centerY), neucleusSize,
        Paint()..color = Colors.redAccent);

    for (int orbit = 0; orbit < shells.length; orbit++) {
      // draw orbits
      canvas.drawCircle(
          Offset(centerX, centerY),
          orbitRadius * (orbit + 1) + 20,
          Paint()
            ..strokeWidth = 1.5
            ..style = PaintingStyle.stroke);

      // draw electrons
      int electronsInOrbit = shells[orbit].toInt();
      double electronSize = orbitRadius / 4;
      for (int electron = 0; electron < electronsInOrbit; electron++) {
        double angle = 2 * pi * electron / electronsInOrbit;
        double x = centerX + (orbitRadius * (orbit + 1) + 20) * sin(angle);
        double y = centerY + (orbitRadius * (orbit + 1) + 20) * cos(angle);
        canvas.drawCircle(Offset(x, y), electronSize,
            Paint()..color = Colors.blueAccent.withOpacity(0.8));
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
