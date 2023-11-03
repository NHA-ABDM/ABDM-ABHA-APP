// import 'package:geolocator/geolocator.dart';

import 'package:location/location.dart';

/// Determine the current position of the device.
///
/// When the location services are not enabled or permissions
/// are denied the `Future` will return an error.

class GeoLocationHandler {
  static Future<bool> requestLocationPermission() async {
    Location location = Location();
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
    }
    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted == PermissionStatus.granted ||
          permissionGranted == PermissionStatus.grantedLimited) {
        return true;
      } else {
        return false;
      }
    } else {
      return true;
    }
  }

  static Future<LocationData?> getUserLocation() async {
    Location location = Location();
    LocationData? locationData;
    if (await requestLocationPermission()) {
      locationData = await location.getLocation();
    }
    return locationData;
  }
}
