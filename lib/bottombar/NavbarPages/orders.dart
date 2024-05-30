import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Orders extends StatelessWidget {
  const Orders({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: const Text('Select Category'),
        ),
        Expanded(
          child: StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('Category').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: Column(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(
                        height: 10,
                      ),
                      Text('Loading Category')
                    ],
                  ));
                }

                return GridView.builder(
                    itemCount: snapshot.data!.docs.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 4,
                        crossAxisSpacing: 2),
                    itemBuilder: (context, index) {
                      var document = snapshot.data!.docs[index];
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            GestureDetector(
                              child: CircleAvatar(
                                backgroundImage:
                                    NetworkImage(document['image']),
                                radius: 45,
                              ),
                              onTap: () {},
                            ),
                            const SizedBox(
                              height: 1,
                            ),
                            Text(document['categoryname'])
                          ],
                        ),
                      );
                    });
              }),
        )
      ],
    );
  }
}
