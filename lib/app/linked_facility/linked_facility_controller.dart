import 'package:abha/export_packages.dart';

class LinkedFacilityController extends BaseController {
  late FacilityRepo facilityRepo;

  /// constructor of LinkedFacilityController having
  /// param [repo]  LinkedFacilityRepoImpl
  LinkedFacilityController(LinkedFacilityRepoImpl repo)
      : super(LinkedFacilityController) {
    facilityRepo = repo;
  }

  /// @Here is the method getLinkFacilityFetch() used to fetch the response data
  /// into the Map and jsonEncode the Map data into the String
  Future<void> getLinkFacilityFetch() async {
    Map facilityRespData = await facilityRepo.callFacilityLink();
    String facilityData = jsonEncode(facilityRespData);
    LinkedFacilityModel linkedFacility = linkFacilityModelFromMap(facilityData);
    List<LinkFacilityLinkedData> tempListOfLinkFacilityLinkedData = [];
    linkedFacility.patient?.links?.forEach((element) {
      if (tempListOfLinkFacilityLinkedData.contains(element)) {
        int index = tempListOfLinkFacilityLinkedData.indexOf(element);
        tempListOfLinkFacilityLinkedData
            .elementAt(index)
            .careContexts
            ?.addAll(element.careContexts?.toList() ?? []);
      } else {
        tempListOfLinkFacilityLinkedData.add(element);
      }
    });
    linkedFacility.patient?.links = tempListOfLinkFacilityLinkedData;
    tempResponseData = linkedFacility;
  }

  double? getCareContextLength(int ccLength) {
    // return  (ccLength < 5)
    //     ? ccLength * 0.6
    //     :  null;

    return (ccLength == 1)
        ? 0.2
        : (ccLength < 10)
            ? ccLength * 0.11
            : null;
  }
}
