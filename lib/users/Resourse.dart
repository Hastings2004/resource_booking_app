import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:resource_booking_app/components/AppBar.dart';
import 'package:resource_booking_app/users/Booking.dart';
import 'package:resource_booking_app/users/Home.dart';
import 'package:resource_booking_app/users/Profile.dart';
import 'package:resource_booking_app/users/Settings.dart';

class ResourcesScreen extends StatefulWidget {
  ResourcesScreen({super.key});

  @override
  _ResourseScreenState createState() => _ResourseScreenState();
}

class _ResourseScreenState extends State<ResourcesScreen> {
  final user = FirebaseAuth.instance.currentUser!;

  void logout() {
    FirebaseAuth.instance.signOut();
  }

  List<String> docIDs = [];

  Future<void> getDocIDs() async {
    final snapshot = await FirebaseFirestore.instance.collection('resources').get();
    docIDs = snapshot.docs.map((doc) => doc.id).toList();
    setState(() {}); // Trigger a rebuild to show the data
  }

  @override
  void initState() {
    super.initState();
    getDocIDs(); // Call getDocIDs when the widget is created
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(
        title: "Resources",
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 20, 148, 24),
              ),
              child: Column(
                children: [
                  Image.asset(
                      "assets/images/logo.png",
                      height: 50
                  ),
                  const Text(
                    'Mzuzu University',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'Campus Resource Booking',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
            ),
            ListTile(
              title: const Text('Home'),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Home()));
              },
            ),
            ListTile(
              title: const Text('Profile'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ProfileScreen()));
              },
            ),
            ListTile(
              title: const Text('Resources'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ResourcesScreen()));
              },
            ),
            ListTile(
              title: const Text('Booking'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => BookingScreen()));
              },
            ),
            ListTile(
              title: const Text('Setings'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SettingsScreen()));
              },
            ),
            ListTile(
              title: const Text('Logout'),
              onTap: () {
                logout();
                Navigator.pop(context);
              },
            ),
            Text(
              "${user.email!}",
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: docIDs.length,
                itemBuilder: (context, index) {
                  final docId = docIDs[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: ListTile(
                        title: Text("Resource ID: $docId"), // Display the document ID
                        trailing: IconButton(
                          icon: const Icon(Icons.arrow_forward),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProfileScreen()));
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}