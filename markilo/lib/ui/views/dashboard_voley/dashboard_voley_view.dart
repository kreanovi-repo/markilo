import 'dart:async';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:markilo/models/configuration/team/team_configuration.dart';
import 'package:markilo/providers/home_provider.dart';
import 'package:markilo/router/router.dart';
import 'package:markilo/services/local_storage.dart';
import 'package:markilo/services/navigation_service.dart';
import 'package:markilo/types/constants.dart';
import 'package:markilo/ui/shared/widgets/team_name.dart';
import 'package:provider/provider.dart';
import 'package:universal_html/html.dart';

class DashboardVoley2View extends StatefulWidget {
  const DashboardVoley2View({super.key});

  @override
  DashboardVoley2ViewState createState() => DashboardVoley2ViewState();
}

class DashboardVoley2ViewState extends State<DashboardVoley2View> {
  List<bool> leftCircles = [false, false];
  List<bool> rightCircles = [false, false];
  bool appLoaded = false;
  bool fullScreenActivated = false;
  TextEditingController? _nameLeftcontroller;
  TextEditingController? _nameRightcontroller;

  late HomeProvider homeProvider;
  late Size size;
  late TimeCircles leftTimeCircles;
  late TimeCircles rightTimeCircles;

  @override
  void initState() {
    super.initState();
    homeProvider = Provider.of<HomeProvider>(context, listen: false);
    _nameLeftcontroller = TextEditingController(text: '<LOCAL>');
    _nameRightcontroller = TextEditingController(text: '<VISITANTE>');
    leftTimeCircles = TimeCircles(
        circles: leftCircles,
        backgroundColor: homeProvider.localBackgroundColor,
        textColor: homeProvider.localTextColor);
    rightTimeCircles = TimeCircles(
        circles: rightCircles,
        backgroundColor: homeProvider.visitBackgroundColor,
        textColor: homeProvider.visitTextColor);
  }

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    size = MediaQuery.of(context).size;
    /*Uint8List? localEmblem =
        await homeProvider.loadImageLocalTeamFromLocalStorage();
    if (null != localEmblem) {
      homeProvider.localEmblemFile = PlatformFile(
        name: 'local_emblem.png',
        size: localEmblem.length,
        bytes: localEmblem,
      );
    }

    Color? backgroundColor =
        await homeProvider.loadBackgroundColorFromLocalStorage();
    if (null != backgroundColor) {
      homeProvider.localBackgroundColor = backgroundColor;
    }

    Color? textColor = await homeProvider.loadTextColorFromLocalStorage();
    if (null != textColor) {
      homeProvider.localTextColor = textColor;
    }*/

    TeamConfiguration? localConfig =
        await homeProvider.loadConfigurationFromStorage(true);
    if (null != localConfig) {
      homeProvider.localEmblemFile = localConfig.platformFile;
      homeProvider.localBackgroundColor = localConfig.backgroundColor;
      homeProvider.localTextColor = localConfig.textColor;
    }

    TeamConfiguration? visitConfig =
        await homeProvider.loadConfigurationFromStorage(false);
    if (null != visitConfig) {
      homeProvider.visitEmblemFile = visitConfig.platformFile;
      homeProvider.visitBackgroundColor = visitConfig.backgroundColor;
      homeProvider.visitTextColor = visitConfig.textColor;
    }

    int? scoreLeft = LocalStorage.prefs.getInt(Constants.scoreLeftValue);
    homeProvider.scoreLeft = scoreLeft ?? 0;
    int? scoreRight = LocalStorage.prefs.getInt(Constants.scoreRightValue);
    homeProvider.scoreRight = scoreRight ?? 0;
    int? setLeft = LocalStorage.prefs.getInt(Constants.setLeftValue);
    homeProvider.setLeft = setLeft ?? 0;
    int? setRight = LocalStorage.prefs.getInt(Constants.setRightValue);
    homeProvider.setRight = setRight ?? 0;

    String? localTeamName =
        LocalStorage.prefs.getString(Constants.localTeamNameValue);
    if (null != localTeamName) {
      _nameLeftcontroller!.text = localTeamName.toUpperCase();
    }

    String? visitTeamName =
        LocalStorage.prefs.getString(Constants.visitTeamNameValue);
    if (null != visitTeamName) {
      _nameRightcontroller!.text = visitTeamName.toUpperCase();
    }

    if (!appLoaded) {
      refreshComponents();
      appLoaded = true;
    }
  }

  void refreshComponents() {
    homeProvider.localEmblem = Padding(
      padding: const EdgeInsets.only(top: 10),
      child: null != homeProvider.localEmblemFile
          ? Image.memory(
              homeProvider.localEmblemFile!.bytes!,
              width: size.width * 0.15,
              height: size.width * 0.15,
            )
          : Image.asset(
              'assets/images/escudo.png',
              width: size.width * 0.15,
              height: size.width * 0.15,
            ),
    );
    homeProvider.visitEmblem = Padding(
      padding: const EdgeInsets.only(top: 10),
      child: null != homeProvider.visitEmblemFile
          ? Image.memory(
              homeProvider.visitEmblemFile!.bytes!,
              width: size.width * 0.15,
              height: size.width * 0.15,
            )
          : Image.asset(
              'assets/images/escudo.png',
              width: size.width * 0.15,
              height: size.width * 0.15,
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    homeProvider.localTeamName = TeamName(
        controller: _nameLeftcontroller,
        color: homeProvider.localTextColor,
        onChanged: (value) {
          homeProvider.saveLocalTeamName(value);
        });
    homeProvider.visitTeamName = TeamName(
        controller: _nameRightcontroller,
        color: homeProvider.visitTextColor,
        onChanged: (value) {
          homeProvider.saveVisitTeamName(value);
        });
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
                  color: homeProvider.localEmblemLeft
                      ? homeProvider.localBackgroundColor
                      : homeProvider.visitBackgroundColor,
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
                                    child: Icon(
                                      Icons.sports_volleyball,
                                      color: homeProvider.localEmblemLeft
                                          ? homeProvider.localTextColor
                                          : homeProvider.visitTextColor,
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
                                if (homeProvider.localEmblemLeft) {
                                  if (homeProvider.scoreLeft > 0) {
                                    homeProvider.decrementScoreLeft();
                                  }
                                } else {
                                  if (homeProvider.scoreRight > 0) {
                                    homeProvider.decrementScoreRight();
                                  }
                                }
                              });
                            },
                            onTap: () {
                              setState(() {
                                if (homeProvider.localEmblemLeft) {
                                  homeProvider.incrementScoreLeft();
                                  if (!homeProvider.localServe) {
                                    homeProvider.toggleServe();
                                  }
                                } else {
                                  homeProvider.incrementScoreRight();
                                  if (!homeProvider.localServe) {
                                    homeProvider.toggleServe();
                                  }
                                }
                              });
                            },
                            child: homeProvider.localEmblemLeft
                                ? homeProvider.localEmblem
                                : homeProvider.visitEmblem,
                          ),
                          const SizedBox(
                            width: 160,
                            height: 120,
                          ),
                        ],
                      ),
                      homeProvider.localEmblemLeft
                          ? homeProvider.localTeamName!
                          : homeProvider.visitTeamName!,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: screenWidth * 0.01,
                          ),
                          homeProvider.localEmblemLeft
                              ? leftTimeCircles
                              : rightTimeCircles,
                          const Spacer(),
                          Baseline(
                            baseline: screenHeight * 0.42,
                            baselineType: TextBaseline.alphabetic,
                            child: Text(
                              homeProvider.localEmblemLeft
                                  ? homeProvider.scoreLeft
                                      .toString()
                                      .padLeft(2, '0')
                                  : homeProvider.scoreRight
                                      .toString()
                                      .padLeft(2, '0'),
                              style: GoogleFonts.oswald(
                                color: homeProvider.localEmblemLeft
                                    ? homeProvider.localTextColor
                                    : homeProvider.visitTextColor,
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
                      const Spacer(),
                    ],
                  ),
                ),
              ),
              // Right Side
              Expanded(
                child: Container(
                  color: homeProvider.localEmblemLeft
                      ? homeProvider.visitBackgroundColor
                      : homeProvider.localBackgroundColor,
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
                                if (homeProvider.localEmblemLeft) {
                                  if (homeProvider.scoreRight > 0) {
                                    homeProvider.decrementScoreRight();
                                  }
                                } else {
                                  if (homeProvider.scoreLeft > 0) {
                                    homeProvider.decrementScoreLeft();
                                  }
                                }
                              });
                            },
                            onTap: () {
                              setState(() {
                                if (homeProvider.localEmblemLeft) {
                                  homeProvider.incrementScoreRight();
                                  if (homeProvider.localServe) {
                                    homeProvider.toggleServe();
                                  }
                                } else {
                                  homeProvider.incrementScoreLeft();
                                  if (homeProvider.localServe) {
                                    homeProvider.toggleServe();
                                  }
                                }
                              });
                            },
                            child: homeProvider.localEmblemLeft
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
                                    child: Icon(
                                      Icons.sports_volleyball,
                                      color: homeProvider.localEmblemLeft
                                          ? homeProvider.visitTextColor
                                          : homeProvider.localTextColor,
                                      size: 120,
                                    ),
                                  )
                                : null,
                          ),
                        ],
                      ),
                      homeProvider.localEmblemLeft
                          ? homeProvider.visitTeamName!
                          : homeProvider.localTeamName!,
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
                              homeProvider.localEmblemLeft
                                  ? homeProvider.scoreRight
                                      .toString()
                                      .padLeft(2, '0')
                                  : homeProvider.scoreLeft
                                      .toString()
                                      .padLeft(2, '0'),
                              style: GoogleFonts.oswald(
                                color: homeProvider.localEmblemLeft
                                    ? homeProvider.visitTextColor
                                    : homeProvider.localTextColor,
                                fontSize: screenHeight * 0.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Spacer(),
                          homeProvider.localEmblemLeft
                              ? rightTimeCircles
                              : leftTimeCircles,
                          SizedBox(
                            width: screenWidth * 0.01,
                          ),
                        ],
                      ),
                      const Spacer(),
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
              child: TimerMatch(
                  refreshComponents: refreshComponents,
                  homeProvider: homeProvider),
            ),
          ),
          // Middle overlay with secondary score
          Align(
            alignment: Alignment.bottomCenter,
            child: SetMarker(homeProvider: homeProvider),
          ),
        ],
      ),
    );
  }
}

class TimeCircles extends StatefulWidget {
  const TimeCircles(
      {super.key,
      required this.circles,
      required this.backgroundColor,
      required this.textColor});

  final List<bool> circles;
  final Color backgroundColor;
  final Color textColor;

  @override
  State<TimeCircles> createState() => _TimeCirclesState();
}

class _TimeCirclesState extends State<TimeCircles> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Column(
      children: List.generate(2, (index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              widget.circles[index] = !widget.circles[index];
            });
          },
          child: Container(
            margin: EdgeInsets.symmetric(
                vertical: screenHeight * 0.01, horizontal: screenWidth * 0.01),
            width: screenHeight * 0.11,
            height: screenHeight * 0.11,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:
                  widget.circles[index] ? widget.textColor : Colors.transparent,
              border: Border.all(
                  color: widget.textColor,
                  width: screenHeight * 0.0075), // Borde más grueso
            ),
          ),
        );
      }),
    );
  }
}

class TimerMatch extends StatefulWidget {
  const TimerMatch({
    super.key,
    required this.refreshComponents,
    required this.homeProvider,
  });

  final Function refreshComponents;
  final HomeProvider homeProvider;

  @override
  State<TimerMatch> createState() => _TimerMatchState();
}

class _TimerMatchState extends State<TimerMatch> {
  bool isTimerRunning = false;
  int seconds = 0;
  Timer? timer;
  bool fullScreenActivated = false;

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        seconds++;
      });
    });
  }

  void stopTimer() {
    timer?.cancel();
    isTimerRunning = false;
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
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(
                isTimerRunning ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
                size: 36,
              ),
              onPressed: () {
                setState(() {
                  isTimerRunning = !isTimerRunning;
                  if (isTimerRunning) {
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
              icon: const Icon(
                Icons.restore_outlined,
                color: Colors.white,
                size: 36,
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Reinicio de temporizador'),
                      content: const Text(
                          '¿Estás seguro de que quieres reiniciar el temporizador?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Cierra el diálogo
                          },
                          child: const Text('Cancelar'),
                        ),
                        TextButton(
                          onPressed: () {
                            stopTimer();
                            resetTimer();
                            Navigator.of(context).pop(); // Cierra el diálogo
                          },
                          child: const Text('Reiniciar'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
        PopupMenuButton<int>(
          icon: const Icon(Icons.arrow_drop_down,
              color: Colors.white, size: 30.0),
          offset: const Offset(-60, 50),
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
                      onPressed: () async {
                        await widget.homeProvider
                            .showColorPickerDialog(context, true);
                        setState(() {
                          widget.refreshComponents();
                        });
                        if (context.mounted) {
                          Navigator.pop(context);
                        }
                      },
                      icon: const Icon(Icons.edit, color: Colors.white)),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          if (!fullScreenActivated) {
                            document.documentElement?.requestFullscreen();
                            fullScreenActivated = true;
                          } else {
                            document.exitFullscreen();
                            fullScreenActivated = false;
                          }
                        });
                        if (context.mounted) {
                          Navigator.pop(context);
                        }
                      },
                      icon: !fullScreenActivated
                          ? const Icon(Icons.fullscreen, color: Colors.white)
                          : const Icon(Icons.fullscreen_exit,
                              color: Colors.white)),
                  IconButton(
                      onPressed: () async {
                        await widget.homeProvider
                            .showColorPickerDialog(context, false);
                        setState(() {
                          widget.refreshComponents();
                        });
                        if (context.mounted) {
                          Navigator.pop(context);
                        }
                      },
                      icon: const Icon(Icons.edit, color: Colors.white)),
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
                        NavigationService.replaceTo(Flurorouter.homeRoute);
                      },
                      icon: const Icon(Icons.home, color: Colors.white)),
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Reinicio del juego'),
                              content: const Text(
                                  '¿Estás seguro de que quieres reiniciar el juego?'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(); // Cierra el diálogo
                                  },
                                  child: const Text('Cancelar'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    widget.homeProvider.resetSets();
                                    widget.homeProvider.resetValues();
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Reiniciar'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      icon: const Icon(Icons.refresh, color: Colors.white)),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          widget.homeProvider.localEmblemLeft =
                              !widget.homeProvider.localEmblemLeft;
                          widget.homeProvider.toggleServe();
                        });
                        if (context.mounted) {
                          Navigator.pop(context);
                        }
                      },
                      icon: const Icon(Icons.compare_arrows,
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
    );
  }
}

class SetMarker extends StatefulWidget {
  const SetMarker({super.key, required this.homeProvider});

  final HomeProvider homeProvider;

  @override
  State<SetMarker> createState() => _SetMarkerState();
}

class _SetMarkerState extends State<SetMarker> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              widget.homeProvider.localEmblemLeft
                  ? widget.homeProvider.incrementSetLeft()
                  : widget.homeProvider.incrementSetRight();
            });
          },
          onLongPress: () {
            setState(() {
              if (widget.homeProvider.localEmblemLeft) {
                if (widget.homeProvider.setLeft > 0) {
                  widget.homeProvider.decrementSetLeft();
                }
              } else {
                if (widget.homeProvider.setRight > 0) {
                  widget.homeProvider.decrementSetRight();
                }
              }
            });
          },
          child: Text(
            widget.homeProvider.localEmblemLeft
                ? widget.homeProvider.setLeft.toString()
                : widget.homeProvider.setRight.toString(),
            style: GoogleFonts.oswald(
              color: widget.homeProvider.localEmblemLeft
                  ? widget.homeProvider.localTextColor
                  : widget.homeProvider.visitTextColor,
              fontSize: screenHeight * 0.18, // 30% más pequeño
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(width: screenHeight * 0.1),
        GestureDetector(
          onTap: () {
            setState(() {
              widget.homeProvider.localEmblemLeft
                  ? widget.homeProvider.incrementSetRight()
                  : widget.homeProvider.incrementSetLeft();
            });
          },
          onLongPress: () {
            setState(() {
              if (widget.homeProvider.localEmblemLeft) {
                if (widget.homeProvider.setRight > 0) {
                  widget.homeProvider.decrementSetRight();
                }
              } else {
                if (widget.homeProvider.setLeft > 0) {
                  widget.homeProvider.decrementSetLeft();
                }
              }
            });
          },
          child: Text(
            widget.homeProvider.localEmblemLeft
                ? widget.homeProvider.setRight.toString()
                : widget.homeProvider.setLeft.toString(),
            style: GoogleFonts.oswald(
              color: widget.homeProvider.localEmblemLeft
                  ? widget.homeProvider.visitTextColor
                  : widget.homeProvider.localTextColor,
              fontSize: screenHeight * 0.18, // 30% más pequeño
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
