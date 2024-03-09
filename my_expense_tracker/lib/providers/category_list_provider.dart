import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_expense_tracker/models/category_model.dart';
import 'package:my_expense_tracker/utils.dart';

final auth = FirebaseAuth.instance;
final db = FirebaseFirestore.instance;
const String categoriesCollectionName = 'categories_collection';
CollectionReference<Map<String, dynamic>> getCategoriesCollection() {
  // Get user's uid
  final userUid = getUserUid();
  // Get the expenses collection from the firestore by the user's uid
  return db
      .collection(categoriesCollectionName)
      .doc(userUid)
      .collection(categoriesCollectionName);
}

class CategoryListNotifier extends StateNotifier<List<CategoryModel>> {
  CategoryListNotifier() : super(defaultCategories);

  Future<bool> upsertCategory({
    required BuildContext context,
    required CategoryModel category,
  }) async {
    final collection = getCategoriesCollection();
    return collection
        .withConverter(
          fromFirestore: CategoryModel.fromFirestore,
          toFirestore: (category, options) => category.toFirestore(),
        )
        .doc(category.name)
        .set(category)
        .then((doc) {
      state = [...state, category];
      showSnackBar(context, 'Category Upserted Successfully');
      return true;
    }).catchError((e) {
      showSnackBar(context, 'Failed to Upsert Category: $e');
      return false;
    });
  }

  Future<bool> removeCategory({
    required BuildContext context,
    required CategoryModel category,
  }) {
    final collection = getCategoriesCollection();
    return collection.doc(category.name).delete().then((value) {
      state = state.where((e) => e.name != category.name).toList();
      showSnackBar(context, 'Category Removed Successfully');
      return true;
    }).catchError((e) {
      showSnackBar(context, 'Remove Category Failed: $e');
      return false;
    });
  }

  void getCategories() async {
    final collection = getCategoriesCollection();
    final snapshot = await collection
        .withConverter(
          fromFirestore: CategoryModel.fromFirestore,
          toFirestore: (category, options) => category.toFirestore(),
        )
        .get();
    final categories = snapshot.docs.map((e) => e.data()).toList();
    state = [...state, ...categories];
  }
}

final categoryListProvider =
    StateNotifierProvider<CategoryListNotifier, List<CategoryModel>>(
  (ref) => CategoryListNotifier(),
);
