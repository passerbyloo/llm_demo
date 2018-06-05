import UIKit
import GoogleMaps

class MapManager: NSObject, GMSMapViewDelegate {
  var mapView: GMSMapView!
  var tappedMarker = GMSMarker()
  
  init(baseView: GMSMapView!) {
    super.init()
    mapView = baseView
    mapView.isMyLocationEnabled = true
    mapView.settings.myLocationButton = true
  }
  
  func showLocation(coordinate: CLLocationCoordinate2D) {
    mapView.animate(to: GMSCameraPosition.camera(withTarget: coordinate, zoom: 15))
  }
  
  @discardableResult func addMarker(location: CLLocationCoordinate2D, icon: UIImage? = nil, title: String? = nil, zIndex: Int32 = 0) -> GMSMarker {
    let marker = GMSMarker(position: location)
    marker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
    marker.map = mapView
    if let icon = icon { marker.icon = icon }
    marker.title = title
    marker.zIndex = zIndex
    return marker
  }
}
