import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:testtwo/Login/SignUp/passwordreset.dart';
import 'package:testtwo/Login/SignUp/signup.dart';
import 'package:testtwo/bottombar/Navigationbar.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool LoginButtonPressed = false;
  bool isobscureText = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  // final _formkey = GlobalKey<FormState>();

  Future<void> login(BuildContext context) async {
    // if (_formkey.currentState!.validate()) {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      //clearing the fields.
      // emailController.clear();
      // passwordController.clear();
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //   content: const Text("Login Successful"),
      // ));
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const NavbarElements()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        const Text("Weak password");
        // ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(content: Text("Weak Password")));
      } else if (e.code == 'user-not-found') {
        const Text('user not found');
        // ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(content: const Text("User not found")));
      }
    } catch (e) {
      const Text("Error Occurred");
    }
    // }
  }
  // @override
  // void dispose(){
  //   emailController.clear();
  //   passwordController.clear();
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Login",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold)),
          centerTitle: true,
          backgroundColor: Colors.purpleAccent,
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.grey,
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.email), hintText: "Email"),
                ),
                const SizedBox(
                  height: 10,
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
                      setState(() {
                        LoginButtonPressed = !LoginButtonPressed;
                      });
                      login(context);
                      print("Pressed");
                    },
                    child: LoginButtonPressed == true
                        ? Center(child: CircularProgressIndicator())
                        : const Text("Login")),
                const SizedBox(
                  height: 10,
                ),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  const Signup()));
                    },
                    child: const Text("Don't Have Account?Create Account")),
                const Divider(
                  thickness: 2,
                ),
                const SizedBox(
                  height: 2,
                ),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  const PasswordReset()));
                    },
                    child: const Text(
                      "Forgot Password ?",
                      style: TextStyle(color: Colors.black54),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DisplayPage extends StatelessWidget {
  const DisplayPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasData) {
          return const NavbarElements();
        } else {
          return const Login();
        }
      },
    );
  }
}
