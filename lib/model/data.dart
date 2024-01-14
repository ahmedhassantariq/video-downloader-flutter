class DataModel {
  final String title;
  final List<dynamic> formats;


  const DataModel({
    required this.title,
    required this.formats,
  });

  factory DataModel.fromJson(Map<String, dynamic> json){
    return DataModel(
        title: json['title'],
        formats: json['formats']);
  }

}