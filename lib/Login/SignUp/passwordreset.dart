import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PasswordReset extends StatefulWidget {
  const PasswordReset({super.key});

  @override
  State<PasswordReset> createState() => _PasswordResetState();
}

class _PasswordResetState extends State<PasswordReset> {
  bool isobscureText = false;
  TextEditingController emailController = TextEditingController();

  Future<void> resetpassword(BuildContext context) async {
    try {      FirebaseAuth auth = FirebaseAuth.instance;
      await auth.sendPasswordResetEmail(email: emailController.text);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: const Text("Reset Successful")));
      // Navigator.push(
      //     context, MaterialPageRoute(builder: (context) => const NavbarElements()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        const Text('user not found');
        // ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(content: const Text("User not found")));
      }
    } catch (e) {
      const Text("Error Occurred");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Reset Password",
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
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.email), hintText: "Email"),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    onPressed: () {
                      resetpassword(context);
                      print("Pressed");
                    },
                    child: const Text("Submit")),
                const SizedBox(
                  height: 10,
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Go back")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
