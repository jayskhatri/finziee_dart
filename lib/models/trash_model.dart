class TrashModel{
  int? trashId;
  String? trashComment;
  String? trashAmount;
  String? trashDate;
  int? trashAccId;
  int? trashCatId;
  int? trashIsAutoAdded;
  String? trashImgPath;

  TrashModel({this.trashId, this.trashComment, this.trashAmount, this.trashDate, this.trashAccId, this.trashCatId, this.trashIsAutoAdded, this.trashImgPath});

  factory TrashModel.fromJson(Map<String, dynamic> json){
    return TrashModel(
      trashId: json['trash_id'],
      trashComment: json['trash_comment'],
      trashAmount: json['trash_amount'],
      trashDate: json['trash_date'],
      trashAccId: json['trash_acc_id'],
      trashCatId: json['trash_cat_id'],
      trashIsAutoAdded: json['trash_is_auto_added'],
      trashImgPath: json['trash_img_path']
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'trash_id': trashId,
      'trash_comment': trashComment,
      'trash_amount': trashAmount,
      'trash_date': trashDate,
      'trash_acc_id': trashAccId,
      'trash_cat_id': trashCatId,
      'trash_is_auto_added': trashIsAutoAdded,
      'trash_img_path': trashImgPath
    };
  }
}