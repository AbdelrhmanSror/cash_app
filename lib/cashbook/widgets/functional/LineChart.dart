import 'package:debts_app/cashbook/utility/Constants.dart';
import 'package:debts_app/cashbook/utility/dataClasses/CashbookModeldetails.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class chartX extends StatelessWidget {
  chartX({Key? key, required this.modelListDetails}) : super(key: key);
  CashBookModelListDetails modelListDetails;

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
                  text: '${(modelListDetails.getBalance()).abs()}',
                  style: const TextStyle(
                      fontSize: 30,
                      color: Colors.black,
                      fontWeight: FontWeight.bold))
            ])),
          ],
        ),
        const SizedBox(
          height: 8,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${modelListDetails.getPercentage().toStringAsFixed(1)}%',
              style: TextStyle(
                  fontSize: 16,
                  color: modelListDetails.getPercentage() >= 0
                      ? Color(0xFF08A696)
                      : Color(0xFFF88D93),
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            ChoiceChip(
              selected: true,
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Color(0xFF3345A6), width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              backgroundColor: Colors.white10,
              label: const Text(
                'Week',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
              selectedColor: const Color(0xFF3345A6),
              onSelected: (bool value) {},
            )
          ],
        ),
        Expanded(
            flex: 1, child: _LineChart(modelListDetails: modelListDetails)),
      ],
    );
  }
}

class _LineChart extends StatelessWidget {
  _LineChart({required this.modelListDetails});

  CashBookModelListDetails modelListDetails;

  List<FlSpot> getSpots(CashBookModelListDetails models) {
    final List<FlSpot> spots = [];
    for (int i = 0; i < models.models.length; i++) {
      spots.add(FlSpot(
          (i).toDouble(),
          models.models[i].type == TypeFilter.CASH_IN.value
              ? models.models[i].cash
              : -models.models[i].cash));
    }
    return spots;
  }

  @override
  Widget build(BuildContext context) {
    return LineChart(
      sampleData1,
      swapAnimationDuration: const Duration(milliseconds: 250),
      swapAnimationCurve: Curves.linear, // Optional
    );
  }

  LineChartData get sampleData1 => LineChartData(
        lineTouchData: LineTouchData(
            handleBuiltInTouches: true,
            touchTooltipData: LineTouchTooltipData(
                tooltipBgColor: const Color(0xFF3345A6),
                getTooltipItems: (touchedSpots) {
                  return touchedSpots.map((LineBarSpot touchedSpot) {
                    const textStyle = TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                      fontSize: 12,
                    );
                    return LineTooltipItem('EGP ${touchedSpot.y}', textStyle);
                  }).toList();
                })),
        gridData: gridData,
        titlesData: titlesData1,
        borderData: borderData,
        lineBarsData: lineBarsData1,
        minX: 0,
        maxX: modelListDetails.models.length.toDouble(),
        maxY: modelListDetails.getMaxCashIn(),
        minY: -(modelListDetails.getMaxCashOut()),
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
        belowBarData: BarAreaData(show: false),
        spots: getSpots(modelListDetails),
      );
}
