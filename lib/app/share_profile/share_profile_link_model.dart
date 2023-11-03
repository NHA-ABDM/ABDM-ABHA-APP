import 'dart:convert';

ShareProfileLinkModel shareProfileLinkModelFromMap(String str) =>
    ShareProfileLinkModel.fromMap(json.decode(str));

String shareProfileLinkModelToMap(ShareProfileLinkModel data) =>
    json.encode(data.toMap());

class ShareProfileLinkModel {
  List<ShareProfileDataList> dataList;

  ShareProfileLinkModel({
    required this.dataList,
  });

  factory ShareProfileLinkModel.fromMap(Map<String, dynamic> json) =>
      ShareProfileLinkModel(
        dataList: List<ShareProfileDataList>.from(
          json['dataList'].map((x) => ShareProfileDataList.fromMap(x)),
        ),
      );

  Map<String, dynamic> toMap() => {
        'dataList': List<dynamic>.from(dataList.map((x) => x.toMap())),
      };
}

class ShareProfileDataList {
  String? id;
  String? name;
  String? icon;
  bool? isIntentURLAvailable;
  String? androidUrl;
  String? iosUrl;
  String? intentUrl;

  ShareProfileDataList({
    this.id,
    this.name,
    this.icon,
    this.isIntentURLAvailable,
    this.androidUrl,
    this.iosUrl,
    this.intentUrl,
  });

  factory ShareProfileDataList.fromMap(Map<String, dynamic> json) =>
      ShareProfileDataList(
        id: json['id'],
        name: json['name'],
        icon: json['icon'],
        isIntentURLAvailable: json['isIntentURLAvailable'],
        androidUrl: json['androidURL'],
        iosUrl: json['iosURL'],
        intentUrl: json['intentURL'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'icon': icon,
        'isIntentURLAvailable': isIntentURLAvailable,
        'androidURL': androidUrl,
        'iosURL': iosUrl,
        'intentURL': intentUrl,
      };
}
