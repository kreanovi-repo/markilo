import 'dart:html';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:markilo/providers/home_provider.dart';
import 'package:markilo/ui/inputs/custom_inputs.dart';
import 'package:provider/provider.dart';

enum Menu {
  fullScreen,
  normalScreen,
  selectLocalEmblem,
  selectVisitEmblem,
  resetGame,
  resetSets
}

class HomeView extends StatefulWidget {
  const HomeView({super.key, required this.title});
  final String title;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  TextEditingController? _nameLeftcontroller;
  TextEditingController? _nameRightcontroller;
  late HomeProvider homeProvider;
  late Size size;
  bool appLoaded = false;

  refresh() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    homeProvider = Provider.of<HomeProvider>(context, listen: false);
    homeProvider.scoreLeft = 0;
    homeProvider.scoreRight = 0;
    homeProvider.localServe = true;
    _nameLeftcontroller = TextEditingController(text: '<Local>');
    _nameRightcontroller = TextEditingController(text: '<Visitante>');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    size = MediaQuery.of(context).size;
    if (!appLoaded) {
      homeProvider.localEmblem = Image.asset(
        'assets/images/escudo.png',
        width: size.width * 0.15,
      );
      homeProvider.visitEmblem = Image.asset(
        'assets/images/escudo.png',
        width: size.width * 0.15,
      );
      appLoaded = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 30,
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 0, 173, 239),
        actions: [
          PopupMenuButton<Menu>(
              // Callback that sets the selected popup menu item.
              onSelected: (Menu item) async {
                if (Menu.fullScreen == item) {
                  setState(() {
                    document.documentElement?.requestFullscreen();
                  });
                } else if (Menu.normalScreen == item) {
                  setState(() {
                    document.exitFullscreen();
                  });
                } else if (Menu.selectLocalEmblem == item) {
                  FilePickerResult? result = await FilePicker.platform
                      .pickFiles(
                          type: FileType.custom, allowedExtensions: ['png']);
                  if (result != null) {
                    PlatformFile file = result.files.first;
                    setState(() {
                      homeProvider.localEmblem = Image.memory(
                        file.bytes!,
                        width: size.width * 0.15,
                      );
                    });
                  }
                } else if (Menu.selectVisitEmblem == item) {
                  FilePickerResult? result = await FilePicker.platform
                      .pickFiles(
                          type: FileType.custom, allowedExtensions: ['png']);
                  if (result != null) {
                    PlatformFile file = result.files.first;
                    setState(() {
                      homeProvider.visitEmblem = Image.memory(
                        file.bytes!,
                        width: size.width * 0.15,
                      );
                    });
                  } else {
                    // User canceled the picker
                  }
                } else if (Menu.resetGame == item) {
                  homeProvider.resetValues();
                  refresh();
                } else if (Menu.resetSets == item) {
                  homeProvider.resetSets();
                  refresh();
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[
                    const PopupMenuItem<Menu>(
                      value: Menu.fullScreen,
                      child: Row(
                        children: [
                          Icon(
                            Icons.fullscreen_outlined,
                            color: Colors.black,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Pantalla completa',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    const PopupMenuItem<Menu>(
                      value: Menu.normalScreen,
                      child: Row(
                        children: [
                          Icon(
                            Icons.fullscreen_exit_outlined,
                            color: Colors.black,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Pantalla normal',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    const PopupMenuItem<Menu>(
                      value: Menu.selectLocalEmblem,
                      child: Row(
                        children: [
                          Icon(
                            Icons.image_search_outlined,
                            color: Colors.black,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Seleccionar escudo local',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    const PopupMenuItem<Menu>(
                      value: Menu.selectVisitEmblem,
                      child: Row(
                        children: [
                          Icon(
                            Icons.image_search_outlined,
                            color: Colors.black,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Seleccionar escudo visitante',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    const PopupMenuItem<Menu>(
                      value: Menu.resetGame,
                      child: Row(
                        children: [
                          Icon(
                            Icons.restore_outlined,
                            color: Colors.black,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Reiniciar juego',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    const PopupMenuItem<Menu>(
                      value: Menu.resetSets,
                      child: Row(
                        children: [
                          Icon(
                            Icons.restart_alt_outlined,
                            color: Colors.black,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Reiniciar sets',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ]),
        ],
      ),
      body: Center(
          child: Container(
        width: size.width,
        height: size.height,
        color: const Color.fromARGB(255, 0, 173, 239),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: size.width * 0.02,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _TeamName(size: size, controller: _nameLeftcontroller),
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
                      child: homeProvider.localEmblem,
                    ),
                  ],
                ),
                const Spacer(),
                _ScoreLeft(
                  size: size,
                  homeProvider: homeProvider,
                  refresh: refresh,
                ),
                SizedBox(
                  width: size.width * 0.01,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      "-",
                      style: GoogleFonts.oswald(
                          fontSize: size.width * 0.13,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(
                  width: size.width * 0.01,
                ),
                _ScoreRight(
                  size: size,
                  homeProvider: homeProvider,
                  refresh: refresh,
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _TeamName(size: size, controller: _nameRightcontroller),
                    GestureDetector(
                      onLongPress: () {
                        setState(() {
                          if (homeProvider.scoreRight > 0) {
                            --homeProvider.scoreRight;
                          }
                        });
                      },
                      onTap: () {
                        setState(() {
                          ++homeProvider.scoreRight;
                          if (homeProvider.localServe) {
                            homeProvider.toggleServe();
                          }
                        });
                      },
                      child: homeProvider.visitEmblem,
                    ),
                  ],
                ),
                SizedBox(
                  width: size.width * 0.02,
                ),
              ],
            ),
            Row(
              children: [
                SizedBox(
                  width: size.width * 0.06,
                ),
                Column(
                  children: [
                    Text(
                      'TIEMPOS',
                      style: GoogleFonts.montserrat(
                        fontSize: size.width * 0.025,
                        color: Colors.black.withOpacity(0.7),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        homeProvider.localTime1Used
                            ? GestureDetector(
                                onTap: () {
                                  setState(() {
                                    homeProvider.toggleLocalTime1();
                                  });
                                },
                                child: Icon(
                                  Icons.circle_sharp,
                                  size: size.width * 0.040,
                                ),
                              )
                            : GestureDetector(
                                onTap: () {
                                  setState(() {
                                    homeProvider.toggleLocalTime1();
                                  });
                                },
                                child: Icon(
                                  Icons.circle_outlined,
                                  size: size.width * 0.040,
                                ),
                              ),
                        const SizedBox(
                          width: 30,
                        ),
                        homeProvider.localTime2Used
                            ? GestureDetector(
                                onTap: () {
                                  setState(() {
                                    homeProvider.toggleLocalTime2();
                                  });
                                },
                                child: Icon(
                                  Icons.circle_sharp,
                                  size: size.width * 0.040,
                                ),
                              )
                            : GestureDetector(
                                onTap: () {
                                  setState(() {
                                    homeProvider.toggleLocalTime2();
                                  });
                                },
                                child: Icon(
                                  Icons.circle_outlined,
                                  size: size.width * 0.040,
                                ),
                              ),
                      ],
                    )
                  ],
                ),
                const Spacer(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: size.width * 0.2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                ++homeProvider.setLeft;
                              });
                            },
                            onLongPress: () {
                              setState(() {
                                if (homeProvider.setLeft > 0) {
                                  --homeProvider.setLeft;
                                }
                              });
                            },
                            child: Text(
                              homeProvider.setLeft.toString(),
                              style: GoogleFonts.oswald(
                                  fontSize: size.width * 0.09,
                                  color: Colors.black.withOpacity(0.7),
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Text(
                            " - ",
                            style: GoogleFonts.oswald(
                                fontSize: size.width * 0.09,
                                color: Colors.black.withOpacity(0.7),
                                fontWeight: FontWeight.bold),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                ++homeProvider.setRight;
                              });
                            },
                            onLongPress: () {
                              setState(() {
                                if (homeProvider.setRight > 0) {
                                  --homeProvider.setRight;
                                }
                              });
                            },
                            child: Text(
                              homeProvider.setRight.toString(),
                              style: GoogleFonts.oswald(
                                  fontSize: size.width * 0.09,
                                  color: Colors.black.withOpacity(0.7),
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Column(
                  children: [
                    Text(
                      'TIEMPOS',
                      style: GoogleFonts.montserrat(
                        fontSize: size.width * 0.025,
                        color: Colors.black.withOpacity(0.7),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        homeProvider.visitTime1Used
                            ? GestureDetector(
                                onTap: () {
                                  setState(() {
                                    homeProvider.toggleVisitTime1();
                                  });
                                },
                                child: Icon(
                                  Icons.circle_sharp,
                                  size: size.width * 0.040,
                                ),
                              )
                            : GestureDetector(
                                onTap: () {
                                  setState(() {
                                    homeProvider.toggleVisitTime1();
                                  });
                                },
                                child: Icon(
                                  Icons.circle_outlined,
                                  size: size.width * 0.040,
                                ),
                              ),
                        const SizedBox(
                          width: 30,
                        ),
                        homeProvider.visitTime2Used
                            ? GestureDetector(
                                onTap: () {
                                  setState(() {
                                    homeProvider.toggleVisitTime2();
                                  });
                                },
                                child: Icon(
                                  Icons.circle_sharp,
                                  size: size.width * 0.040,
                                ),
                              )
                            : GestureDetector(
                                onTap: () {
                                  setState(() {
                                    homeProvider.toggleVisitTime2();
                                  });
                                },
                                child: Icon(
                                  Icons.circle_outlined,
                                  size: size.width * 0.040,
                                ),
                              ),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  width: size.width * 0.06,
                )
              ],
            ),
          ],
        ),
      )),
    );
  }
}

class ScoreSet extends StatelessWidget {
  const ScoreSet({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Text(
      '25 - 22',
      style: GoogleFonts.montserrat(
        fontSize: size.width * 0.015,
        color: Colors.black.withOpacity(0.7),
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _TeamName extends StatelessWidget {
  const _TeamName({
    Key? key,
    required this.size,
    required TextEditingController? controller,
  })  : _controller = controller,
        super(key: key);

  final Size size;
  final TextEditingController? _controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.width * 0.20,
      child: TextField(
          textAlign: TextAlign.center,
          controller: _controller,
          style: GoogleFonts.oswald(
            fontSize: size.width * 0.028,
            color: Colors.black.withOpacity(0.7),
            fontWeight: FontWeight.bold,
          ),
          decoration: CustomInputs.invisibleInput()),
    );
  }
}

class _ScoreLeft extends StatefulWidget {
  const _ScoreLeft({
    Key? key,
    required this.size,
    required this.homeProvider,
    required this.refresh,
  }) : super(key: key);

  final Size size;
  final HomeProvider homeProvider;
  final Function refresh;

  @override
  State<_ScoreLeft> createState() => _ScoreLeftState();
}

class _ScoreLeftState extends State<_ScoreLeft> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size.width * 0.19,
      //height: widget.size.height * 0.60,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          widget.homeProvider.localServe
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      widget.homeProvider.toggleServe();
                      widget.refresh();
                    });
                  },
                  child: Icon(
                    Icons.sports_volleyball,
                    size: widget.size.width * 0.050,
                    color: Colors.white,
                  ),
                )
              : Container(
                  width: widget.size.width * 0.050,
                  height: widget.size.width * 0.050,
                  color: Colors.transparent,
                ),
          Text(widget.homeProvider.scoreLeft.toString(),
              style: GoogleFonts.oswald(
                  fontSize: widget.size.width * 0.15,
                  color: Colors.white,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _ScoreRight extends StatefulWidget {
  const _ScoreRight({
    Key? key,
    required this.size,
    required this.homeProvider,
    required this.refresh,
  }) : super(key: key);

  final Size size;
  final HomeProvider homeProvider;
  final Function refresh;

  @override
  State<_ScoreRight> createState() => _ScoreRightState();
}

class _ScoreRightState extends State<_ScoreRight> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size.width * 0.19,
      child: Column(
        children: [
          !widget.homeProvider.localServe
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      widget.homeProvider.toggleServe();
                      widget.refresh();
                    });
                  },
                  child: Icon(
                    Icons.sports_volleyball,
                    size: widget.size.width * 0.050,
                    color: Colors.white,
                  ),
                )
              : Container(
                  width: widget.size.width * 0.050,
                  height: widget.size.width * 0.050,
                  color: Colors.transparent,
                ),
          Text(widget.homeProvider.scoreRight.toString(),
              style: GoogleFonts.oswald(
                  fontSize: widget.size.width * 0.15,
                  color: Colors.white,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
