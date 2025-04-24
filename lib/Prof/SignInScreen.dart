import 'package:e_learning/Prof/ProfilProf.dart';
import 'package:e_learning/Prof/SingUP.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});
  static String routeName = 'SignIn';
  static String routePath = '/signin';

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _IdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _idFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  bool _passwordVisibility = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _IdController.dispose();
    _passwordController.dispose();
    _idFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }
  Future<Map<String, dynamic>?> _login() async {
  try {
    // Query Firestore for matching documents
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Prof')
        .where('Id', isEqualTo: _IdController.text)
        .where('password', isEqualTo: _passwordController.text)
        .get();

    // Log the number of matching documents for debugging
    print("Number of matching documents: ${querySnapshot.docs.length}");

    // Check if any documents match the query
    if (querySnapshot.docs.isNotEmpty) {
      // Extract the first document's data
      Map<String, dynamic>? rawData = querySnapshot.docs.first.data() as Map<String, dynamic>?;
      if (rawData == null) {
        throw Exception("Document data is null");
      }
      Map<String, dynamic> userData = rawData;

      // Navigate to the profile page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileProf(userData: userData),
        ),
      );

      // Return the user data
      return userData;
    } else {
      // Show an error message if no matching documents are found
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Mot de passe ou ID incorrect'),
        ),
      );
      return null;
    }
  } catch (e) {
    // Handle errors and inform the user
    print("Erreur lors de la récupération des données : $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Erreur lors de la connexion. Veuillez réessayer.'),
      ),
    );
    return null;
  }
}

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/images/sape.png',
                    width: double.infinity,
                    height: 270,
                    fit: BoxFit.fitWidth,
                    alignment: Alignment(0, -1),
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional(-1, 0),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(20, 30, 0, 10),
                    child: Text(
                      'Sign In',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        color: Color(0xFF3535F8),
                        fontSize: 40,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                
                Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.disabled,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 20),
                        child: TextFormField(
                          controller: _IdController,
                          focusNode: _idFocusNode,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'matricule\\e-mail(professor)',
                            labelStyle: TextStyle(
                              fontFamily: 'Inter',
                              letterSpacing: 0.0,
                            ),
                            hintText: 'matricule\\e-mail(professor)',
                            hintStyle: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 10,
                              letterSpacing: 0.0,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFF2145BF),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color:  Color(0xFF2145BF),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            filled: true,
                            fillColor: Color(0xFFFDFDFF),
                            prefixIcon: Icon(
                              Icons.person_outline_rounded,
                              color: Color(0xFF2E4EBA),
                            ),
                          ),
                          style: TextStyle(
                            fontFamily: 'Inter',
                            letterSpacing: 0.0,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email or matricule';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 20),
                        child: TextFormField(
                          controller: _passwordController,
                          focusNode: _passwordFocusNode,
                          obscureText: !_passwordVisibility,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(
                              fontFamily: 'Inter',
                              letterSpacing: 0.0,
                            ),
                            hintText: 'Password',
                            hintStyle: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 10,
                              letterSpacing: 0.0,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFF2145BF),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color:  Color(0xFF2145BF),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            filled: true,
                            fillColor: Color(0xFFFDFDFF),
                            prefixIcon: Icon(
                              Icons.lock,
                              color: Color(0xFF2E4EBA),
                            ),
                            suffixIcon: InkWell(
                              onTap: () {
                                setState(() {
                                  _passwordVisibility = !_passwordVisibility;
                                });
                              },
                              child: Icon(
                                _passwordVisibility
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                size: 22,
                              ),
                            ),
                          ),
                          style: TextStyle(
                            fontFamily: 'Inter',
                            letterSpacing: 0.0,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 20, 20),
                    child: Text(
                      'Forget Password?',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        color: Color(0xFF12329F),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(20, 10, 20, 0),
                  child: ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF214FE7),
                      minimumSize: Size(double.infinity, 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Sign in',
                      style: TextStyle(
                        fontFamily: 'Inter Tight',
                        color: Colors.white,
                        letterSpacing: 0.0,
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: AlignmentDirectional(1, 0),
                      child: Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(20, 10, 3, 20),
                        child: Text(
                          "i don't have an account? ",
                          style: GoogleFonts.inter(
                            color: const Color(0xFF12329F),
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 20, 20),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignUpWidget()),
                        );
                        },
                        child: Text(
                          'Sign Up',
                          style: GoogleFonts.inter(
                            color: const Color(0xFF1839AD),
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                          ),
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
    );
  }
}