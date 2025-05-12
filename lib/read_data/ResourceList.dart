import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:resource_booking_app/components/AppBar.dart';
import 'package:resource_booking_app/users/Booking.dart';
import 'package:resource_booking_app/users/Home.dart';
import 'package:resource_booking_app/users/Profile.dart';
import 'package:resource_booking_app/users/Settings.dart';

class Resourcelist extends StatefulWidget {
  const Resourcelist({super.key});

  @override
  State<Resourcelist> createState() => _ResourcelistState();
}

class _ResourcelistState extends State<Resourcelist> {
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  Future<void> _update([DocumentSnapshot? document])async {
    if(document != null){
      _nameController.text = document['name'];
      _priceController.text = document['price'].toString();
    }

    await showModalBottomSheet(
      isScrollControlled: true,
      context: context, 
      builder: (BuildContext context){
        return Container(
          padding: EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price'),
              ),
              const SizedBox(height: 20,),
              ElevatedButton(
                child: const Text('Update'),
                onPressed: () async {
                  final String name = _nameController.text;
                  final double? price = double.tryParse(_priceController.text);
                  if(price != null){
                    await _resourceCollection.doc(document!.id).update({
                      'name': name,
                      'price': price
                    });
                    _nameController.text = '';
                    _priceController.text = '';
                    Navigator.pop(context);
                  }
                },
              )
            ],
          ),
        );
      }
    );
  }

  void logout(){
    FirebaseAuth.instance.signOut();
  }


  final CollectionReference _resourceCollection =
      FirebaseFirestore.instance.collection('products');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: "Resource List"),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
             DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 20, 148, 24),
              ),
              child: Column(
                children: [
                  Image.asset(
                    "images/logo.png",
                    height: 50
                  ),
                  Text(
                    'Mzuzu University',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  Text(
                    'Campus Resource Booking',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              title: const Text('Home'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
              },
            ),
            ListTile(
              title: const Text('Profile'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen()));
              },
            ),
            ListTile(
              title: const Text('Resources'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Resourcelist()));
              },
            ),
            ListTile(
              title: const Text('Booking'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => BookingScreen()));
              },
            ),

            ListTile(
              title: const Text('Setings'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsScreen()));
              },
            ),
            ListTile(
              title: const Text('Logout'),
              onTap: () {
                logout();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: StreamBuilder(
        stream: _resourceCollection.snapshots(), 
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot){
          if(streamSnapshot.hasData){
            return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index){
                final DocumentSnapshot document = streamSnapshot.data!.docs[index];
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: ListTile(
                          title: Text(document['name']),
                          //subtitle: Text(document['price'].toString()),
                          trailing:  SizedBox(
                            width: 100,
                            child: Row( 
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    // Edit action
                                    _update(document);
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    // Delete action
                                    _resourceCollection.doc(document.id).delete();
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ); 
              },
            );
          } else if (streamSnapshot.hasError) {
            return Center(child: Text('Error: ${streamSnapshot.error}'));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        }
      ),
    );
  }
}