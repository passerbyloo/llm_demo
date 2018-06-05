import Foundation
import SwiftyJSON

protocol BaseData: CustomStringConvertible {
  associatedtype T
  var description: String { get }
  static func parse(json: JSON) -> T
  static func parseArray(jsonArray: [JSON]) -> [T]
}

extension BaseData {
  var description: String { return "" }
  
  static func parseArray(jsonArray: [JSON]) -> [T] {
    var array = [T]()
    for json in jsonArray {
      let obj = parse(json: json)
      array.append(obj)
    }
    return array
  }
}

