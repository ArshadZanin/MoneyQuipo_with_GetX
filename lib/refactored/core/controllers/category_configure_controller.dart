import 'package:get/get.dart';
import 'package:money_management/refactored/core/database/category_db.dart';
import 'package:money_management/refactored/core/models/category.dart';
import 'package:money_management/refactored/core/models/transaction.dart';

class CategoryConfigureController extends GetxController {
  final categoryDb = Get.put(CategoryDb());

  RxList<Category> categories = RxList<Category>();

  Future<void> initialize(TransactionType transactionType) async {
    categories.value = await categoryDb.fetchCategories(type: transactionType);
  }

  Future<void> addCategory(String name, TransactionType transactionType) async {
    final category = Category(
      name: name.capitalizeFirst,
      type: transactionType,
    );
    await categoryDb.insertCategory([category]);
    categories.add(category);
  }

  Future<void> editCategory(
    String name,
    int index,
  ) async {
    final category = categories[index];
    await categoryDb.updateCategory(
      categories[index].id ?? 0,
      name.capitalizeFirst ?? name,
    );
    categories[index] = Category(
      id: category.id,
      name: name.capitalizeFirst,
      type: category.type,
    );
  }

  Future<void> deleteCategory(int index, int id) async {
    await categoryDb.deleteCategory(id);
    categories.removeAt(index);
  }
}
