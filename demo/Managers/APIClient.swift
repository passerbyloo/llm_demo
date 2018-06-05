import Foundation
import SwiftyJSON
import Alamofire
import CoreLocation

class APIClient {
  static let shared = APIClient()
  var baseURL: String { return "\(AppDelegate.Config.host)/" }
  
  func call<T: APICommand>(api: T, completion: @escaping ((T) -> Void)) {
    let fullPath = api.path.hasPrefix("http") ? api.path : baseURL + api.path
    let completionHandler: (NetworkResult) -> Void = {
      networkResult in
      api.handleResult(networkResult: networkResult)
      completion(api)
    }
//    var parameters = api.parameters
    switch api.method {
    case .get:
      let _ = NetworkManager.shared.get(fullPath, parameters: api.parameters, completionHandler: completionHandler)
    }
  }
}

enum APIMethod {
  case get
}

protocol APICommand {
  var method: APIMethod { get }
  var path: String { get }
  var parameters: [String: Any] { get set }
  var error: Error? { get set }
  func handleResult(networkResult: NetworkResult)
}

enum API {
  class GetDeliveries: APICommand {
    var method: APIMethod { return .get }
    var path: String { return "deliveries" }
    var parameters: [String: Any] = [String: Any]()
    var results = [Delivery]()
    var error: Error? = nil
    init() {
    }
    func handleResult(networkResult: NetworkResult) {
      if let networkError = networkResult.error { error = networkError; return }
      if let json = networkResult.json, networkResult.isSuccess {
        self.results = Delivery.parseArray(jsonArray: json.arrayValue)
      }
    }
  }
}
