// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
//
// class SearchPage extends StatefulWidget {
//   const SearchPage({super.key});
//
//   @override
//   State<SearchPage> createState() => _SearchPageState();
// }
//
// class _SearchPageState extends State<SearchPage> {
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(
//         stream: FirebaseFirestore.instance
//             .collection('products')
//             .where('productname', isGreaterThanOrEqualTo: _search)
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return const Center(
//               child: Text("No Item Found"),
//             );
//           }
//           final product = snapshot.data!.docs;
//           return GridView.builder(
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2, mainAxisSpacing: 4),
//               itemCount: product.length,
//               itemBuilder: (context, index) {
//                 final document = product[index];
//                 return GestureDetector(
//                   onTap: () {
//                     showModalBottomSheet(
//                         isScrollControlled: true,
//                         context: context,
//                         builder: (BuildContext context) {
//                           return SingleChildScrollView(
//                             child: Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Column(
//                                 children: [
//                                   Image.network(
//                                     document!['image'],
//                                     height: 200,
//                                     fit: BoxFit.cover,
//                                     //width: double.infinity,
//                                   ),
//                                   const SizedBox(
//                                     height: 5,
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: Text(document['productname']),
//                                   ),
//                                   const SizedBox(
//                                     height: 5,
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: Text(document['productprice']),
//                                   ),
//                                   const SizedBox(
//                                     height: 5,
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: Text(document['productdescription']),
//                                   ),
//                                   const SizedBox(
//                                     height: 20,
//                                   ),
//                                   ElevatedButton(
//                                       onPressed: () async {
//                                         //Logic to add product to cart
//                                         try {
//                                           await FirebaseFirestore.instance
//                                               .collection('cart')
//                                               .add({
//                                             'productname':
//                                                 document['productname'],
//                                             'image': document['image'],
//                                             'productprice':
//                                                 document['productprice']
//                                           });
//                                           ScaffoldMessenger.of(context)
//                                               .showSnackBar(const SnackBar(
//                                                   content: Text(
//                                                       "Added Successfully to cart")));
//                                         } catch (e) {
//                                           ScaffoldMessenger.of(context)
//                                               .showSnackBar(const SnackBar(
//                                                   content: Text(
//                                                       "Failed To add to cart")));
//                                         }
//                                       },
//                                       child: const Text('Add To Cart'))
//                                 ],
//                               ),
//                             ),
//                           );
//                         });
//                   },
//                   child: Card(
//                     margin: const EdgeInsets.all(3.0),
//                     child: Column(
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.all(4.0),
//                           child: Container(
//                             height: 100,
//                             width: 140,
//                             child: ClipRRect(
//                               borderRadius: BorderRadius.circular(4.0),
//                               child: Image.network(
//                                 document!['image'],
//                                 loadingBuilder:
//                                     (context, child, loadingProgress) {
//                                   if (loadingProgress == null) {
//                                     return child;
//                                   }
//                                   return const Center(
//                                     child: CircularProgressIndicator(
//                                       color: Colors.blue,
//                                     ),
//                                   );
//                                 },
//                                 // fit: BoxFit.cover,
//                               ),
//                             ),
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Column(
//                             children: [
//                               Text(document['productname']),
//                               const SizedBox(
//                                 height: 3,
//                               ),
//                               Text(document['productprice']),
//                             ],
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 );
//               });
//         });
//   }
// }
