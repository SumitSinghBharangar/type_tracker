import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:type_tracker/provider/typing_provider.dart';
import 'package:type_tracker/screens/difficulty_type_screen.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key});

  String _getTimeDisplay(TypingTestProvider provider) {
    int totalTime = provider.getDifficultyTime();
    int elapsedTime = totalTime - provider.timeLeft;
    return '${elapsedTime}s';
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TypingTestProvider>(
      builder: (context, provider, child) {
        final speedRange = provider.getSpeedRange();
        final characterSpeeds = provider.characterSpeeds;

        // Sort characters by speed for better visualization
        final sortedEntries = characterSpeeds.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));

        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20.w,
                vertical: 20.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Current Result',
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 16.h,
                  ),

                  // Stats Cards
                  Row(
                    children: [
                      Expanded(
                        child: _buildCurrentStatCard(
                          'WPM',
                          provider.wpm.toString(),
                          Icons.speed,
                          Colors.blue,
                        ),
                      ),
                      SizedBox(
                        width: 12.w,
                      ),
                      Expanded(
                        child: _buildCurrentStatCard(
                          'Accuracy',
                          '${provider.accuracy}%',
                          Icons.tablet,
                          Colors.green,
                        ),
                      ),
                      SizedBox(
                        width: 12.w,
                      ),
                      Expanded(
                        child: _buildCurrentStatCard(
                          'Time',
                          _getTimeDisplay(provider),
                          Icons.timer,
                          Colors.orange,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: 24.h,
                  ),
                  Text(
                    'Speed per Character',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 16.h,
                  ),

                  // Scrollable Character Speed Graph
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        width: sortedEntries.length *
                            50.0, // Adjust width based on number of characters
                        constraints: const BoxConstraints(minWidth: 400),
                        decoration: BoxDecoration(
                          color: Colors.grey[900],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: BarChart(
                          BarChartData(
                            gridData: FlGridData(
                              show: true,
                              horizontalInterval: 20,
                              drawVerticalLine: false,
                              getDrawingHorizontalLine: (value) {
                                return FlLine(
                                  color: Colors.white.withOpacity(0.1),
                                  strokeWidth: 1,
                                );
                              },
                            ),
                            titlesData: FlTitlesData(
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  interval: 20,
                                  reservedSize: 40,
                                  getTitlesWidget: (value, meta) {
                                    return Text(
                                      '${value.toInt()}',
                                      style: const TextStyle(
                                          color: Colors.white70),
                                    );
                                  },
                                ),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    if (value.toInt() >= 0 &&
                                        value.toInt() < sortedEntries.length) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Text(
                                          sortedEntries[value.toInt()].key,
                                          style: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 14,
                                          ),
                                        ),
                                      );
                                    }
                                    return const Text('');
                                  },
                                ),
                              ),
                              rightTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              topTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                            ),
                            borderData: FlBorderData(show: false),
                            barGroups: List.generate(
                              sortedEntries.length,
                              (index) => BarChartGroupData(
                                x: index,
                                barRods: [
                                  BarChartRodData(
                                    toY: sortedEntries[index].value,
                                    color: _getSpeedColor(
                                        sortedEntries[index].value),
                                    width: 30,
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(4),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            maxY: speedRange['max'],
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 24.h,
                  ),

                  // Try Again Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        provider.reset();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DifficultyTypeScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: EdgeInsets.symmetric(
                          vertical: 16.h,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Try Again',
                        style: TextStyle(
                          fontSize: 18.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCurrentStatCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              color: color.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Color _getSpeedColor(double speed) {
    // Color gradient from red (slow) to blue (fast)
    if (speed < 30) {
      return Colors.red;
    } else if (speed < 60) {
      return Colors.orange;
    } else if (speed < 90) {
      return Colors.blue;
    } else {
      return Colors.green;
    }
  }
}
