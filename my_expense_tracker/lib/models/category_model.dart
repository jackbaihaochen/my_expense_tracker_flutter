import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_expense_tracker/utils.dart';

class CategoryModel {
  final String name;
  final IconData image;

  CategoryModel({
    required this.name,
    required this.image,
  });

  factory CategoryModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return CategoryModel(
      name: data?['name'],
      image: codePointToIcon(data?['image']),
    );
  }

  factory CategoryModel.fromMap(Map<String, dynamic> data) {
    return CategoryModel(
      name: data['name'],
      image: codePointToIcon(data['image']),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'image': image.codePoint,
    };
  }
}

CategoryModel othersCategory = CategoryModel(
  name: 'Others',
  image: Icons.category,
);
List<CategoryModel> defaultCategories = [
  CategoryModel(
    name: 'Food',
    image: Icons.fastfood,
  ),
  CategoryModel(
    name: 'Transportation',
    image: Icons.directions_bus,
  ),
  CategoryModel(
    name: 'Shopping',
    image: Icons.shopping_cart,
  ),
  CategoryModel(
    name: 'Entertainment',
    image: Icons.movie,
  ),
  CategoryModel(
    name: 'Health',
    image: Icons.local_hospital,
  ),
  CategoryModel(
    name: 'Education',
    image: Icons.school,
  ),
  othersCategory,
];
