// To parse this JSON data, do
//
//     final notificationModel = notificationModelFromMap(jsonString);

import 'dart:convert';

List<NotificationModel> notificationModelFromMap(String str) {
  dynamic data = json.decode(str);
  if (data.isEmpty) {
    return <NotificationModel>[];
  } else {
    return List<NotificationModel>.from(
      json.decode(str).map((x) => NotificationModel.fromJson(x)),
    );
  }
}

String notificationModelToMap(List<NotificationModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class NotificationModel {
  int? id;
  String? patientId;
  PushNotificationData? pushNotificationData;
  String? dateCreated;
  String? dateModified;
  bool? isNotificationRead;
  int? unreadCount;

  NotificationModel({
    this.id,
    this.patientId,
    this.pushNotificationData,
    this.dateCreated,
    this.dateModified,
    this.isNotificationRead,
    this.unreadCount,
  });

  NotificationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    patientId = json['patientId'];
    pushNotificationData = json['pushNotificationData'] != null
        ? PushNotificationData.fromJson(json['pushNotificationData'])
        : null;
    dateCreated = json['dateCreated'];
    dateModified = json['dateModified'];
    isNotificationRead = json['isNotificationRead'];
    unreadCount = json['unreadCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['patientId'] = patientId;
    if (pushNotificationData != null) {
      data['pushNotificationData'] = pushNotificationData!.toJson();
    }
    data['dateCreated'] = dateCreated;
    data['dateModified'] = dateModified;
    data['isNotificationRead'] = isNotificationRead;
    data['unreadCount'] = unreadCount;
    return data;
  }
}

class PushNotificationData {
  String? healthId;
  String? target;
  String? title;
  String? body;
  Params? params;

  PushNotificationData({
    this.healthId,
    this.target,
    this.title,
    this.body,
    this.params,
  });

  PushNotificationData.fromJson(Map<String, dynamic> json) {
    healthId = json['healthId'];
    target = json['target'];
    title = json['title'];
    body = json['body'];
    params = json['params'] != null ? Params.fromMap(json['params']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['healthId'] = healthId;
    data['target'] = target;
    data['title'] = title;
    data['body'] = body;
    if (params != null) {
      data['params'] = params!.toMap();
    }
    return data;
  }
}

class Params {
  Params({
    this.consentRequestId,
    this.subscriptionRequestId,
    this.authorizationRequestId,
    this.providerId,
  });

  String? consentRequestId;
  String? subscriptionRequestId;
  String? authorizationRequestId;
  String? providerId;

  factory Params.fromMap(Map<String, dynamic> json) => Params(
        consentRequestId: json['consentRequestId'],
        subscriptionRequestId: json['subscriptionRequestId'],
        authorizationRequestId: json['authorizationRequestId'],
        providerId: json['providerId'],
      );

  Map<String, dynamic> toMap() => {
        if (consentRequestId != null) 'consentRequestId': consentRequestId,
        if (subscriptionRequestId != null)
          'subscriptionRequestId': subscriptionRequestId,
        if (authorizationRequestId != null)
          'authorizationRequestId': authorizationRequestId,
        if (providerId != null) 'providerId': providerId,
      };
}
