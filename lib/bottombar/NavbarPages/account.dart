import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:testtwo/Login/SignUp/login.dart';
import 'package:testtwo/bottombar/NavbarPages/account_pages/aboutmarket.dart';
import 'package:testtwo/bottombar/NavbarPages/account_pages/changeEmail.dart';
import 'package:testtwo/bottombar/NavbarPages/account_pages/changePassword.dart';
import 'package:testtwo/bottombar/NavbarPages/account_pages/changeUsername.dart';
import 'package:testtwo/bottombar/NavbarPages/account_pages/deleteAccount.dart';
import 'package:testtwo/bottombar/NavbarPages/account_pages/faqs.dart';
import 'package:testtwo/bottombar/NavbarPages/account_pages/privacypolicy.dart';
import 'package:testtwo/bottombar/NavbarPages/account_pages/termandconditions.dart';
import 'package:testtwo/bottombar/NavbarPages/uploadProduct.dart';
import 'package:testtwo/bottombar/geofencebeta.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  Future<void> logout() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Log out"),
            content: const Text("Are you sure to log out?"),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Cancel")),
              ElevatedButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => const Login()));
                  },
                  child: const Text("Accept"))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          Center(
            child: ElevatedButton(
              child: const Text("Upload Products"),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const UploadProduct()));
              },
            ),
          ),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.info),
                  title: const Text("About Market"),
                  trailing: const Icon(Icons.arrow_forward),
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const About()));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.question_mark),
                  title: const Text("Frequently Asked Questions"),
                  trailing: const Icon(Icons.arrow_forward),
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const Faqs()));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.privacy_tip),
                  title: const Text("Privacy Policy"),
                  trailing: const Icon(Icons.arrow_forward),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const PrivacyPolicy()));
                  },
                ),
              ],
            ),
          ),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.share),
                  title: const Text("Share App"),
                  trailing: const Icon(Icons.arrow_forward),
                  onTap: () {
                    Share.share('Share Jt via');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.star),
                  title: const Text("Rate App"),
                  trailing: const Icon(Icons.arrow_forward),
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const About()));
                  },
                ),
              ],
            ),
          ),
          Card(
              child: Column(
            children: [
              ListTile(
                leading: CircleAvatar(
                  radius: 18,
                  backgroundImage: AssetImage('assets/images/Whatsapp.jpeg'),
                ),
                title: const Text("WhatsApp"),
                trailing: const Icon(Icons.arrow_forward),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.email),
                title: const Text("Email"),
                trailing: const Icon(Icons.arrow_forward),
                onTap: () {},
              ),
            ],
          )),
          Card(
              child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.handshake),
                title: const Text("Terms and Conditions"),
                trailing: const Icon(Icons.arrow_forward),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const TermsAndConditions()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.feedback),
                title: const Text("Access Geofence"),
                trailing: const Icon(Icons.arrow_forward),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const GeofenceFirebase()));
                },
              ),
            ],
          )),
          Card(
            child: ExpansionTile(
              title: const Text("Manage Account"),
              children: [
                Center(
                  child: ElevatedButton(
                    child: const Text("Delete Account"),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const DeleteAccount()));
                    },
                  ),
                ),
                Center(
                  child: ElevatedButton(
                    child: const Text("Change Password"),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const ChangePassword()));
                    },
                  ),
                ),
                Center(
                  child: ElevatedButton(
                    child: const Text("Change Username"),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const ChangeUsername()));
                    },
                  ),
                ),
                Center(
                  child: ElevatedButton(
                    child: const Text("Update Email"),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const ChangeEmail()));
                    },
                  ),
                )
              ],
            ),
          ),
          Center(
            child: ElevatedButton(
              child: const Text("Log Out"),
              onPressed: () {
                logout();
              },
            ),
          )
        ]),
      ),
    );
  }
}
