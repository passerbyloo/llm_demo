import Foundation
import CoreData


extension DeliveryManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DeliveryManagedObject> {
        return NSFetchRequest<DeliveryManagedObject>(entityName: "DeliveryManagedObject")
    }

    @NSManaged public var descriptions: String?
    @NSManaged public var imageUrl: String?
    @NSManaged public var lat: Double
    @NSManaged public var lng: Double
    @NSManaged public var address: String?

}
