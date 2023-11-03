import 'dart:convert';
import 'package:abha/app/discovery_linking/model/govt_program_model.dart';

List<GovtProgramModel> govtProgramFromMap(String str) =>
    List<GovtProgramModel>.from(
      json.decode(str).map((x) => GovtProgramModel.fromMap(x)),
    );

String govtProgramToMap(List<GovtProgramModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));
