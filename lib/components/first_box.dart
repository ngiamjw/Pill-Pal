import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class FirstBox extends StatelessWidget {
  final int x;
  final int y;
  const FirstBox({super.key, required this.x, required this.y});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 145,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1), // Subtle shadow
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, top: 9),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${y - x}',
                      style: TextStyle(
                        fontSize: 45,
                        fontWeight: FontWeight.bold,
                      )),
                  Text("Doses left",
                      style: TextStyle(fontSize: 16, color: Color(0xFF8E8E93))),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 25),
            child: SizedBox(
              width: 80,
              height: 80,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  PieChart(
                    PieChartData(
                      sectionsSpace: 0,
                      centerSpaceRadius: 50,
                      startDegreeOffset: 270,
                      sections: [
                        PieChartSectionData(
                          value: (x / y) * 100, // Completed portion
                          color: Colors.green,
                          title: "",
                          radius: 7,
                          showTitle: true,
                        ),
                        PieChartSectionData(
                          value: 100 - (x / y) * 100, // Remaining portion
                          color: Colors.grey,
                          title: "",
                          radius: 7,
                          showTitle: true,
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.local_fire_department, // Icon for Calories
                    color: Colors.orange,
                    size: 40, // Adjust the size as per your preference
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
