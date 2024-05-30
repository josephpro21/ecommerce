import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:testtwo/Login/SignUp/login.dart';
import 'package:testtwo/bottombar/Navigationbar.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  bool SignupButtonPressed = false;
  bool isobscureText = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final usernameController = TextEditingController();
  // final _formkey = GlobalKey<FormState>();

  Future<void> signup(BuildContext context) async {
    // if (_formkey.currentState!.validate()) {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);

      final User? user = userCredential.user;
      if (user != null) {
        await FirebaseFirestore.instance.collection('Users').add({
          'username': usernameController.text,
          'email': emailController.text,
        });
      }
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => const NavbarElements()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        const Text("Weak password");
      } else if (e.code == 'user-not-found') {
        const Text('user not found');
      }
    } catch (e) {
      const Text("Error occurred");
    }
    // }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Sign up",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold)),
          centerTitle: true,
          backgroundColor: Colors.purpleAccent,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.grey,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  TextField(
                    controller: usernameController,
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.person), hintText: "Username"),
                  ),
                  const SizedBox(
                    height: 7,
                  ),
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.email), hintText: "Email"),
                  ),
                  const SizedBox(
                    height: 7,
                  ),
                  TextField(
                    obscureText: !isobscureText,
                    controller: passwordController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(isobscureText
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () {
                          setState(() {
                            isobscureText = !isobscureText;
                          });
                        },
                      ),
                      hintText: "Password",
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        signup(context);
                        setState(() {
                          SignupButtonPressed = !SignupButtonPressed;
                        });
                        print("Pressed");
                      },
                      child: SignupButtonPressed == true
                          ? Center(child: CircularProgressIndicator())
                          : const Text("Sign Up")),
                  const SizedBox(
                    height: 10,
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Login()));
                      },
                      child: const Text("Already Have Account,Login")),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
