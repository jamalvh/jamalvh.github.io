import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  var myBox = Hive.box('highscores');
  var myBoxOfPrevTestWpms = Hive.box('prevTestsWpms'); // int
  var myBoxOfMissedWordCounters =
      Hive.box('missedWordCounters'); // key: word, value: times missed

  @override
  void initState() {
    determineTopTenMissedWords();

    super.initState();
  }

  //edits List to be top ten most missed words indexes (0 = most, 9 = least)
  void determineTopTenMissedWords() {
    tenMostMissedWordsIndexes = [];
    int indexOfMax = -1;
    int valueOfMax = 0;
    for (int i = 0; i < 10; i++) {
      valueOfMax = 0;
      for (int j = 0; j < myBoxOfMissedWordCounters.length; j++) {
        if (myBoxOfMissedWordCounters.getAt(j) >= valueOfMax &&
            myBoxOfMissedWordCounters.getAt(j) > 0 &&
            !tenMostMissedWordsIndexes.contains(j)) {
          valueOfMax = myBoxOfMissedWordCounters.getAt(j);
          indexOfMax = j;
        }
      }
      indexOfMax != -1 && !tenMostMissedWordsIndexes.contains(indexOfMax)
          ? tenMostMissedWordsIndexes.add(indexOfMax)
          : null;
    }
  }

  List tenMostMissedWordsIndexes = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 32, 1, 46),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: MediaQuery.of(context).size.height * 0.1205,
        centerTitle: false,
        title: Padding(
          padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.1,
            right: MediaQuery.of(context).size.width * 0.005,
          ),
          child: TextButton.icon(
            icon: const Padding(
              padding: EdgeInsets.only(top: 4),
              child: Icon(
                Icons.fingerprint_rounded,
                color: Colors.pink,
              ),
            ),
            label: const Text(
              'speedyfingers',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 35,
                  fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 32, 1, 46),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MyProfile(),
                  ),
                );
              },
              icon: const Icon(Icons.person_outlined,
                  size: 30, color: Colors.white38),
            ),
          ),
          Padding(
              padding: EdgeInsets.only(
                  right: MediaQuery.of(context).size.width * 0.12),
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                  FirebaseAuth.instance.signOut();
                },
                icon: const Icon(
                  Icons.logout,
                  size: 20,
                  color: Colors.white38,
                ),
              )),
        ],
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.75,
          child: ListView(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * .1),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.2,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 29, 2, 40),
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'tests started',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            myBox.get('_numTestsStarted') == 0
                                ? '-'
                                : '${myBox.get('_numTestsStarted')}',
                            style: TextStyle(
                                color: Colors.pink,
                                fontSize:
                                    MediaQuery.of(context).size.shortestSide *
                                        0.07), // or 0.04
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'average wpm',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            myBox.get('_overallAverageWpm') == 0
                                ? '-'
                                : '${myBox.get('_overallAverageWpm')}',
                            style: TextStyle(
                                color: Colors.pink,
                                fontSize:
                                    MediaQuery.of(context).size.shortestSide *
                                        0.07), // or 0.04
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.05),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.2,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 29, 2, 40),
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            '15 seconds',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            myBox.get('_highest15SecondWpm') == 0
                                ? '-'
                                : '${myBox.get('_highest15SecondWpm')}',
                            style: TextStyle(
                                color: Colors.pink,
                                fontSize:
                                    MediaQuery.of(context).size.shortestSide *
                                        0.07), // or 0.04
                          ),
                          Text(
                            myBox.get('_highest15SecondWpm') == 0
                                ? '-'
                                : '${myBox.get('_accuracyOfHighest15SecondWpm')}%',
                            style: TextStyle(
                              color: Colors.pink,
                              fontSize:
                                  MediaQuery.of(context).size.shortestSide *
                                      0.02,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            '30 seconds',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            myBox.get('_highest30SecondWpm') == 0
                                ? '-'
                                : '${myBox.get('_highest30SecondWpm')}',
                            style: TextStyle(
                                color: Colors.pink,
                                fontSize:
                                    MediaQuery.of(context).size.shortestSide *
                                        0.07), // or 0.04
                          ),
                          Text(
                            myBox.get('_highest30SecondWpm') == 0
                                ? '-'
                                : '${myBox.get('_accuracyOfHighest30SecondWpm')}%',
                            style: TextStyle(
                              color: Colors.pink,
                              fontSize:
                                  MediaQuery.of(context).size.shortestSide *
                                      0.02,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            '60 seconds',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            myBox.get('_highest60SecondWpm') == 0
                                ? '-'
                                : '${myBox.get('_highest60SecondWpm')}',
                            style: TextStyle(
                                color: Colors.pink,
                                fontSize:
                                    MediaQuery.of(context).size.shortestSide *
                                        0.07), // or 0.04
                          ),
                          Text(
                            myBox.get('_highest60SecondWpm') == 0
                                ? '-'
                                : '${myBox.get('_accuracyOfHighest60SecondWpm')}%',
                            style: TextStyle(
                              color: Colors.pink,
                              fontSize:
                                  MediaQuery.of(context).size.shortestSide *
                                      0.02,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            '120 seconds',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            myBox.get('_highest120SecondWpm') == 0
                                ? '-'
                                : '${myBox.get('_highest120SecondWpm')}',
                            style: TextStyle(
                                color: Colors.pink,
                                fontSize:
                                    MediaQuery.of(context).size.shortestSide *
                                        0.07), // or 0.04
                          ),
                          Text(
                            myBox.get('_highest120SecondWpm') == 0
                                ? '-'
                                : '${myBox.get('_accuracyOfHighest120SecondWpm')}%',
                            style: TextStyle(
                              color: Colors.pink,
                              fontSize:
                                  MediaQuery.of(context).size.shortestSide *
                                      0.02,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.05,
                ),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 29, 2, 40),
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),
                  child: BarChart(
                    BarChartData(
                        minY: 0,
                        maxY: tenMostMissedWordsIndexes.isNotEmpty
                            ? (myBoxOfMissedWordCounters
                                    .getAt(tenMostMissedWordsIndexes[0]) +
                                1)
                            : 0,
                        groupsSpace: 12,
                        gridData: const FlGridData(
                          drawVerticalLine: false,
                          drawHorizontalLine: false,
                        ),
                        titlesData: FlTitlesData(
                          show: true,
                          topTitles: AxisTitles(
                            axisNameSize:
                                MediaQuery.of(context).size.height * 0.05,
                            axisNameWidget: const Text(
                              'most missed words',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                          rightTitles: const AxisTitles(),
                          leftTitles: const AxisTitles(),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                                reservedSize:
                                    MediaQuery.of(context).size.height * 0.05,
                                showTitles: true,
                                interval: 1,
                                getTitlesWidget: (value, meta) => Padding(
                                      padding: EdgeInsets.only(
                                          top: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.01),
                                      child: Text(
                                        tenMostMissedWordsIndexes.isNotEmpty
                                            ? '${myBoxOfMissedWordCounters.keyAt(tenMostMissedWordsIndexes[value.toInt()])}'
                                            : '',
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .shortestSide *
                                                0.015),
                                      ),
                                    )),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        barTouchData: BarTouchData(
                          enabled: true,
                          touchTooltipData: BarTouchTooltipData(
                            tooltipBgColor: Colors.black.withOpacity(0.5),
                          ),
                        ),
                        barGroups: List.generate(
                            tenMostMissedWordsIndexes.length, (index) {
                          return BarChartGroupData(x: index, barRods: [
                            BarChartRodData(
                              toY: (myBoxOfMissedWordCounters.getAt(
                                      tenMostMissedWordsIndexes[index])) ??
                                  0,
                              width: MediaQuery.of(context).size.width * 0.05,
                              color: Colors.pink,
                              borderRadius: BorderRadius.circular(0),
                            )
                          ]);
                        })),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.05,
                    bottom: MediaQuery.of(context).size.height * .1),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 29, 2, 40),
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * .35,
                    child: LineChart(
                      LineChartData(
                        minX: 1,
                        maxX: myBox.get('_numTestsStarted'),
                        minY: 0,
                        maxY: myBox.get('_highestWpm') +
                            (10 - myBox.get('_highestWpm') % 10),
                        gridData: const FlGridData(
                          drawHorizontalLine: false,
                          drawVerticalLine: false,
                        ),
                        lineBarsData: List.generate(1, (index) {
                          return LineChartBarData(
                            isCurved: true,
                            belowBarData: BarAreaData(
                              show: true,
                              color: Colors.pink.withOpacity(0.03),
                            ),
                            color: Colors.pink,
                            spots: List.generate(
                              myBoxOfPrevTestWpms.length,
                              (index) => FlSpot(index.toDouble() + 1,
                                  myBoxOfPrevTestWpms.getAt(index)),
                            ),
                            isStepLineChart: true,
                          );
                        }),
                        titlesData: FlTitlesData(
                          show: true,
                          topTitles: AxisTitles(
                            axisNameSize:
                                MediaQuery.of(context).size.height * 0.05,
                            axisNameWidget: const Text(
                              'past tests',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                          rightTitles: AxisTitles(
                            axisNameWidget: const Text(''),
                            axisNameSize:
                                MediaQuery.of(context).size.height * 0.05,
                          ),
                          leftTitles: AxisTitles(
                            axisNameWidget: Text(
                              'words per minute',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize:
                                      MediaQuery.of(context).size.shortestSide *
                                          0.015),
                            ),
                            axisNameSize:
                                MediaQuery.of(context).size.height * 0.05,
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              getTitlesWidget: (value, meta) => Text(
                                  value == 1 ? '' : '$value',
                                  style: const TextStyle(color: Colors.grey)),
                              showTitles: true,
                              interval: 10,
                            ),
                          ),
                        ),
                        borderData: FlBorderData(
                          show: true,
                          border: const Border(
                            top: BorderSide(width: 0),
                            right: BorderSide(width: 0),
                            bottom: BorderSide(width: 0),
                            left: BorderSide(width: 0),
                          ),
                        ),
                        lineTouchData: LineTouchData(
                          touchTooltipData: LineTouchTooltipData(
                            tooltipBgColor: Colors.black.withOpacity(0.5),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
