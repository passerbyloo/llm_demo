import Foundation
import SwiftyJSON
import Alamofire

class DataRepository {
  static var shared = DataRepository()
  
  func getDeliveries(completion: @escaping ((_ results: [Delivery], _ error: Error?) -> Void)) {
    APIClient.shared.call(api: API.GetDeliveries()) { api in
      DispatchQueue.main.async { completion(api.results, api.error) }
    }
  }
}
