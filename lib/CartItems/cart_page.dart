import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purpleAccent,
          title: const Text("Cart",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection('Cart')
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    const Text('No Item Found in Cart')
                  ],
                ),
              );
            }
            List<DocumentSnapshot> cartItems = snapshot.data!.docs;
            return ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  var item = cartItems[index];
                  return ListTile(
                    leading: Image.network(
                      item['image'],
                    ),
                    title: Text(
                      item['productname'],
                    ),
                    subtitle: Text(
                      item['productprice'],
                    ),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: ListTile(
                                  leading: Icon(Icons.question_mark),
                                  title: Text("Remove "),
                                  trailing: IconButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      icon: Icon(Icons.cancel_outlined)),
                                ),
                                content: ListTile(title: Text("Confirm")),
                                actions: [
                                  ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("Cancel")),
                                  ElevatedButton(
                                      onPressed: () {
                                        FirebaseFirestore.instance
                                            .collection('Users')
                                            .doc(FirebaseAuth
                                                .instance.currentUser!.uid)
                                            .collection('Cart')
                                            .doc(item.id)
                                            .delete();
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text(
                                        "Remove",
                                        style: TextStyle(color: Colors.red),
                                      )),
                                ],
                              );
                            });
                      },
                    ),
                  );
                });
          },
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(50.0),
          child: ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.green)),
            onPressed: () {},
            child: const Text("Proceed to Payment"),
          ),
        ),
      ),
    );
  }
}

class CartBadge extends StatelessWidget {
  const CartBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('Cart')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return IconButton(
              icon: const Icon(Icons.shopping_cart_rounded),
              onPressed: () {
                Center(
                  child: Text('No item Found in Cart'),
                );
              },
            );
          }
          List<DocumentSnapshot> cartItems = snapshot.data!.docs;
          int cartCount = cartItems.length;

          return Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const CartPage()));
                },
              ),
              cartCount > 0
                  ? Positioned(
                      right: 6,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(6)),
                        constraints:
                            const BoxConstraints(minWidth: 14, maxHeight: 14),
                        child: Text(
                          '$cartCount',
                          style:
                              const TextStyle(color: Colors.white, fontSize: 8),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ],
          );
        });
  }
}
