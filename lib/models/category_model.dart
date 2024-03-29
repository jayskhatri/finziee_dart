class CategoryModel{
  int? catId;
  String? catName;
  String? catType;
  String? catCount;
  String? catColorId;
  String? catIsFav;

  CategoryModel({this.catId, this.catName, this.catType, this.catCount, this.catColorId, this.catIsFav});

  factory CategoryModel.fromJson(Map<String, dynamic> json){
    return CategoryModel(
      catId: json['cat_id'],
      catName: json['cat_name'],
      catType: json['cat_type'],
      catCount: json['cat_count'],
      catColorId: json['cat_color_id'],
      catIsFav: json['cat_is_fav'],
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'cat_id': catId,
      'cat_name': catName,
      'cat_type': catType,
      'cat_count': catCount,
      'cat_color_id': catColorId,
      'cat_is_fav': catIsFav,
    };
  }
}