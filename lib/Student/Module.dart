import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_learning/Student/ProfilStudent.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart'; // Import the url_launcher package

class ModulePage extends StatefulWidget {
  final Map<String, dynamic> userData;
  final Map<String, dynamic> moduleDetails;
  final String moduleName;

  const ModulePage({
    super.key,
    required this.userData,
    required this.moduleDetails,
    required this.moduleName,
  });

  @override
  State<ModulePage> createState() => _ModulePageState();
}

class _ModulePageState extends State<ModulePage> with TickerProviderStateMixin {
  late TabController _tabController;

  // Generate a random color dynamically
  Color get randomColor => Color.fromRGBO(
    Random().nextInt(256),
    Random().nextInt(256),
    Random().nextInt(256),
    1,
  );

  late Future<QuerySnapshot> TDFuture;

  late Future<QuerySnapshot> coursFuture;

  @override
  void initState() {
    super.initState();

    coursFuture =
        FirebaseFirestore.instance
            .collection(widget.moduleName)
            .where('Type', isEqualTo: 'Cours')
            .get();

    TDFuture =
        FirebaseFirestore.instance
            .collection(widget.moduleName)
            .where('Type', isEqualTo: 'TD')
            .get();

    _tabController = TabController(vsync: this, length: 2, initialIndex: 0)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
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
                        IconButton(
                                icon: Icon(Icons.arrow_back, color: Colors.white),
                                onPressed: () {
                                  Navigator.pop(context); // Revenir à l'écran précédent
                                },
                              ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(10, 30, 0, 0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                widget.moduleName,
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 0.0,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                widget.moduleDetails['professor'],
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
          top: true,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),

                // TabBar and TabBarView
                tabBarSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // TabBar and TabBarView Section
  Widget tabBarSection() {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          labelStyle: TextStyle(
            fontFamily: 'Inter Tight',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.0,
          ),
          unselectedLabelStyle: TextStyle(
            fontFamily: 'Inter Tight',
            fontSize: 16,
            fontWeight: FontWeight.normal,
            letterSpacing: 0.0,
          ),
          indicatorColor: Colors.blue,
          tabs: [Tab(text: 'Cours'), Tab(text: 'TD')],
        ),
        SizedBox(
          height: 200, // Fixed height for TabBarView content
          child: TabBarView(
            controller: _tabController,
            children: [
              // First Tab Content
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(20, 10, 30, 10),
                child: FutureBuilder<QuerySnapshot>(
                  future: coursFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData ||
                        snapshot.data!.docs.isEmpty) {
                      return Center(child: Text('No data found'));
                    } else {
                      // Display the data
                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          var doc = snapshot.data!.docs[index];
                          return ListTile(
                            title: Text(doc['Name'] ?? 'No Title'),
                            subtitle: Text(
                              doc['description'] ?? 'No Description',
                            ),
                            onTap: () async {
                              String? url = doc['Lien'];
                              if (url != null) {
                                await launchUrl(Uri.parse(url));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Invalid or missing URL'),
                                  ),
                                );
                              }
                            },
                          );
                        },
                      );
                    }
                  },
                ),
              ),
              // Second Tab Content
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(20, 10, 30, 10),
                child: FutureBuilder<QuerySnapshot>(
                  future: TDFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData ||
                        snapshot.data!.docs.isEmpty) {
                      return Center(child: Text('No data found'));
                    } else {
                      // Display the data
                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          var doc = snapshot.data!.docs[index];
                          return ListTile(
                            title: Text(doc['Name'] ?? 'No Title'),
                            subtitle: Text(
                              doc['description'] ?? 'No Description',
                            ),
                            onTap: () async {
                              String? url = doc['Lien'];
                              if (url != null) {
                                await launchUrl(Uri.parse(url));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Invalid or missing URL'),
                                  ),
                                );
                              }
                            },
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
