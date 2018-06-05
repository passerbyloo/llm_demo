import UIKit
import CoreData

class DatabaseManager: NSObject {
  
  static func getDeliveries() -> [DeliveryManagedObject] {
    let context = AppDelegateInstance.persistentContainer.viewContext
  
    let fetchRequest: NSFetchRequest<DeliveryManagedObject> = DeliveryManagedObject.fetchRequest()
    fetchRequest.fetchLimit = 100
    fetchRequest.fetchOffset = 0
    
    let entity = NSEntityDescription.entity(forEntityName: "DeliveryManagedObject", in: context)
    fetchRequest.entity = entity
    
    do {
      let fetchedObjects:[AnyObject]? = try context.fetch(fetchRequest)
      return fetchedObjects as! [DeliveryManagedObject]
    }
    catch {
      fatalError("不能保存：\(error)")
    }
  }
  
  static func add(deliveries: [Delivery]) {
    let context = AppDelegateInstance.persistentContainer.viewContext
    for delivery in deliveries {
      let deliveryManagedObject = NSEntityDescription.insertNewObject(forEntityName: "DeliveryManagedObject", into: context) as! DeliveryManagedObject
      deliveryManagedObject.descriptions = delivery.descriptions
      deliveryManagedObject.imageUrl = delivery.imageUrl
      deliveryManagedObject.address = delivery.location.address
      deliveryManagedObject.lat = delivery.location.lat
      deliveryManagedObject.lng = delivery.location.lng
    }
    AppDelegateInstance.saveContext()
  }
  
  static func deleteAllApps() {
    let context = AppDelegateInstance.persistentContainer.viewContext
    
    let fetchRequest: NSFetchRequest<DeliveryManagedObject> = DeliveryManagedObject.fetchRequest()
    fetchRequest.fetchLimit = 100
    fetchRequest.fetchOffset = 0
    
    let entity = NSEntityDescription.entity(forEntityName: "DeliveryManagedObject", in: context)
    fetchRequest.entity = entity
    
    do {
      let fetchedObjects:[AnyObject]? = try context.fetch(fetchRequest)
      for fetchedObject in fetchedObjects as! [DeliveryManagedObject] {
        context.delete(fetchedObject)
      }
    }
    catch {
      fatalError("不能保存：\(error)")
    }
    AppDelegateInstance.saveContext()
  }
}
