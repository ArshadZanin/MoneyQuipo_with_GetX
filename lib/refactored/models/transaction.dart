import 'package:get/get.dart';

enum TransactionType {
  income,
  expense,
}

enum AccountType {
  asset,
  liability,
}

class Transaction {
  final int? id;
  final TransactionType? transactionType;
  final DateTime? dateTime;
  final AccountType? account;
  final String? category;
  final num? amount;
  final String? note;

  Transaction({
    this.id,
    this.transactionType,
    this.dateTime,
    this.account,
    this.category,
    this.amount,
    this.note,
  });

  Transaction.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        transactionType = TransactionType.values.firstWhereOrNull(
          (e) => e.name == res['transactionType'],
        ),
        dateTime = DateTime.tryParse(res['dateTime'].toString()),
        account = AccountType.values.firstWhereOrNull(
          (e) => e.name == res['account'],
        ),
        category = res['category'],
        amount = num.tryParse(res['amount'].toString()),
        note = res['note'];

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'transactionType': transactionType?.name,
      'dateTime': dateTime?.toIso8601String(),
      'account': account?.name,
      'category': category,
      'amount': amount,
      'note': note
    };
  }
}
