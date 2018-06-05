import UIKit
import CoreLocation
import SwiftyJSON

struct Location: BaseData {
  var lat = 0.0
  var lng = 0.0
  var address = ""
  
  static func parse(json: JSON) -> Location {
    var obj = Location()
    obj.lat = json["lat"].doubleValue
    obj.lng = json["lng"].doubleValue
    obj.address = json["address"].stringValue
    return obj
  }
  
  var coordinate: CLLocationCoordinate2D {
    return CLLocationCoordinate2D(latitude: lat, longitude: lng)
  }
}

struct Delivery: BaseData {
  var descriptions = ""
  var imageUrl = ""
  var location: Location!
  
  static func parse(json: JSON) -> Delivery {
    var obj = Delivery()
    obj.descriptions = json["description"].stringValue
    obj.imageUrl = json["imageUrl"].stringValue
    obj.location = Location.parse(json: json["location"])
    return obj
  }
  
  static func parse(deliveryManagedObject: DeliveryManagedObject) -> Delivery {
    var obj = Delivery()
    obj.descriptions = deliveryManagedObject.descriptions!
    obj.imageUrl = deliveryManagedObject.imageUrl!
    obj.location = Location(lat: deliveryManagedObject.lat, lng: deliveryManagedObject.lng, address: deliveryManagedObject.address!)
    return obj
  }
  
  static func parse(deliveryManagedObjects: [DeliveryManagedObject]) -> [Delivery] {
    var array = [Delivery]()
    deliveryManagedObjects.forEach {
      array.append(Delivery.parse(deliveryManagedObject: $0))
    }
    return array
  }
}
