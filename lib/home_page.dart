import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  final dynamic image;
  final dynamic title;
  final dynamic price;
  final dynamic description;
  final dynamic category;

  const HomeScreen(
      {super.key,
      this.image,
      this.title,
      this.price,
      this.description,
      this.category});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // List taskList = [];
  List<Product> taskList = [];

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    getApi();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: GridView.builder(
          padding: const EdgeInsets.all(30),
          scrollDirection: Axis.vertical,
          itemCount: taskList.length,
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 300,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 2,
              mainAxisExtent: 300),
          itemBuilder: (context, index) {
            final product = taskList[index];
            return Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    height: 200,
                    width: 300,
                    child: ClipRect(
                      child: CachedNetworkImage(
                        imageUrl: product.featuredImage,
                        width: 80,
                        alignment: Alignment.center,
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, left: 10),
                    child: Text(product.title),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> getApi() async {
    final response = await http.get(Uri.parse(
        'http://209.182.213.242/~mobile/MtProject/public/api/product_list.php'));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<Product> productList = (jsonData['data'] as List)
          .map((item) => Product.fromJson(item))
          .toList();
      setState(() {
        taskList = productList;
      });
    }
  }
}

class Product {
  final int id;
  final String title;
  final String description;
  final int price;
  final String featuredImage;
  final String createdAt;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.featuredImage,
    required this.createdAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      price: json['price'],
      featuredImage: json['featured_image'],
      createdAt: json['created_at'],
    );
  }
}
