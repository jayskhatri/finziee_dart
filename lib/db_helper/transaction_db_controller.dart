

import 'package:finziee_dart/models/transaction_model.dart';
import 'package:finziee_dart/db_helper/db/db_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class TransactionController{
  var transactionsList = <TransactionModel>[].obs;

  Future<int> addTransaction({TransactionModel? transaction})async{
    var result = await DBHelper.insertTransaction(transaction!);
    if(result > 0){
      transactionsList.add(transaction);
      print('Added successfully');
    }else{
      if (kDebugMode) {
        print('Failed to add transaction');
      }
    }
    return result;
  }

  Future<List<TransactionModel>> getTransactions() async {
    List<Map<String,dynamic>> transactions = await DBHelper.getTransactions();
    transactionsList.assignAll(transactions.map((data) =>  TransactionModel.fromJson(data)).toList());
    if(kDebugMode){
      print('Total fetched transactions: ${transactionsList.length}');
    }
    return transactionsList;
  }

  Future<int> updateTransaction({TransactionModel? transaction}) async {
    var result = await DBHelper.updateTransaction(transaction!);
    return result;
  }

  void deleteAllTransactions() async {
    DBHelper.deleteAllTransactions();
  }

  //delete particular category
  Future<int> deleteTransaction(int? id) async {
    return await DBHelper.deleteTransaction(id!);
  }
}