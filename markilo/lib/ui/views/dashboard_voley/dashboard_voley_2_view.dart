import 'dart:async';
import 'dart:html';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:markilo/providers/home_provider.dart';
import 'package:markilo/router/router.dart';
import 'package:markilo/services/navigation_service.dart';
import 'package:markilo/ui/shared/widgets/team_name.dart';
import 'package:provider/provider.dart';

class DashboardVoley2View extends StatefulWidget {
  const DashboardVoley2View({super.key});

  @override
  DashboardVoley2ViewState createState() => DashboardVoley2ViewState();
}

class DashboardVoley2ViewState extends State<DashboardVoley2View> {
  bool isRunning = false;
  int seconds = 0;
  Timer? timer;
  List<bool> leftCircles = [false, false];
  List<bool> rightCircles = [false, false];
  bool appLoaded = false;
  bool localEmblemLeft = true;
  bool fullScreenActivated = false;
  TextEditingController? _nameLeftcontroller;
  TextEditingController? _nameRightcontroller;

  late HomeProvider homeProvider;
  late Size size;

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        seconds++;
      });
    });
  }

  void stopTimer() {
    timer?.cancel();
  }

  void resetTimer() {
    setState(() {
      seconds = 0;
    });
  }

  String get timerText {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();
    homeProvider = Provider.of<HomeProvider>(context, listen: false);
    _nameLeftcontroller = TextEditingController(text: '<Local>');
    _nameRightcontroller = TextEditingController(text: '<Visitante>');
    homeProvider.localTeamName =
        TeamName(controller: _nameLeftcontroller, color: Colors.white);
    homeProvider.visitTeamName =
        TeamName(controller: _nameRightcontroller, color: Colors.white);
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    size = MediaQuery.of(context).size;
    if (!appLoaded) {
      homeProvider.localEmblem = Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Image.asset(
          //'assets/images/escudo.png',
          'assets/images/sm.png',
          width: size.width * 0.15,
          height: size.width * 0.15,
        ),
      );
      homeProvider.visitEmblem = Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Image.asset(
          //'assets/images/escudo.png',
          'assets/images/bell.png',
          width: size.width * 0.15,
          height: size.width * 0.15,
        ),
      );
      appLoaded = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Side
              Expanded(
                child: Container(
                  color: Colors.blue,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 120,
                            height: 120,
                            child: homeProvider.localServe
                                ? GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        homeProvider.toggleServe();
                                      });
                                    },
                                    child: const Icon(
                                      Icons.sports_volleyball,
                                      color: Colors.white,
                                      size: 120,
                                    ),
                                  )
                                : null,
                          ),
                          const SizedBox(
                            width: 40,
                          ),
                          GestureDetector(
                            onLongPress: () {
                              setState(() {
                                if (homeProvider.scoreLeft > 0) {
                                  --homeProvider.scoreLeft;
                                }
                              });
                            },
                            onTap: () {
                              setState(() {
                                ++homeProvider.scoreLeft;
                                if (!homeProvider.localServe) {
                                  homeProvider.toggleServe();
                                }
                              });
                            },
                            child: localEmblemLeft
                                ? homeProvider.localEmblem
                                : homeProvider.visitEmblem,
                          ),
                          const SizedBox(
                            width: 160,
                            height: 120,
                          ),
                        ],
                      ),
                      localEmblemLeft
                          ? homeProvider.visitTeamName!
                          : homeProvider.localTeamName!,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: screenWidth * 0.01,
                          ),
                          Column(
                            children: List.generate(2, (index) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    leftCircles[index] = !leftCircles[index];
                                  });
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: screenHeight * 0.011,
                                      horizontal: screenWidth * 0.01),
                                  width: screenHeight * 0.11,
                                  height: screenHeight * 0.11,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: leftCircles[index]
                                        ? Colors.white
                                        : Colors.transparent,
                                    border: Border.all(
                                        color: Colors.white,
                                        width: screenHeight *
                                            0.0075), // Borde más grueso
                                  ),
                                ),
                              );
                            }),
                          ),
                          const Spacer(),
                          Baseline(
                            baseline: screenHeight * 0.42,
                            baselineType: TextBaseline.alphabetic,
                            child: Text(
                              homeProvider.scoreLeft.toString().padLeft(2, '0'),
                              style: GoogleFonts.oswald(
                                color: Colors.white,
                                fontSize: screenHeight * 0.5, // Más grande aún
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: screenWidth * 0.09,
                          ),
                        ],
                      ),
                      Spacer(),
                    ],
                  ),
                ),
              ),
              // Right Side
              Expanded(
                child: Container(
                  color: Colors.black,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: 160,
                            height: 120,
                          ),
                          GestureDetector(
                            onLongPress: () {
                              setState(() {
                                if (homeProvider.scoreLeft > 0) {
                                  --homeProvider.scoreRight;
                                }
                              });
                            },
                            onTap: () {
                              setState(() {
                                ++homeProvider.scoreRight;
                                if (homeProvider.localServe) {
                                  homeProvider.toggleServe();
                                  debugPrint(
                                      homeProvider.localServe.toString());
                                }
                              });
                            },
                            child: localEmblemLeft
                                ? homeProvider.visitEmblem
                                : homeProvider.localEmblem,
                          ),
                          const SizedBox(
                            width: 40,
                          ),
                          SizedBox(
                            width: 120,
                            height: 120,
                            child: !homeProvider.localServe
                                ? GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        homeProvider.toggleServe();
                                      });
                                    },
                                    child: const Icon(
                                      Icons.sports_volleyball,
                                      color: Colors.white,
                                      size: 120,
                                    ),
                                  )
                                : null,
                          ),
                        ],
                      ),
                      localEmblemLeft
                          ? homeProvider.localTeamName!
                          : homeProvider.visitTeamName!,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: screenWidth * 0.1,
                          ),
                          Baseline(
                            baseline: screenHeight * 0.42,
                            baselineType: TextBaseline.alphabetic,
                            child: Text(
                              homeProvider.scoreRight
                                  .toString()
                                  .padLeft(2, '0'),
                              style: GoogleFonts.oswald(
                                color: Colors.white,
                                fontSize: screenHeight * 0.5, // Más grande aún
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Spacer(),
                          Column(
                            children: List.generate(2, (index) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    rightCircles[index] = !rightCircles[index];
                                  });
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: screenHeight * 0.011,
                                      horizontal: screenWidth * 0.01),
                                  width: screenHeight * 0.11,
                                  height: screenHeight * 0.11,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: rightCircles[index]
                                        ? Colors.white
                                        : Colors.transparent,
                                    border: Border.all(
                                        color: Colors.white,
                                        width: screenHeight *
                                            0.0075), // Borde más grueso
                                  ),
                                ),
                              );
                            }),
                          ),
                          SizedBox(
                            width: screenWidth * 0.01,
                          ),
                        ],
                      ),
                      Spacer(),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Middle overlay with timer and popup menu
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: screenWidth * 0.25,
              height: screenHeight * 0.24,
              decoration: BoxDecoration(
                  color: Colors.grey[850],
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  )),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(
                          isRunning ? Icons.pause : Icons.play_arrow,
                          color: Colors.white,
                          size: 36,
                        ),
                        onPressed: () {
                          setState(() {
                            isRunning = !isRunning;
                            if (isRunning) {
                              startTimer();
                            } else {
                              stopTimer();
                            }
                          });
                        },
                      ),
                      Text(
                        timerText,
                        style: GoogleFonts.oswald(
                          color: Colors.white,
                          fontSize: screenHeight * 0.12,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.restore_outlined,
                          color: Colors.white,
                          size: 36,
                        ),
                        onPressed: () {
                          stopTimer();
                          resetTimer();
                        },
                      ),
                    ],
                  ),
                  PopupMenuButton<int>(
                    icon: const Icon(Icons.arrow_drop_down,
                        color: Colors.white, size: 30.0),
                    offset: Offset(-85, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    color: Colors.grey[850],
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.edit,
                                    color: Colors.white)),
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    if (!fullScreenActivated) {
                                      document.documentElement
                                          ?.requestFullscreen();
                                      fullScreenActivated = true;
                                    } else {
                                      document.exitFullscreen();
                                      fullScreenActivated = false;
                                    }
                                  });
                                },
                                icon: !fullScreenActivated
                                    ? const Icon(Icons.fullscreen,
                                        color: Colors.white)
                                    : const Icon(Icons.fullscreen_exit,
                                        color: Colors.white)),
                            IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.compare_arrows,
                                    color: Colors.white)),
                            IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.edit,
                                    color: Colors.white)),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                                onPressed: () {
                                  NavigationService.replaceTo(
                                      Flurorouter.homeRoute);
                                },
                                icon: Icon(Icons.home, color: Colors.white)),
                            IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.refresh,
                                    color: Colors.white)),
                            IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.laptop,
                                    color: Colors.white)),
                            IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.settings,
                                    color: Colors.white)),
                          ],
                        ),
                      ),
                    ],
                    onSelected: (value) {
                      // Handle menu item selection
                    },
                  )
                ],
              ),
            ),
          ),
          // Middle overlay with secondary score
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  homeProvider.setLeft.toString(),
                  style: GoogleFonts.oswald(
                    color: Colors.white,
                    fontSize: screenHeight * 0.18, // 30% más pequeño
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: screenHeight * 0.1),
                Text(
                  homeProvider.setRight.toString(),
                  style: GoogleFonts.oswald(
                    color: Colors.white,
                    fontSize: screenHeight * 0.18, // 30% más pequeño
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
