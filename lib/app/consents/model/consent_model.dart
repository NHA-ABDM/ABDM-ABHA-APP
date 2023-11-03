import 'package:abha/app/consents/model/export_modules.dart';

class ConsentGenericModel<T> {
  int limit;
  int size;
  int offset;
  List<T> requests;

  ConsentGenericModel({
    required this.limit,
    required this.size,
    required this.offset,
    required this.requests,
  });
}

class ConsentModel {
  ConsentGenericModel<ConsentRequestModel>? consents;
  ConsentGenericModel<ConsentSubscriptionRequestModel>? subscriptions;

  ConsentModel({
    this.consents,
    this.subscriptions,
  });

  Map<String, dynamic> toJsonConsent() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['limit'] = consents?.limit;
    data['size'] = consents?.size;
    data['offset'] = consents?.offset;
    data['requests'] = consents?.requests.map((v) => v.toJson()).toList();
    return data;
  }

  Map<String, dynamic> toJsonSubscriptionRequest() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['limit'] = subscriptions?.limit;
    data['size'] = subscriptions?.size;
    data['offset'] = subscriptions?.offset;
    data['requests'] = subscriptions?.requests.map((v) => v.toJson()).toList();
    return data;
  }

  ConsentGenericModel<ConsentRequestModel> convertConsents(
    Map<String, dynamic> json,
  ) {
    var requests = <ConsentRequestModel>[];
    if (json['requests'] != null) {
      json['requests'].forEach((v) {
        requests.add(ConsentRequestModel.fromJson(v));
      });
    }
    requests.sort((b, a) => a.lastUpdated.compareTo(b.lastUpdated));
    return ConsentGenericModel<ConsentRequestModel>(
      limit: json['limit'],
      size: json['size'],
      offset: json['offset'],
      requests: requests,
    );
  }

  ConsentGenericModel<ConsentSubscriptionRequestModel>
      convertSubscriptionRequest(
    Map<String, dynamic> json,
  ) {
    var requests = <ConsentSubscriptionRequestModel>[];
    if (json['requests'] != null) {
      json['requests'].forEach((v) {
        requests.add(ConsentSubscriptionRequestModel.fromJson(v));
      });
    }
    requests.sort((b, a) => a.lastUpdated.compareTo(b.lastUpdated));
    return ConsentGenericModel<ConsentSubscriptionRequestModel>(
      limit: json['limit'],
      size: json['size'],
      offset: json['offset'],
      requests: requests,
    );
  }

  List get() {
    var data = [
      Set.of(consents?.requests ??[]).toList(),
      Set.of(subscriptions?.requests ??[]).toList(),

    ].expand((dynamic x) => x).toList();

    data.sort((b, a) => a.lastUpdated!.compareTo(b.lastUpdated));
    return data;
  }
}
