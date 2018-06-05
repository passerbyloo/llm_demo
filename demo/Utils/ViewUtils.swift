import UIKit

extension UIView {
  @IBInspectable var cornerRadius: CGFloat {
    get {
      return layer.cornerRadius
    }
    set {
      layer.cornerRadius = newValue
      layer.masksToBounds = newValue > 0
    }
  }
  
  @IBInspectable var borderWidth: CGFloat {
    get {
      return layer.borderWidth
    }
    set {
      layer.borderWidth = newValue
    }
  }
  
  @IBInspectable var borderColor: UIColor? {
    set {
      layer.borderColor = newValue?.cgColor
    }
    get {
      if let color = layer.borderColor {
        return UIColor(cgColor: color)
      }
      else {
        return nil
      }
    }
  }
  
  var starting : (CGPoint) {
    return CGPoint(x: self.frame.origin.x , y: self.frame.origin.y)
  }
  var ending : (CGPoint) {
    return CGPoint(x: self.frame.origin.x + self.frame.width , y: self.frame.origin.y + self.frame.height)
  }
  var width : (CGFloat) {
    return self.frame.width
  }
  var height : (CGFloat) {
    return self.frame.height
  }
  
  func centerX(_ parent : UIView){
    self.frame.origin = CGPoint(x: parent.width / 2 - self.width / 2, y: self.frame.origin.y)
  }
  
  func centerY(_ parent : UIView){
    self.frame.origin = CGPoint(x: self.frame.origin.x, y: parent.height / 2 - self.height / 2)
  }
}

extension UITableView {
  func registerNibCell(name: String) {
    register(UINib(nibName: name, bundle: nil), forCellReuseIdentifier: name)
  }
  
  func registerNibCell(aClass: AnyClass) {
    let name = String(describing: aClass)
    register(UINib(nibName: name, bundle: nil), forCellReuseIdentifier: name)
  }
  
  func registerClassCell(aClass: AnyClass){
    let name : String = "\(aClass)"
    register(aClass, forCellReuseIdentifier: name)
  }
}

enum Pad {
  static let cornerRadius: CGFloat = 2
  static let thin: CGFloat  = 4
  static let small: CGFloat = 8
  static let medium: CGFloat = 16
  static let big: CGFloat = 24
}
