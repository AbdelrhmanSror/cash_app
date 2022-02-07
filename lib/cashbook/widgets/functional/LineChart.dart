import 'package:debts_app/cashbook/utility/Utility.dart';
import 'package:debts_app/cashbook/utility/dataClasses/CashbookModelDetails.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class HeadLineChart extends StatelessWidget {
  const HeadLineChart({Key? key, required this.modelListDetails})
      : super(key: key);
  final CashBookModelListDetails modelListDetails;

  Image _getIcon() {
    if (modelListDetails.getPercentage() > 0) {
      return Image.asset(
        'assets/images/icon-increase-52.png',
        width: 25,
        height: 20,
        color: Color(0xFF08A696),
      );
    } else if (modelListDetails.getPercentage() < 0) {
      return Image.asset(
        'assets/images/icon-decrease-50.png',
        width: 25,
        height: 20,
        color: Color(0xFFF88D93),
      );
    } else {
      return Image.asset(
        'assets/images/stable.png',
        width: 25,
        height: 20,
        color: Colors.grey,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Wrap(
          children: [
            RichText(
                text: TextSpan(children: [
              const TextSpan(
                text: 'EGP  ',
                style: TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              TextSpan(
                  text: (Utility.formatCashNumber(
                      modelListDetails.getBalance().abs())),
                  style: const TextStyle(
                      fontSize: 30,
                      color: Colors.black,
                      fontWeight: FontWeight.bold))
            ])),
          ],
        ),
        const SizedBox(width: 8),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('${modelListDetails.getPercentage().toStringAsFixed(1)}%  ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 16,
                      color: modelListDetails.getPercentage() >= 0
                          ? const Color(0xFF08A696)
                          : const Color(0xFFF88D93),
                      fontWeight: FontWeight.bold)),
              _getIcon()
            ],
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
            flex: 1, child: SpLineChart(modelListDetails: modelListDetails)),
      ],
    );
  }
}

class SpLineChart extends StatelessWidget {
  const SpLineChart({Key? key, required this.modelListDetails})
      : super(key: key);

  final CashBookModelListDetails modelListDetails;

  @override
  Widget build(BuildContext context) {
    return LineChart(
      sampleData1,
      swapAnimationDuration: const Duration(milliseconds: 250),
      swapAnimationCurve: Curves.bounceInOut, // Optional
    );
  }

  LineChartData get sampleData1 => LineChartData(
        lineTouchData: LineTouchData(
            handleBuiltInTouches: true,
            touchTooltipData: LineTouchTooltipData(
                tooltipBgColor: Colors.white,
                getTooltipItems: (touchedSpots) {
                  return touchedSpots.map((LineBarSpot touchedSpot) {
                    const textStyle = TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                      fontSize: 0,
                    );
                    return LineTooltipItem('', textStyle,
                        textAlign: TextAlign.end,
                        children: [
                          TextSpan(
                            text: 'EGP ',
                            style: TextStyle(
                                fontSize: 8,
                                color: (touchedSpot.y) < 0
                                    ? const Color(0xFFF56B73)
                                    : const Color(0xFF09C7B4),
                                fontWeight: FontWeight.normal),
                          ),
                          TextSpan(
                              text: (Utility.formatCashNumber(touchedSpot.y)),
                              style: TextStyle(
                                  fontSize: 14,
                                  color: (touchedSpot.y) < 0
                                      ? const Color(0xFFF56B73)
                                      : const Color(0xFF09C7B4),
                                  fontWeight: FontWeight.normal))
                        ]);
                  }).toList();
                })),
        gridData: gridData,
        titlesData: titlesData1,
        borderData: borderData,
        lineBarsData: lineBarsData1,
        minX: 0,
        maxX: modelListDetails.models.length.toDouble(),
        maxY: modelListDetails.totalCashIn,
        minY: modelListDetails.totalCashOut,
      );

  FlTitlesData get titlesData1 => FlTitlesData(
        bottomTitles: SideTitles(showTitles: false),
        rightTitles: SideTitles(showTitles: false),
        topTitles: SideTitles(showTitles: false),
        leftTitles: SideTitles(showTitles: false),
      );

  List<LineChartBarData> get lineBarsData1 => [
        lineChartBarData1_1,
      ];

  FlGridData get gridData => FlGridData(show: false);

  FlBorderData get borderData => FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(color: Colors.transparent),
          left: BorderSide(color: Colors.transparent),
          right: BorderSide(color: Colors.transparent),
          top: BorderSide(color: Colors.transparent),
        ),
      );

  LineChartBarData get lineChartBarData1_1 => LineChartBarData(
        isCurved: true,
        colors: [const Color(0xFF3345A6)],
        barWidth: 3,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(show: true),
        spots: getSpots(modelListDetails),
      );

  List<FlSpot> getSpots(CashBookModelListDetails models) {
    final List<FlSpot> spots = [];
    for (int i = 0; i < models.models.length; i++) {
      spots.add(FlSpot((i).toDouble(), models.models[i].getBalance()));
    }
    return spots;
  }
}
