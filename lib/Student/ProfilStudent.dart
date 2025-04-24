import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_learning/Student/Module.dart';
import 'package:e_learning/Student/SignInScreen.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart' show GoogleFonts;

class ProfileStudent extends StatefulWidget {
  final Map<String, dynamic> userData;
  const ProfileStudent({super.key, required this.userData});

  @override
  State<ProfileStudent> createState() => _ProfileStudentState();
}

class _ProfileStudentState extends State<ProfileStudent>
    with SingleTickerProviderStateMixin {
  int currentPageIndex = 0;
  DateTime now = DateTime.now();
  late String year = now.year.toString();
  late String month = now.month.toString();
  late String day = now.day.toString();
  final TextEditingController Module = TextEditingController();
  final FocusNode ModuleFocusNode = FocusNode();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool isDarkMode = false;

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  @override
  void dispose() {
    Module.dispose();
    ModuleFocusNode.dispose();
    _tabController.dispose();
    super.dispose();
  }

  final Color randomColor = Color.fromRGBO(
    Random().nextInt(256),
    Random().nextInt(256),
    Random().nextInt(256),
    1,
  );

  final scaffoldKey = GlobalKey<ScaffoldState>();

  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  final List<String> days = ['SUN', 'MON', 'TUE', 'WED', 'THU'];
  final List<String> hours = [
    '8:00',
    '9:00',
    '10:00',
    '11:00',
    '12:00',
    '13:00',
    '14:00',
    '15:00',
    '16:00',
    '17:00',
  ];

  final List<Map<String, dynamic>> events = [
    {
      'time': '10:00 AM',
      'title': 'CS 101 Lecture',
      'location': 'Room 302, Science Building',
    },
    {
      'time': '3:00 PM',
      'title': 'MATH 201 Recitation',
      'location': 'Room 145, Math Building',
    },
  ];

  Future<bool> _onWillPop(BuildContext context) async {
    // Rediriger vers la page d'accueil ou quitter l'application
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileStudent(userData: widget.userData),
      ),
      (route) => false, // Supprimer toutes les routes précédentes
    );
    return false; // Empêcher le retour standard
  }

  String? dropDownValue = 'Bulletin';

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: Scaffold(
        bottomNavigationBar: NavigationBar(
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          indicatorColor: Colors.blue,
          selectedIndex: currentPageIndex,
          destinations: const <Widget>[
            NavigationDestination(
              selectedIcon: Icon(Icons.home, color: Colors.white),
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.punch_clock, color: Colors.white),
              icon: Icon(Icons.punch_clock),
              label: 'TimeTable',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.book, color: Colors.white),
              icon: Icon(Icons.book),
              label: 'Courses',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.menu_book, color: Colors.white),
              icon: Icon(Icons.menu_book),
              label: 'Grades',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.person, color: Colors.white),
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
        body: IndexedStack(
          index: currentPageIndex,
          children: [
            // Page Home
            Scaffold(
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(
                  kToolbarHeight,
                ), // Default height of AppBar
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.asset(
                        "assets/images/header.png",
                        fit: BoxFit.fill,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(10, 30, 0, 0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                widget.userData['Name'],
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 0.0,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                widget.userData['Niveau']["l'année"] +
                                    ' année Licance',
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  letterSpacing: 0.0,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              backgroundColor: Colors.white,
              body: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 30, 0, 30),
                              child: FlipCard(
                                fill: Fill.fillBack,
                                direction: FlipDirection.HORIZONTAL,
                                speed: 400,
                                front: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                    0,
                                    20,
                                    0,
                                    0,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(18),
                                    child: Image.network(
                                      widget.userData['carte'],
                                      width: 331.5,
                                      height: 200,
                                      fit: BoxFit.cover,
                                      loadingBuilder: (
                                        BuildContext context,
                                        Widget child,
                                        ImageChunkEvent? loadingProgress,
                                      ) {
                                        if (loadingProgress == null) {
                                          return child; // Affiche l'image une fois chargée
                                        }
                                        return Center(
                                          child: CircularProgressIndicator(
                                            value:
                                                loadingProgress
                                                            .expectedTotalBytes !=
                                                        null
                                                    ? loadingProgress
                                                            .cumulativeBytesLoaded /
                                                        loadingProgress
                                                            .expectedTotalBytes!
                                                    : null,
                                          ),
                                        ); // Affiche un indicateur de chargement
                                      },
                                      errorBuilder: (
                                        BuildContext context,
                                        Object exception,
                                        StackTrace? stackTrace,
                                      ) {
                                        return Center(
                                          child: Text(
                                            "Erreur lors du chargement de l'image",
                                          ),
                                        ); // Affiche un message en cas d'erreur
                                      },
                                    ),
                                  ),
                                ),
                                back: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                    0,
                                    20,
                                    0,
                                    0,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(18),
                                    child: Image.asset(
                                      'assets/images/front.jpg', // Remplacez par votre chemin d'image
                                      width: 331.5,
                                      height: 200,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            Align(
                              alignment: AlignmentDirectional(-1, 0),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                  20,
                                  20,
                                  0,
                                  0,
                                ),
                                child: Text(
                                  'Timetable',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                    shadows: [
                                      Shadow(
                                        color: Color(0xFF7349A8),
                                        offset: Offset(2.0, 2.0),
                                        blurRadius: 2.0,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: AlignmentDirectional(-1, 0),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                  30,
                                  0,
                                  0,
                                  0,
                                ),
                                child: Text(
                                  '$day / $month / $year',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                40,
                                10,
                                40,
                                0,
                              ),
                              child: Card(
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                color: Color(0xFF7349A8),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Container(
                                  width: double.infinity,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF7349A8),
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 4,
                                        color: Color(0x33000000),
                                        offset: Offset(0.0, 2),
                                        spreadRadius: 5,
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                  10,
                                                  10,
                                                  0,
                                                  0,
                                                ),
                                            child: Container(
                                              width: 30,
                                              height: 30,
                                              clipBehavior: Clip.antiAlias,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                              ),
                                              child: Image.network(
                                                'https://picsum.photos/seed/861/600',
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                  5,
                                                  10,
                                                  0,
                                                  0,
                                                ),
                                            child: Text(
                                              'Analyse',
                                              style: TextStyle(
                                                fontFamily: 'Inter',
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Align(
                                              alignment: AlignmentDirectional(
                                                1,
                                                0,
                                              ),
                                              child: Padding(
                                                padding:
                                                    EdgeInsetsDirectional.fromSTEB(
                                                      0,
                                                      10,
                                                      10,
                                                      0,
                                                    ),
                                                child: Container(
                                                  alignment: Alignment(0, 0),
                                                  width: 100,
                                                  height: 30,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10,
                                                        ),
                                                  ),
                                                  child: Text(
                                                    ' Salle 30',
                                                    style: TextStyle(
                                                      fontFamily: 'Inter',
                                                      color: Colors.black,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Divider(thickness: 2, color: Colors.grey),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                          0,
                                          0,
                                          10,
                                          0,
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding:
                                                  EdgeInsetsDirectional.fromSTEB(
                                                    10,
                                                    0,
                                                    0,
                                                    0,
                                                  ),
                                              child: Text(
                                                'Dr. Khelifi',
                                                style: TextStyle(
                                                  fontFamily: 'Inter',
                                                  color: Color(0xFFE0EEF6),
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              child: Text(
                                                '08:00 - 10:00',
                                                style: TextStyle(
                                                  fontFamily: 'Inter',
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                40,
                                10,
                                40,
                                0,
                              ),
                              child: Card(
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                color: Color(0xFF7349A8),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Container(
                                  width: double.infinity,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF7349A8),
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 4,
                                        color: Color(0x33000000),
                                        offset: Offset(0.0, 2),
                                        spreadRadius: 5,
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                  10,
                                                  10,
                                                  0,
                                                  0,
                                                ),
                                            child: Container(
                                              width: 30,
                                              height: 30,
                                              clipBehavior: Clip.antiAlias,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                              ),
                                              child: Image.network(
                                                'https://picsum.photos/seed/861/600',
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                  5,
                                                  10,
                                                  0,
                                                  0,
                                                ),
                                            child: Text(
                                              'Analyse',
                                              style: TextStyle(
                                                fontFamily: 'Inter',
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Align(
                                              alignment: AlignmentDirectional(
                                                1,
                                                0,
                                              ),
                                              child: Padding(
                                                padding:
                                                    EdgeInsetsDirectional.fromSTEB(
                                                      0,
                                                      10,
                                                      10,
                                                      0,
                                                    ),
                                                child: Container(
                                                  alignment: Alignment(0, 0),
                                                  width: 100,
                                                  height: 30,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10,
                                                        ),
                                                  ),
                                                  child: Text(
                                                    ' Salle TP 4',
                                                    style: TextStyle(
                                                      fontFamily: 'Inter',
                                                      color: Colors.black,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Divider(thickness: 2, color: Colors.grey),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                          0,
                                          0,
                                          10,
                                          0,
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding:
                                                  EdgeInsetsDirectional.fromSTEB(
                                                    10,
                                                    0,
                                                    0,
                                                    0,
                                                  ),
                                              child: Text(
                                                'Dr. Khelifi',
                                                style: TextStyle(
                                                  fontFamily: 'Inter',
                                                  color: Color(0xFFE0EEF6),
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              child: Text(
                                                '10:00 - 12:00',
                                                style: TextStyle(
                                                  fontFamily: 'Inter',
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                40,
                                10,
                                40,
                                0,
                              ),
                              child: Card(
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                color: Color(0xFF7349A8),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Container(
                                  width: double.infinity,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF7349A8),
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 4,
                                        color: Color(0x33000000),
                                        offset: Offset(0.0, 2),
                                        spreadRadius: 5,
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                  10,
                                                  10,
                                                  0,
                                                  0,
                                                ),
                                            child: Container(
                                              width: 30,
                                              height: 30,
                                              clipBehavior: Clip.antiAlias,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                              ),
                                              child: Image.network(
                                                'https://picsum.photos/seed/861/600',
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                  5,
                                                  10,
                                                  0,
                                                  0,
                                                ),
                                            child: Text(
                                              'Algorithme',
                                              style: TextStyle(
                                                fontFamily: 'Inter',
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Align(
                                              alignment: AlignmentDirectional(
                                                1,
                                                0,
                                              ),
                                              child: Padding(
                                                padding:
                                                    EdgeInsetsDirectional.fromSTEB(
                                                      0,
                                                      10,
                                                      10,
                                                      0,
                                                    ),
                                                child: Container(
                                                  alignment: Alignment(0, 0),
                                                  width: 100,
                                                  height: 30,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10,
                                                        ),
                                                  ),
                                                  child: Text(
                                                    ' Salle TP 5',
                                                    style: TextStyle(
                                                      fontFamily: 'Inter',
                                                      color: Colors.black,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Divider(thickness: 2, color: Colors.grey),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                          0,
                                          0,
                                          10,
                                          0,
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding:
                                                  EdgeInsetsDirectional.fromSTEB(
                                                    10,
                                                    0,
                                                    0,
                                                    0,
                                                  ),
                                              child: Text(
                                                'Dr. Khoudi',
                                                style: TextStyle(
                                                  fontFamily: 'Inter',
                                                  color: Color(0xFFE0EEF6),
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              child: Text(
                                                '14:00 - 16:00',
                                                style: TextStyle(
                                                  fontFamily: 'Inter',
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Page Time_Table
            Scaffold(
              backgroundColor: Colors.white,
                            appBar: PreferredSize(
                preferredSize: Size.fromHeight(
                  kToolbarHeight,
                ), // Default height of AppBar
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.asset(
                        "assets/images/header.png",
                        fit: BoxFit.fill,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(10, 30, 0, 0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'TimeTable',
                                style: GoogleFonts.inter(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 0.0,
                                  color: Colors.white,
                                ),
                              ),
                              
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              body: SafeArea(
                child: Column(
                  children: [
                    // Header Section
                    SizedBox(height: 16),

                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children:
                            days
                                .map((day) {
                                  return Container(
                                    width: 50,
                                    height: 70,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFF1F4F8),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Center(
                                      child: Text(
                                        day,
                                        style: TextStyle(
                                          color: Color(0xFF57636C),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  );
                                })
                                .expand(
                                  (widget) => [widget, SizedBox(width: 10)],
                                )
                                .toList()
                              ..removeLast(), // Remove the last SizedBox to avoid trailing space.toList(),
                      ),
                    ),
                    SizedBox(height: 16),

                    Expanded(
                      child: SingleChildScrollView(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Time Column
                            Container(
                              width: 60,
                              child: Column(
                                children:
                                    hours
                                        .map((hour) {
                                          return Text(
                                            hour,
                                            style: TextStyle(
                                              color: Color(0xFF57636C),
                                              fontSize: 11,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          );
                                        })
                                        .expand(
                                          (widget) => [
                                            widget,
                                            SizedBox(height: 65),
                                          ],
                                        )
                                        .toList()
                                      ..removeLast(),
                              ),
                            ),
                            SizedBox(height: 50),
                            // Event Grid for Each Day
                            ...days
                                .map((day) {
                                  return Expanded(
                                    child: Column(
                                      children:
                                          hours.map((hour) {
                                            return Container(
                                              width: 50,
                                              height: 70,
                                              margin: EdgeInsets.symmetric(
                                                vertical: 5,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Color(0xFFF1F4F8),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  '',
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                  ),
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                    ),
                                  );
                                })
                                .expand(
                                  (widget) => [widget, SizedBox(width: 10)],
                                )
                                .toList()
                              ..removeLast(), // Remove the last SizedBox to avoid trailing space.toList(),
                          ],
                        ),
                      ),
                    ),

                    // Upcoming Classes Section
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 4,
                            color: Color(0x20000000),
                            offset: Offset(0, 2),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Text(
                              'Upcoming Classes',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 12),
                            ...events.map((event) {
                              return Padding(
                                padding: EdgeInsets.symmetric(vertical: 8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            event['title'],
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Text(
                                            event['location'],
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Color(0xFF57636C),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      event['time'],
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF9489F5),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Page Courses
            Scaffold(
              backgroundColor: Colors.white,
                            appBar: PreferredSize(
                preferredSize: Size.fromHeight(
                  kToolbarHeight,
                ), // Default height of AppBar
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.asset(
                        "assets/images/header.png",
                        fit: BoxFit.fill,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(10, 30, 0, 0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Courses',
                                style: GoogleFonts.inter(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 0.0,
                                  color: Colors.white,
                                ),
                              ),
                              

                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),


              
              body: SafeArea(
                top: true,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Section with Gradient Background

                      // Search Bar and IconButton
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                20,
                                20,
                                10,
                                0,
                              ),
                              child: TextFormField(
                                autofocus: false,
                                decoration: InputDecoration(
                                  isDense: true,
                                  hintText: 'Search',
                                  prefixIcon: Icon(Icons.saved_search),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                      width: 1,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: Colors.transparent,
                                      width: 1,
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey[100],
                                ),
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  letterSpacing: 0.0,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                              0,
                              20,
                              20,
                              0,
                            ),
                            child: IconButton(
                              onPressed: () {
                                print('IconButton pressed ...');
                              },
                              icon: Icon(
                                Icons.start_rounded,
                                color: Colors.white,
                                size: 24,
                              ),
                              style: ElevatedButton.styleFrom(
                                shape: CircleBorder(),
                                backgroundColor: Colors.blueGrey,
                              ).copyWith(
                                elevation: ButtonStyleButton.allOrNull(0),
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Modules Section
                      Align(
                        alignment: AlignmentDirectional(-1, 0),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(20, 20, 0, 0),
                          child: Text(
                            'Modules : ',
                            style: GoogleFonts.inter(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.0,
                            ),
                          ),
                        ),
                      ),

                      // List of Modules
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(20, 20, 30, 10),
                        child: StreamBuilder<DocumentSnapshot>(
                          stream:
                              _firestore
                                  .collection('year')
                                  .doc(widget.userData['Niveau']["l'année"])
                                  .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Center(child: CircularProgressIndicator());
                            }

                            final data =
                                snapshot.data!.data() as Map<String, dynamic>;

                            // Vérifiez si le champ 'modules' existe
                            if (data.containsKey('modules')) {
                              final modules =
                                  data['modules'] as Map<String, dynamic>;

                              return ListView.builder(
                                shrinkWrap:
                                    true, // Permet à ListView de s'adapter à la taille du parent
                                physics:
                                    NeverScrollableScrollPhysics(), // Désactive le scroll interne
                                itemCount: modules.length,
                                itemBuilder: (context, index) {
                                  final moduleName = modules.keys.elementAt(
                                    index,
                                  );
                                  final moduleDetails =
                                      modules[moduleName]
                                          as Map<String, dynamic>;

                                  // Vérifiez si les champs nécessaires existent
                                  if (moduleDetails.containsKey('professor') &&
                                      moduleDetails.containsKey('type') &&
                                      moduleDetails.containsKey(
                                        'courseCount',
                                      )) {
                                    return Column(
                                      children: [
                                        ListTile(
                                          leading: Icon(
                                            Icons.collections_bookmark,
                                          ),
                                          title: Text(
                                            moduleName,
                                            style: GoogleFonts.inter(
                                              fontSize: 18,
                                              letterSpacing: 0.0,
                                            ),
                                          ),
                                          subtitle: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Professeur: ${moduleDetails['professor']}",
                                                style: GoogleFonts.inter(
                                                  fontSize: 14,
                                                  letterSpacing: 0.0,
                                                ),
                                              ),
                                              Text(
                                                "Type: ${moduleDetails['type']}",
                                                style: GoogleFonts.inter(
                                                  fontSize: 14,
                                                  letterSpacing: 0.0,
                                                ),
                                              ),
                                              Text(
                                                "Nombre de cours: ${moduleDetails['courseCount']}",
                                                style: GoogleFonts.inter(
                                                  fontSize: 14,
                                                  letterSpacing: 0.0,
                                                ),
                                              ),
                                            ],
                                          ),
                                          trailing: IconButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder:
                                                      (context) => ModulePage(
                                                        userData:
                                                            widget.userData,
                                                        moduleDetails:
                                                            moduleDetails,
                                                        moduleName: moduleName,
                                                      ),
                                                ),
                                              );
                                            },
                                            icon: Icon(
                                              Icons.arrow_forward_ios_rounded,
                                              color: Colors.grey,
                                              size: 24,
                                            ),
                                          ),
                                          tileColor: Color(0x3C5287F3),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ), // Ajoute un espace de 10 pixels entre les modules
                                      ],
                                    );
                                  } else {
                                    return ListTile(
                                      title: Text(
                                        "Données incomplètes pour $moduleName",
                                      ),
                                    );
                                  }
                                },
                              );
                            } else {
                              return Center(
                                child: Text(
                                  "Aucun module trouvé pour cette année",
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Page Grads
            Scaffold(
              backgroundColor: Colors.white,
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(
                  kToolbarHeight,
                ), // Default height of AppBar
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.asset(
                        "assets/images/header.png",
                        fit: BoxFit.fill,
                      ),
                    ),
                    AppBar(
                      backgroundColor:
                          Colors.transparent, // Make AppBar transparent
                      title: const Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 0, 20, 0),
                        child: Text(
                          'Grades',
                          style: TextStyle(
                            fontFamily: 'Inter Tight',
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      actions: [
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                            0,
                            0,
                            10,
                            10,
                          ),
                          child: DropdownButton<String>(
                            value: dropDownValue,
                            onChanged: (String? newValue) {
                              setState(() {
                                dropDownValue = newValue;
                              });
                            },
                            items: const [
                              DropdownMenuItem(
                                value: 'Bulletin',
                                child: Text('Bulletin'),
                              ),
                              DropdownMenuItem(
                                value: 'Exams',
                                child: Text('Exams'),
                              ),
                              DropdownMenuItem(
                                value: 'TDs',
                                child: Text('TDs'),
                              ),
                            ],
                            hint: const Text('Grades'),
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              color: Colors.white,
                            ),
                            dropdownColor: const Color.fromARGB(255, 58, 81, 93),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ],
                      centerTitle: true,
                      elevation: 0,
                    ),
                  ],
                ),
              ),
              body: _buildBody(),
            ),

            // Page Profile
            Scaffold(
                            appBar: PreferredSize(
                preferredSize: Size.fromHeight(
                  kToolbarHeight,
                ), // Default height of AppBar
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.asset(
                        "assets/images/header.png",
                        fit: BoxFit.fill,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(10, 30, 0, 0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Profil',
                                style: GoogleFonts.inter(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 0.0,
                                  color: Colors.white,
                                ),
                              ),
                              
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),


              backgroundColor: isDarkMode ? Colors.black : Colors.white,
              body: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(height: 30),
                    // Profile Picture
                    CircleAvatar(
                      radius: 70,
                      backgroundColor: Color(0xFF779EF2), // Couleur de fond aléatoire
                      child: Text(
                        widget.userData['Name'][0]
                            .toUpperCase(), // Première lettre du nom
                        style: TextStyle(
                          fontSize: 70,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),

                    // Name
                    Text(
                      widget.userData['Name'],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 20),

                    // Settings List
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: Color(0xFF779EF2),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 4,
                              color: Color(0x33000000),
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ListView(
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 30),
                          children: [
                            _buildSettingItem(
                              Icons.info,
                              'My Information',
                              () {},
                            ),
                            _buildSettingItem(
                              Icons.notifications_active,
                              'Notifications',
                              () {},
                            ),
                            _buildSettingItem(
                              Icons.security,
                              'Security',
                              () {},
                            ),
                            _buildSettingItem(
                              Icons.language_outlined,
                              'Languages',
                              () {},
                            ),
                            _buildDarkModeSwitch(),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10),

                    // Log Out Button
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignInScreenStudent(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(
                          0xFFF2F5F7,
                        ), // Replace with your color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        padding: EdgeInsetsDirectional.fromSTEB(40, 0, 40, 0),
                      ),
                      child: Text(
                        'Log Out',
                        style: TextStyle(
                          fontSize: 16,
                          color: isDarkMode ? Colors.white : Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem(IconData icon, String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 6, horizontal: 20),
        height: 54,
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey[800] : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              blurRadius: 4,
              color: Color(0x33000000),
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Icon(
                icon,
                color: isDarkMode ? Colors.white : Colors.black,
                size: 24,
              ),
            ),
            SizedBox(width: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            Spacer(),
            Padding(
              padding: EdgeInsets.only(right: 10),
              child: Icon(
                Icons.arrow_forward,
                color: isDarkMode ? Colors.white : Colors.black,
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDarkModeSwitch() {
    return InkWell(
      onTap: toggleTheme,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 6, horizontal: 20),
        height: 54,
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey[800] : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              blurRadius: 4,
              color: Color(0x33000000),
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Icon(
                isDarkMode ? Icons.mode_night_rounded : Icons.wb_sunny_rounded,
                color: isDarkMode ? Colors.white : Colors.black,
                size: 24,
              ),
            ),
            SizedBox(width: 10),
            Text(
              'Dark Mode',
              style: TextStyle(
                fontSize: 16,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            Spacer(),
            Padding(
              padding: EdgeInsets.only(right: 10),
              child: Icon(
                Icons.arrow_forward,
                color: isDarkMode ? Colors.white : Colors.black,
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to dynamically build the body based on the dropdown selection
  Widget _buildBody() {
    switch (dropDownValue) {
      case 'Bulletin':
        return SafeArea(
          top: true,
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 10, 16, 24),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 100,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFF7349A8),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Center(
                            child: Text(
                              '2024 / 2025',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          width: 100,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.grey, width: 1),
                          ),
                          child: const Center(
                            child: Text(
                              '2023 / 2024',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 4,
                            color: Colors.black.withOpacity(0.1),
                            offset: const Offset(0, 2),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Décision : Admis(e) (session normale)',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 130,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Text(
                                          'Moyenne annuelle',
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontSize: 11,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          '13.68',
                                          style: TextStyle(
                                            fontFamily: 'Inter Tight',
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 130,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Text(
                                          'Crédits obtenus',
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontSize: 11,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          '60',
                                          style: TextStyle(
                                            fontFamily: 'Inter Tight',
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildSemesterSection(
                    'Semestre 1',
                    subjects: [
                      {
                        'name': 'Mathématiques',
                        'crd': '6',
                        'coef': '3',
                        'moy': '14.5',
                      },
                      {
                        'name': 'Physique',
                        'crd': '5',
                        'coef': '2',
                        'moy': '12.75',
                      },
                      {
                        'name': 'Informatique',
                        'crd': '4',
                        'coef': '2',
                        'moy': '16.0',
                      },
                      {
                        'name': 'Anglais',
                        'crd': '3',
                        'coef': '1',
                        'moy': '13.5',
                      },
                      {
                        'name': 'Économie',
                        'crd': '2',
                        'coef': '1',
                        'moy': '11.25',
                      },
                    ],
                    semesterAverage: '13.85',
                  ),
                  const SizedBox(height: 16),
                  _buildSemesterSection(
                    'Semestre 2',
                    subjects: [
                      {
                        'name': 'Statistiques',
                        'crd': '6',
                        'coef': '3',
                        'moy': '15.25',
                      },
                      {
                        'name': 'Chimie',
                        'crd': '5',
                        'coef': '2',
                        'moy': '11.5',
                      },
                      {
                        'name': 'Programmation',
                        'crd': '4',
                        'coef': '2',
                        'moy': '17.0',
                      },
                      {
                        'name': 'Communication',
                        'crd': '3',
                        'coef': '1',
                        'moy': '12.75',
                      },
                      {
                        'name': 'Gestion',
                        'crd': '2',
                        'coef': '1',
                        'moy': '10.5',
                      },
                    ],
                    semesterAverage: '13.50',
                  ),
                ],
              ),
            ),
          ),
        );

      case 'Exams':
        return Scaffold(
          backgroundColor: Colors.white,

          body: SafeArea(
            top: true,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                TabBar(
                  controller: _tabController,
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.grey[400],
                  indicatorColor: Colors.black,
                  tabs: const [
                    Tab(text: 'Session Normale'),
                    Tab(text: 'Session de Rattrapage'),
                  ],
                ),

                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // Session Normale
                      SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSemesterSectionExames(
                              'Semestre 1',
                              subjects: [
                                {
                                  'name': 'Mathématiques',
                                  'coef': '3',
                                  'grade': '5.5',
                                },
                                {
                                  'name': 'Physique',
                                  'coef': '2',
                                  'grade': '4.75',
                                },
                                {
                                  'name': 'Informatique',
                                  'coef': '2',
                                  'grade': '0.5',
                                },
                                {
                                  'name': 'Anglais',
                                  'coef': '1',
                                  'grade': '13.5',
                                },
                                {
                                  'name': 'Économie',
                                  'coef': '1',
                                  'grade': '11.25',
                                },
                              ],
                              semesterAverage: '13.85',
                            ),
                            const SizedBox(height: 16),
                            _buildSemesterSectionExames(
                              'Semestre 2',
                              subjects: [
                                {
                                  'name': 'Statistiques',
                                  'coef': '3',
                                  'grade': '5.25',
                                },
                                {
                                  'name': 'Chimie',
                                  'coef': '2',
                                  'grade': '10.5',
                                },
                                {
                                  'name': 'Programmation',
                                  'coef': '2',
                                  'grade': '6.0',
                                },
                                {
                                  'name': 'Communication',
                                  'coef': '1',
                                  'grade': '6.75',
                                },
                                {
                                  'name': 'Gestion',
                                  'coef': '1',
                                  'grade': '10.5',
                                },
                              ],
                              semesterAverage: '13.50',
                            ),
                          ],
                        ),
                      ),
                      // Session de Rattrapage
                      SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSemesterSectionExames(
                              'Semestre 1',
                              subjects: [
                                {
                                  'name': 'Mathématiques',
                                  'coef': '3',
                                  'grade': '14.5',
                                },
                                {
                                  'name': 'Physique',
                                  'coef': '2',
                                  'grade': '12.75',
                                },
                                {
                                  'name': 'Informatique',
                                  'coef': '2',
                                  'grade': '16.0',
                                },
                              ],
                              semesterAverage: '14.10',
                            ),
                            const SizedBox(height: 16),
                            _buildSemesterSectionExames(
                              'Semestre 2',
                              subjects: [
                                {
                                  'name': 'Statistiques',
                                  'coef': '3',
                                  'grade': '12.0',
                                },
                                {
                                  'name': 'Programmation',
                                  'coef': '2',
                                  'grade': '10.5',
                                },
                                {
                                  'name': 'Communication',
                                  'coef': '1',
                                  'grade': '13.0',
                                },
                              ],
                              semesterAverage: '13.90',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );

      case 'TDs':
        return SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      _buildCourseCard(
                        'Mathématiques Appliquées',
                        'TD',
                        '7.5',
                        const Color(0xBCFF5963),
                      ),
                      _buildCourseCard(
                        'Programmation Orientée Objet',
                        'TP',
                        '16.0',
                        const Color(0xC5249689),
                      ),
                      _buildCourseCard(
                        'Bases de Données',
                        'TD',
                        '18.0',
                        const Color(0xC2249689),
                      ),
                      _buildCourseCard(
                        'Réseaux Informatiques',
                        'TP',
                        '6.5',
                        const Color(0xC0FF5963),
                      ),
                      _buildCourseCard(
                        'Systèmes d\'Exploitation',
                        'TD',
                        '15.0',
                        const Color(0xBE249689),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 12),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      'If you believe there is an error in your evaluation, please submit a review request within 48 hours of the results being published.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'Manrope',
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );

      default:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.info, size: 50, color: Colors.grey),
              SizedBox(height: 10),
              Text(
                'Select an option from the dropdown',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );
    }
  }

  Widget _buildSemesterSectionExames(
    String title, {
    required List<Map<String, String>> subjects,
    required String semesterAverage,
  }) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 10, 16, 0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 200, 221, 252),
          boxShadow: [
            BoxShadow(
              blurRadius: 4,
              color: Colors.black.withOpacity(0.1),
              offset: const Offset(0, 2),
            ),
          ],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Inter Tight',
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 12, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Text(
                        'Matière',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: const [
                        Text(
                          'Coef',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 16),
                        Text(
                          'Note',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, thickness: 1, color: Colors.grey),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: subjects.length,
                itemBuilder: (context, index) {
                  final subject = subjects[index];
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                          0,
                          12,
                          0,
                          12,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                subject['name']!,
                                style: const TextStyle(fontFamily: 'Inter'),
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  subject['coef']!,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontFamily: 'Inter'),
                                ),
                                const SizedBox(width: 24),
                                Text(
                                  subject['grade']!,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    color:
                                        double.parse(subject['grade']!) > 14
                                            ? Colors.green
                                            : double.parse(subject['grade']!) <
                                                10
                                            ? Colors.red
                                            : Colors.black,
                                    fontWeight:
                                        double.parse(subject['grade']!) > 14
                                            ? FontWeight.w600
                                            : FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        height: 1,
                        thickness: 1,
                        indent: 8,
                        endIndent: 8,
                        color: Colors.grey,
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCourseCard(
    String moduleName,
    String evaluationType,
    String grade,
    Color gradeColor,
  ) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  moduleName,
                  style: const TextStyle(
                    fontFamily: 'Inter Tight',
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
                Container(
                  width: 60,
                  height: 40,
                  decoration: BoxDecoration(
                    color: gradeColor,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Text(
                      grade,
                      style: const TextStyle(
                        fontFamily: 'Manrope',
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: 60,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xAE779EF2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      evaluationType,
                      style: const TextStyle(
                        fontFamily: 'Manrope',
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSemesterSection(
    String title, {
    required List<Map<String, String>> subjects,
    required String semesterAverage,
  }) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 4,
              color: Colors.black.withOpacity(0.1),
              offset: const Offset(0, 2),
            ),
          ],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Inter Tight',
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 12, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Text(
                        'Matière',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: const [
                        Text(
                          'Crd',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 16),
                        Text(
                          'Coef',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 16),
                        Text(
                          'Moy',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, thickness: 1, color: Colors.grey),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: subjects.length,
                itemBuilder: (context, index) {
                  final subject = subjects[index];
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                          0,
                          12,
                          0,
                          12,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                subject['name']!,
                                style: const TextStyle(fontFamily: 'Inter'),
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  subject['crd']!,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontFamily: 'Inter'),
                                ),
                                const SizedBox(width: 24),
                                Text(
                                  subject['coef']!,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontFamily: 'Inter'),
                                ),
                                const SizedBox(width: 24),
                                Text(
                                  subject['moy']!,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    color:
                                        double.parse(subject['moy']!) > 14
                                            ? Colors.green
                                            : Colors.black,
                                    fontWeight:
                                        double.parse(subject['moy']!) > 14
                                            ? FontWeight.w600
                                            : FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        height: 1,
                        thickness: 1,
                        indent: 8,
                        endIndent: 8,
                        color: Colors.grey,
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 12, 0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                          child: Text(
                            'Moyenne du semestre',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const Text(
                              '30',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 24),
                            Text(
                              semesterAverage,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
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
