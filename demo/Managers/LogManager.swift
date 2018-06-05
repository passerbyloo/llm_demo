import Foundation

class LogManager {
  static func info(_ message: String) {
    let message = "[demo] \(message)"
    print(message)
  }
}
