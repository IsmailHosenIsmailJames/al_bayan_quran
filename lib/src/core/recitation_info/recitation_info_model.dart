import 'dart:convert';

class RecitationInfoModel {
  String? subfolder;
  String? name;
  String? bitrate;

  RecitationInfoModel({
    this.subfolder,
    this.name,
    this.bitrate,
  });

  RecitationInfoModel copyWith({
    String? subfolder,
    String? name,
    String? bitrate,
  }) =>
      RecitationInfoModel(
        subfolder: subfolder ?? this.subfolder,
        name: name ?? this.name,
        bitrate: bitrate ?? this.bitrate,
      );

  factory RecitationInfoModel.fromJson(String str) =>
      RecitationInfoModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory RecitationInfoModel.fromMap(Map<String, dynamic> json) =>
      RecitationInfoModel(
        subfolder: json["subfolder"],
        name: json["name"],
        bitrate: json["bitrate"],
      );

  Map<String, dynamic> toMap() => {
        "subfolder": subfolder,
        "name": name,
        "bitrate": bitrate,
      };
}
