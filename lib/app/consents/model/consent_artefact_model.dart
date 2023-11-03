import 'package:abha/app/consents/model/export_modules.dart';
import 'package:abha/export_packages.dart';

class ConsentArtefactModel {
  String? status;
  ConsentDetail? consentDetail;
  String? signature;

  ConsentArtefactModel({this.status, this.consentDetail, this.signature});

  ConsentArtefactModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    consentDetail = json['consentDetail'] != null
        ? ConsentDetail.fromJson(json['consentDetail'])
        : null;
    signature = json['signature'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (consentDetail != null) {
      data['consentDetail'] = consentDetail?.toJson();
    }
    data['signature'] = signature;
    return data;
  }
}

class ConsentDetail {
  String? schemaVersion;
  String? consentId;
  String? createdAt;
  Purpose? purpose;
  Patient? patient;
  Patient? consentManager;
  Hip? hip;
  Hip? hiu;
  Requester? requester;
  List<String>? hiTypes;
  Permission? permission;
  List<CareContexts>? careContexts;
  String? lastUpdated;

  ConsentDetail({
    this.schemaVersion,
    this.consentId,
    this.createdAt,
    this.purpose,
    this.patient,
    this.consentManager,
    this.hip,
    this.hiu,
    this.requester,
    this.hiTypes,
    this.permission,
    this.careContexts,
    this.lastUpdated,
  });

  ConsentDetail.fromJson(Map<String, dynamic> json) {
    schemaVersion = json['schemaVersion'];
    consentId = json['consentId'];
    createdAt = json['createdAt'];
    purpose =
        json['purpose'] != null ? Purpose.fromJson(json['purpose']) : null;
    patient = json['patient'] != null ? Patient.fromMap(json['patient']) : null;
    consentManager = json['consentManager'] != null
        ? Patient.fromMap(json['consentManager'])
        : null;
    hip = json['hip'] != null ? Hip.fromMap(json['hip']) : null;
    hiu = json['hiu'] != null ? Hip.fromMap(json['hiu']) : null;
    requester = json['requester'] != null
        ? Requester.fromJson(json['requester'])
        : null;
    hiTypes = json['hiTypes'].cast<String>();
    permission = json['permission'] != null
        ? Permission.fromJson(json['permission'])
        : null;
    if (json['careContexts'] != null) {
      careContexts = <CareContexts>[];
      json['careContexts'].forEach((v) {
        careContexts!.add(CareContexts.fromJson(v));
      });
    }
    lastUpdated = json['lastUpdated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['schemaVersion'] = schemaVersion;
    data['consentId'] = consentId;
    data['createdAt'] = createdAt;
    if (purpose != null) {
      data['purpose'] = purpose!.toJson();
    }
    if (patient != null) {
      data['patient'] = patient!.toMap();
    }
    if (consentManager != null) {
      data['consentManager'] = consentManager!.toMap();
    }
    if (hip != null) {
      data['hip'] = hip!.toMap();
    }
    if (hiu != null) {
      data['hiu'] = hiu!.toMap();
    }
    if (requester != null) {
      data['requester'] = requester!.toJson();
    }
    data['hiTypes'] = hiTypes;
    if (permission != null) {
      data['permission'] = permission!.toJson();
    }
    if (careContexts != null) {
      data['careContexts'] = careContexts!.map((v) => v.toJson()).toList();
    }
    data['lastUpdated'] = lastUpdated;
    return data;
  }
}
