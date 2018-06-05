import UIKit

extension CGRect {
  var center: CGPoint { return CGPoint(x: origin.x + width.half, y: origin.y + height.half) }
}
extension CGFloat {
  var double: CGFloat { return self * 2 }
  var half: CGFloat { return self / 2 }
  
  var asFloat: Float { return Float(self) }
  var asDouble: Double { return Double(self) }
  var asInt: Int { return Int(self) }
}

extension Float {
  var asCGFloat: CGFloat { return CGFloat(self) }
  var asDouble: Double { return Double(self) }
}

extension Double {
  var asCGFloat: CGFloat { return CGFloat(self) }
  var asFloat: Float { return Float(self) }
  var asInt64: Int64 { return Int64(self) }
  var asInt: Int { return Int(self) }
}

extension Int32 {
  var asCGFloat: CGFloat { return CGFloat(self) }
  var asFloat: Float { return Float(self) }
  var asDouble: Double { return Double(self) }
}

extension Int {
  var asCGFloat: CGFloat { return CGFloat(self) }
  var asFloat: Float { return Float(self) }
  var asDouble: Double { return Double(self) }
}

extension CGFloat {
  func heightForRatio(designHeight: CGFloat, designWidth: CGFloat) -> CGFloat {
    return self * designHeight / designWidth
  }
}

