class TransactionModel{
  int? id;
  String? comment;
  String? amount;
  String? date;
  int? accId;
  int? catId;
  int? isAutoAdded;
  String? imgPath;

  TransactionModel({this.id, this.comment, this.amount, this.date, this.accId, this.catId, this.isAutoAdded, this.imgPath});

  factory TransactionModel.fromJson(Map<String, dynamic> json){
    return TransactionModel(
      id: json['id'],
      comment: json['comment'],
      amount: json['amount'],
      date: json['date'],
      accId: json['acc_id'],
      catId: json['cat_id'],
      isAutoAdded: json['is_auto_added'],
      imgPath: json['img_path']
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'id': id,
      'comment': comment,
      'amount': amount,
      'date': date,
      'acc_id': accId,
      'cat_id': catId,
      'is_auto_added': isAutoAdded,
      'img_path': imgPath
    };
  }
}