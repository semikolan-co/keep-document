import 'dart:convert';

class DataItem {
  String title;
  List<dynamic> imgUrl;
  String description;
  String id;
  String date;
  List<dynamic>? pdfPath;

  DataItem({required this.title,required this.imgUrl,required this.description,required this.id,required this.date, required this.pdfPath});

    static Map<String,dynamic> toJson(DataItem dataItem){
    return {
      'title': dataItem.title,
      'imgUrl': dataItem.imgUrl,
      'description': dataItem.description,
      'id': dataItem.id,
      'date': dataItem.date,
      'pdfPath': dataItem.pdfPath,
    };
  }
  factory DataItem.fromJson(Map<String, dynamic> jsonData){
    return DataItem(
      title: jsonData['title'],
      imgUrl: jsonData['imgUrl'],
      description: jsonData['description'],
      id: jsonData['id'],
      date: jsonData['date'],
      pdfPath: jsonData['pdfPath']
    );
    // m['title'] = title;
    // m['imgUrl'] = imgUrl;
    // m['description'] = description;
    // m['id'] = id;
    // m['date'] = date;
  }

  static String encode(List<DataItem> musics) => json.encode(
        musics
            .map<Map<String, dynamic>>((music) => DataItem.toJson(music))
            .toList(),
      );

  static List<DataItem> decode(String musics) =>
      (json.decode(musics) as List<dynamic>)
          .map<DataItem>((item) => DataItem.fromJson(item))
          .toList();
}