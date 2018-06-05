import UIKit
import CoreLocation

class LocationManager: NSObject {
  
  static var shared = LocationManager()
  let locationManager = CLLocationManager()
  override init () {
    super.init()
    locationManager.distanceFilter = 10
    locationManager.activityType = .other
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    locationManager.allowsBackgroundLocationUpdates = false
    locationManager.delegate = self
  }
    
  func requestAuthorization() {
    locationManager.requestWhenInUseAuthorization()
  }
}

extension LocationManager: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print("[LocationManager] didFailWithError \(error)")
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let location = locations.last else { return }
    print("[LocationManager] didUpdateLocations \(location) \(location.horizontalAccuracy)")
  }
}
