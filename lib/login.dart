import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final regUsernameTextEditingController = TextEditingController();
  final regEmailTextEditingController = TextEditingController();
  final regPasswordTextEditingController = TextEditingController();
  final regVerifPasswordTextEditingController = TextEditingController();

  final logEmailTextEditingController = TextEditingController();
  final logPasswordTextEditingController = TextEditingController();

  final user = FirebaseAuth.instance.currentUser;

  /// Check If Email Is Taken
  Future<bool> checkIfEmailExists(String email) async {
    try {
      // Get reference to Firestore collection
      var collectionRef = FirebaseFirestore.instance.collection('users');

      var doc = await collectionRef.doc(email).get();
      return !doc.exists;
    } catch (e) {
      rethrow;
    }
  }

  Future signIn() async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: logEmailTextEditingController.text.trim(),
        password: logPasswordTextEditingController.text.trim());
  }

  Future signUp() async {
    // create user
    if (passwordVerification()) {
      FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: regEmailTextEditingController.text.trim(),
          password: regPasswordTextEditingController.text.trim());
    }
  }

  Future addUserDatails(String username, String email) async {
    await FirebaseFirestore.instance.collection('users').doc(username).set({
      'username': username,
      'email': email,
      'overallAvgWpm': 0,
      'numTestsStarted': 0,
      'highestWpm': 0,
      'highest15SecondWpm': 0,
      'accuracyOfHighest15SecondWpm': 0,
      'highest30SecondWpm': 0,
      'accuracyOfHighest30SecondWpm': 0,
      'highest60SecondWpm': 0,
      'accuracyOfHighest60SecondWpm': 0,
      'highest120SecondWpm': 0,
      'accuracyOfHighest120SecondWpm': 0,
    });
  }

  bool passwordVerification() {
    if (regPasswordTextEditingController.text.trim() ==
        regVerifPasswordTextEditingController.text.trim()) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void dispose() {
    regUsernameTextEditingController.dispose();
    regEmailTextEditingController.dispose();
    regPasswordTextEditingController.dispose();

    logEmailTextEditingController.dispose();
    logPasswordTextEditingController.dispose();
    super.dispose();
  }

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
            onPressed: () {},
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 32, 1, 46),
        actions: [
          Padding(
            padding: EdgeInsets.only(
                right: MediaQuery.of(context).size.width * 0.12),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.person_outlined,
                  size: 30, color: Colors.white38),
            ),
          ),
        ],
      ),
      body: Padding(
        padding:
            EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.15),
        child: SizedBox(
          height: 300,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'register',
                      style: TextStyle(color: Colors.white, fontSize: 17),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.2,
                      child: TextField(
                        cursorColor: Colors.pink,
                        style: const TextStyle(color: Colors.white),
                        controller: regUsernameTextEditingController,
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Color.fromARGB(255, 29, 2, 40),
                          border: InputBorder.none,
                          hintText: 'username',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.2,
                      child: TextField(
                        cursorColor: Colors.pink,
                        style: const TextStyle(color: Colors.white),
                        controller: regEmailTextEditingController,
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Color.fromARGB(255, 29, 2, 40),
                          border: InputBorder.none,
                          hintText: 'email',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.2,
                      child: TextField(
                        cursorColor: Colors.pink,
                        obscureText: true,
                        style: const TextStyle(color: Colors.white),
                        controller: regPasswordTextEditingController,
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Color.fromARGB(255, 29, 2, 40),
                          border: InputBorder.none,
                          hintText: 'password',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.2,
                      child: TextField(
                        cursorColor: Colors.pink,
                        obscureText: true,
                        style: const TextStyle(color: Colors.white),
                        controller: regVerifPasswordTextEditingController,
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Color.fromARGB(255, 29, 2, 40),
                          border: InputBorder.none,
                          hintText: 'verify password',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.2,
                      height: 40,
                      child: TextButton.icon(
                        style: ButtonStyle(
                          backgroundColor: const MaterialStatePropertyAll(
                            Color.fromARGB(255, 29, 2, 40),
                          ),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        onPressed: () async {
                          bool emailAvailable = await checkIfEmailExists(
                              regEmailTextEditingController.text.trim());
                          if (regUsernameTextEditingController
                                  .text.isNotEmpty &&
                              regEmailTextEditingController.text.isNotEmpty &&
                              regPasswordTextEditingController
                                  .text.isNotEmpty &&
                              emailAvailable) {
                            signUp();
                            // save user details
                            addUserDatails(
                                regUsernameTextEditingController.text.trim(),
                                regEmailTextEditingController.text.trim());
                          } else {
                            null;
                          }
                        },
                        icon: const Icon(
                          Icons.person_add_alt_1,
                          color: Colors.white,
                          size: 20,
                        ),
                        label: Text(
                          'Sign Up',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: MediaQuery.of(context).size.width < 600
                                  ? 10
                                  : 17),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 195,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'login',
                      style: TextStyle(color: Colors.white, fontSize: 17),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.2,
                      child: TextField(
                        cursorColor: Colors.pink,
                        style: const TextStyle(color: Colors.white),
                        controller: logEmailTextEditingController,
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Color.fromARGB(255, 29, 2, 40),
                          border: InputBorder.none,
                          hintText: 'email',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.2,
                      child: TextField(
                        cursorColor: Colors.pink,
                        obscureText: true,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                        controller: logPasswordTextEditingController,
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Color.fromARGB(255, 29, 2, 40),
                          border: InputBorder.none,
                          hintText: 'password',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.2,
                      height: 40,
                      child: TextButton.icon(
                        style: ButtonStyle(
                          backgroundColor: const MaterialStatePropertyAll(
                            Color.fromARGB(255, 29, 2, 40),
                          ),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        onPressed: () {
                          if (logEmailTextEditingController.text.isNotEmpty &&
                              logPasswordTextEditingController
                                  .text.isNotEmpty) {
                            signIn();
                            return;
                          } else {
                            null;
                          }
                        },
                        icon: const Icon(
                          Icons.exit_to_app_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                        label: Text(
                          'Sign In',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: MediaQuery.of(context).size.width < 600
                                  ? 10
                                  : 17),
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
    );
  }
}
