import Foundation
import Alamofire
import SwiftyJSON

@objc class NetworkResult : NSObject {
  var isSuccess = false
  var error: Error?
  var json : JSON?
  var extra : Dictionary<String, Any>?
  var sourceUrl : String?
  
  override var description: String{
    return "Url: \(String(describing: sourceUrl)) Error: \(String(describing: error)) Success: \(isSuccess)"
  }
}

class NetworkManager{
  static let shared = NetworkManager()
  let TXT_ERR_Load_Data = "无法加载数据。请确保网络正常运作。"
  var headers = HTTPHeaders()
  
  func processResponse(_ response: DataResponse<Any>, request: DataRequest) -> NetworkResult {
    let result = NetworkResult()
    if let _ = response.result.error {
      var statusCode = 990
      if let httpStatusCode = response.response?.statusCode { statusCode = httpStatusCode }
      result.isSuccess = false
      result.error = NSError(domain: TXT_ERR_Load_Data, code: statusCode, userInfo: nil)
    }
    if let urlResponse = response.response, result.error == nil {
      let statusCode = urlResponse.statusCode
      result.sourceUrl = urlResponse.url?.absoluteString
      result.isSuccess = statusCode >= 200 && statusCode < 300
      if let json = response.result.value {
        result.json = JSON(json)
        if let status = result.json?["status"].string, status != "1" {
          var message = TXT_ERR_Load_Data
          if let serverMessage = result.json?["status_message"].string {
            message = serverMessage
          }
          result.isSuccess = false
          result.error = NSError(domain: message, code: Int(status)!, userInfo: nil)
        }
      } else {
        result.isSuccess = false
        result.error = NSError(domain: TXT_ERR_Load_Data, code: statusCode, userInfo: nil)
      }
      if(response.response?.statusCode == NSURLErrorCancelled ) {
        result.isSuccess = false
        result.error = NSError(domain: TXT_ERR_Load_Data, code: 991, userInfo: nil)
      }
    }
    LogManager.info("[NetworkManager] >====== \(result)")
    LogManager.info(request.debugDescription)
    LogManager.info("\(String(describing: result.json))")
    LogManager.info("[NetworkManager] <======")
    return result
  }
  
  @discardableResult func get(_ URLString: URLConvertible, parameters: [String: Any]? = nil, completionHandler: @escaping (NetworkResult) -> Void) -> Request {
    let request = Alamofire.request(URLString, method: .get, parameters: parameters, headers: headers)
    request.responseJSON { response in
      let result = self.processResponse(response, request: request)
      completionHandler(result)
    }
    return request
  }
}
