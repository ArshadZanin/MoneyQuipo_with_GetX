import 'package:get/get.dart';
import 'package:money_management/refactored/core/models/transaction.dart';

class Category {
  final int? id;
  final String? name;
  final TransactionType? type;

  Category({
    this.id,
    this.name,
    this.type,
  });

  Category.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        name = res['name'],
        type = TransactionType.values.firstWhereOrNull(
          (e) => e.name == res['type'],
        );

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type?.name,
    };
  }
}
