class StyleUpModel {
  String name;
  String type;
  List<String> imageList;
  String video;
  String result;

  StyleUpModel({
    required this.name,
    required this.type,
    required this.imageList,
    required this.video,
    required this.result,
  });

  factory StyleUpModel.fromJson(Map<String, dynamic> json) {
    return StyleUpModel(
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      imageList: List<String>.from(json['image_list'] as List<dynamic>),
      video: json['video'] ?? '',
      result: json['result'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type,
      'image_list': imageList,
      'video': video,
      'result': result,
    };
  }
}
