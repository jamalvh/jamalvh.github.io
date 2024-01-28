import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';
import 'profile.dart';
//pub.dev
import 'package:group_button/group_button.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController textEditingController = TextEditingController();
  GroupButtonController groupButtonController = GroupButtonController();

  List<String> wordsDatabase = [
    "the",
    "be",
    "and",
    "a",
    "of",
    "to",
    "in",
    "I",
    "you",
    "it",
    "have",
    "to",
    "that",
    "for",
    "do",
    "he",
    "with",
    "on",
    "this",
    "we",
    "that",
    "not",
    "but",
    "they",
    "say",
    "at",
    "what",
    "his",
    "from",
    "go",
    "or",
    "by",
    "get",
    "she",
    "my",
    "can",
    "as",
    "know",
    "if",
    "me",
    "your",
    "all",
    "who",
    "about",
    "their",
    "will",
    "so",
    "would",
    "make",
    "just",
    "up",
    "think",
    "time",
    "there",
    "see",
    "her",
    "as",
    "out",
    "one",
    "come",
    "people",
    "take",
    "year",
    "him",
    "them",
    "some",
    "want",
    "how",
    "when",
    "which",
    "now",
    "like",
    "other",
    "could",
    "your",
    "into",
    "here",
    "then",
    "than",
    "look",
    "way",
    "more",
    "these",
    "no",
    "thing",
    "well",
    "because",
    "also",
    "however",
    "point",
    "ask",
    "change",
    "course",
    "another",
    "write",
    "child",
    "need"
  ];

  List<List<dynamic>> words = [];
  String wordsAsString = '';
  bool done = true;
  double wpm = 0;
  double wpmSaverOnInGameGenerate = 0;
  double acc = 0; //totalLetters-mistakes / totalLetters
  double mistakesSaverOnInGameGenerate = 0;
  double totalLettersSaverOnInGameGenerate = 0;
  // ignore: unused_field
  late Timer _timer;
  int timeSelected = 15;
  int remainingTime = 15;

  //SAVEDVARS
  var myBox = Hive.box('highscores');
  var myBoxOfPrevTestWpms = Hive.box('prevTestsWpms'); // int
  var myBoxOfMissedWordCounters =
      Hive.box('missedWordCounters'); // key: word, value: times missed

  int highest15SecondWpm = 0;
  int highest30SecondWpm = 0;
  int highest60SecondWpm = 0;
  int highest120SecondWpm = 0;

  int overallAverageWpm = 0;

  void startTimer() {
    remainingTime = timeSelected;
    wpm = 0;
    genRandomWords();
    setState(() {});
    done = false;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime > 0) {
        setState(() {
          remainingTime--;
        });
      } else {
        timer.cancel();
        setState(() {
          done = true;
          textEditingController.clear();

          //check if overall highscore
          if (wpm > myBox.get('_highestWpm')) {
            setState(() {
              myBox.put('_highestWpm', wpm);
            });
          }
          setState(() {
            //add to records
            myBoxOfPrevTestWpms.add(wpm);

            //update average
            if (overallAverageWpm == 0) {
              overallAverageWpm = wpm.toInt();
            } else {
              overallAverageWpm =
                  ((overallAverageWpm * myBoxOfPrevTestWpms.length) + wpm) ~/
                      (myBoxOfPrevTestWpms.length + 1);
            }
            myBox.put('_overallAverageWpm', overallAverageWpm);
          });
        });
      }
    });
  }

  void genRandomWords() {
    Random random = Random();
    words.clear();
    wordsAsString = '';
    for (int i = 0; i < MediaQuery.of(context).size.width * .03; i++) {
      words.add([wordsDatabase[random.nextInt(wordsDatabase.length)], 2]);
    }
  }

  determineColor(int ind) {
    if (words[ind][1] == 0) {
      return Colors.white;
    } else if (words[ind][1] == 1) {
      return Colors.red;
    } else {
      return Colors.grey;
    }
  }

  @override
  void dispose() {
    textEditingController.dispose();
    groupButtonController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    //get running average
    if (!myBox.containsKey('_overallAverageWpm')) {
      myBox.put('_overallAverageWpm', 0);
    } else {
      overallAverageWpm = myBox.get('_overallAverageWpm');
    }

    //get number of tests started
    if (!myBox.containsKey('_numTestsStarted')) {
      myBox.put('_numTestsStarted', 0);
    }
    //get overall highscore
    if (!myBox.containsKey('_highestWpm')) {
      myBox.put('_highestWpm', 0);
    }
    //get 15 second highscore
    if (!myBox.containsKey('_highest15SecondWpm')) {
      myBox.put('_highest15SecondWpm', 0);
      myBox.put('_accuracyOfHighest15SecondWpm', 0);
    } else {
      highest15SecondWpm = myBox.get('_highest15SecondWpm');
    }
    //get 30 second highscore
    if (!myBox.containsKey('_highest30SecondWpm')) {
      myBox.put('_highest30SecondWpm', 0);
      myBox.put('_accuracyOfHighest30SecondWpm', 0);
    } else {
      highest30SecondWpm = myBox.get('_highest30SecondWpm');
    }
    //get 60 second highscore
    if (!myBox.containsKey('_highest60SecondWpm')) {
      myBox.put('_highest60SecondWpm', 0);
      myBox.put('_accuracyOfHighest60SecondWpm', 0);
    } else {
      highest60SecondWpm = myBox.get('_highest60SecondWpm');
    }
    //get 120 second highscore
    if (!myBox.containsKey('_highest120SecondWpm')) {
      myBox.put('_highest120SecondWpm', 0);
      myBox.put('_accuracyOfHighest120SecondWpm', 0);
    } else {
      highest120SecondWpm = myBox.get('_highest120SecondWpm');
    }
    groupButtonController.selectIndex(0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 32, 1, 46),
      appBar: AppBar(
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
              null;
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
      body: Center(
        child: Column(
          children: [
            Container(
              height: 38,
              decoration: BoxDecoration(
                  color: done
                      ? const Color.fromARGB(255, 29, 2, 40)
                      : const Color.fromARGB(255, 32, 1, 46),
                  borderRadius: const BorderRadius.all(Radius.circular(8))),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 0),
                child: SizedBox(
                  width: 250,
                  child: done
                      ? GroupButton(
                          controller: groupButtonController,
                          options: const GroupButtonOptions(
                            buttonHeight: 30,
                            spacing: 0,
                            selectedColor: Color.fromARGB(255, 29, 2, 40),
                            unselectedColor: Color.fromARGB(255, 29, 2, 40),
                            selectedTextStyle: TextStyle(color: Colors.pink),
                            unselectedTextStyle: TextStyle(color: Colors.grey),
                            elevation: 0,
                          ),
                          buttons: const ['15', '30', '60', '120'],
                          onSelected: (value, index, isSelected) {
                            if (done) {
                              setState((() {
                                timeSelected = int.parse(value);
                                remainingTime = timeSelected;
                              }));
                            } else {
                              null;
                            }
                          },
                        )
                      : null,
                ),
              ),
            ),
            //RESULTS SCREEN
            if (done)
              Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * .10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.11,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'wpm',
                                    style: TextStyle(
                                      color: done ? Colors.grey : Colors.pink,
                                      fontSize: done ? 24 : 25,
                                    ),
                                  ),
                                  Text(
                                    wpm == 0.0 ? '-' : '$wpm',
                                    style: TextStyle(
                                        color: Colors.pink,
                                        fontSize: MediaQuery.of(context)
                                                .size
                                                .shortestSide *
                                            0.075), // or 0.04
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.11,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'acc',
                                    style: TextStyle(
                                      color: done ? Colors.grey : Colors.pink,
                                      fontSize: done ? 24 : 25,
                                    ),
                                  ),
                                  Text(
                                    acc == 0 ? '-' : '${acc.toInt()}%',
                                    style: TextStyle(
                                        color: Colors.pink,
                                        fontSize: MediaQuery.of(context)
                                                .size
                                                .shortestSide *
                                            0.075), // or 0.04
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 15),
                      width: MediaQuery.of(context).size.width * .64,
                      height: MediaQuery.of(context).size.height * .35,
                      child: LineChart(
                        LineChartData(
                          minX: 1,
                          maxX: myBox.get('_numTestsStarted'),
                          minY: 0,
                          maxY: myBox.get('_highestWpm') +
                              (10 - myBox.get('_highestWpm') % 10),
                          gridData: FlGridData(
                            horizontalInterval:
                                myBox.get('_highestWpm') > 50 ? 30 : 10,
                            drawVerticalLine: false,
                            getDrawingHorizontalLine: (value) {
                              return const FlLine(
                                color: Color.fromARGB(255, 44, 44, 44),
                                dashArray: [1, 0],
                              );
                            },
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
                              isStepLineChart: false,
                            );
                          }),
                          titlesData: FlTitlesData(
                            topTitles: const AxisTitles(),
                            rightTitles: const AxisTitles(),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                getTitlesWidget: (value, meta) => Text(
                                    value == 1 ? '' : '$value',
                                    style: const TextStyle(color: Colors.grey)),
                                showTitles: true,
                                interval: 10,
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                getTitlesWidget: (value, meta) => Text(
                                    value == 0 ? '' : '$value',
                                    style: const TextStyle(color: Colors.grey)),
                                showTitles: true,
                                interval:
                                    myBox.get('_highestWpm') > 50 ? 50 : 10,
                                reservedSize: 38,
                              ),
                            ),
                          ),
                          borderData: FlBorderData(
                            show: true,
                            border: const Border(
                              top: BorderSide(width: 0),
                              right: BorderSide(width: 0),
                              bottom: BorderSide(width: 1),
                              left: BorderSide(width: 1),
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
                  ],
                ),
              ),
            //TEST SCREEN
            if (!done)
              Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * .16),
                child: Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '$remainingTime',
                            style: TextStyle(
                              color: done ? Colors.grey : Colors.pink,
                              fontSize: done ? 24 : 25,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.75,
                        child: Wrap(
                          children: List.generate(words.length, (index) {
                            return Text(
                              '${words[index][0]} ',
                              style: TextStyle(
                                  color: determineColor(index),
                                  fontSize:
                                      MediaQuery.of(context).size.shortestSide *
                                          0.035), // or 0.04
                            );
                          }),
                        ),
                      ),
                    ),
                    if (!done)
                      Container(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * .03),
                        width: MediaQuery.of(context).size.width * 0.75,
                        child: TextField(
                          enabled: done ? false : true,
                          onChanged: (value) {
                            var word = '';
                            var wpmChecker = wpmSaverOnInGameGenerate;
                            var count = 0;
                            var ind = 0;
                            var mistakesChecker = mistakesSaverOnInGameGenerate;
                            var totalLettersChecker =
                                totalLettersSaverOnInGameGenerate;
                            if (!done) {
                              for (int i = 0;
                                  i < textEditingController.text.length;
                                  i++) {
                                if (textEditingController.text[i] == ' ') {
                                  totalLettersChecker += words[count][0].length;
                                  if (word == words[count][0]) {
                                    wpmChecker += 1;
                                    words[count][1] = 0;
                                  } else {
                                    if (words[count][1] == 2) {
                                      //if first time for this instance
                                      //then add to missed word count
                                      if (!myBoxOfMissedWordCounters
                                          .containsKey('${words[count][0]}')) {
                                        myBoxOfMissedWordCounters.put(
                                            '${words[count][0]}', 1);
                                      } else {
                                        myBoxOfMissedWordCounters.put(
                                            '${words[count][0]}',
                                            (myBoxOfMissedWordCounters
                                                    .get('${words[count][0]}') +
                                                1));
                                      }
                                    }
                                    words[count][1] = 1;
                                    mistakesChecker +=
                                        words[count][0].length - word.length;
                                  }
                                  word = '';
                                  count++;
                                  ind = 0;
                                  if (count > words.length - 1) {
                                    count = 0;
                                    wpmSaverOnInGameGenerate = wpmChecker;
                                    mistakesSaverOnInGameGenerate =
                                        mistakesChecker;
                                    totalLettersSaverOnInGameGenerate =
                                        totalLettersChecker;
                                    textEditingController.clear();
                                    genRandomWords();
                                  }
                                } else {
                                  word += textEditingController.text[i];
                                  if (ind + 1 > (words[count][0]).length) {
                                    if (words[count][1] == 2) {
                                      //if first time for this instance
                                      //then add to missed word count
                                      if (myBoxOfMissedWordCounters
                                          .containsKey('${words[count][0]}')) {
                                        myBoxOfMissedWordCounters.put(
                                            '${words[count][0]}', 1);
                                      } else {
                                        myBoxOfMissedWordCounters.put(
                                            '${words[count][0]}',
                                            (myBoxOfMissedWordCounters
                                                    .get('${words[count][0]}') +
                                                1));
                                      }
                                    }
                                    words[count][1] = 1;
                                    mistakesChecker++;
                                  } else if (textEditingController.text[i] ==
                                      words[count][0][ind]) {
                                    words[count][1] = 0;
                                  } else {
                                    if (words[count][1] == 2) {
                                      //if first time for this instance
                                      //then add to missed word count
                                      if (!myBoxOfMissedWordCounters
                                          .containsKey('${words[count][0]}')) {
                                        myBoxOfMissedWordCounters.put(
                                            '${words[count][0]}', 1);
                                      } else {
                                        myBoxOfMissedWordCounters.put(
                                            '${words[count][0]}',
                                            (myBoxOfMissedWordCounters
                                                    .get('${words[count][0]}') +
                                                1));
                                      }
                                    }
                                    words[count][1] = 1; //1 means wrong = red
                                    mistakesChecker++;
                                  }
                                  ind++;
                                }
                                // TODO: figure out why wpm is always even result
                                wpm = wpmChecker *
                                    (60 / timeSelected); // 15s * 4 = 60s
                                acc = ((totalLettersChecker - mistakesChecker) /
                                        totalLettersChecker) *
                                    100;
                                if (acc < 0) {
                                  acc = 0;
                                } // part/whole * 100%

                                setState(() {});
                              }
                              //UPDATE HIGHSCORES
                              if (timeSelected == 15) {
                                if (wpm > highest15SecondWpm) {
                                  setState(() {
                                    highest15SecondWpm = wpm.toInt();
                                    myBox.put('_highest15SecondWpm',
                                        highest15SecondWpm);
                                    myBox.put('_accuracyOfHighest15SecondWpm',
                                        acc.toInt());
                                  });
                                }
                              } else if (timeSelected == 30) {
                                if (wpm > highest30SecondWpm) {
                                  setState(() {
                                    highest30SecondWpm = wpm.toInt();
                                    myBox.put('_highest30SecondWpm',
                                        highest30SecondWpm);
                                    myBox.put('_accuracyOfHighest30SecondWpm',
                                        acc.toInt());
                                  });
                                }
                              } else if (timeSelected == 60) {
                                if (wpm > highest60SecondWpm) {
                                  setState(() {
                                    highest60SecondWpm = wpm.toInt();
                                    myBox.put('_highest60SecondWpm',
                                        highest60SecondWpm);
                                    myBox.put('_accuracyOfHighest60SecondWpm',
                                        acc.toInt());
                                  });
                                }
                              } else if (timeSelected == 120) {
                                if (wpm > highest120SecondWpm) {
                                  setState(() {
                                    highest120SecondWpm = wpm.toInt();
                                    myBox.put('_highest120SecondWpm',
                                        highest120SecondWpm);
                                    myBox.put('_accuracyOfHighest120SecondWpm',
                                        acc.toInt());
                                  });
                                }
                              }
                            }
                          },
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                          minLines: 1,
                          maxLines: 5,
                          controller: textEditingController,
                        ),
                      ),
                  ],
                ),
              ),
            Container(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * .03),
              width: MediaQuery.of(context).size.width * 0.75,
              child: Column(
                children: [
                  IconButton(
                    onPressed: () {
                      myBox.put('_numTestsStarted',
                          myBox.get('_numTestsStarted') + 1);
                      wpmSaverOnInGameGenerate = 0;
                      mistakesSaverOnInGameGenerate = 0;
                      totalLettersSaverOnInGameGenerate = 0;
                      done ? startTimer() : null;
                    },
                    style: ButtonStyle(
                        foregroundColor: done
                            ? const MaterialStatePropertyAll(Colors.white)
                            : const MaterialStatePropertyAll(Colors.white10)),
                    icon: const Icon(Icons.refresh),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
