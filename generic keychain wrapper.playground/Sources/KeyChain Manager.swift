import Foundation

final class KeychainManager {
  
   typealias ItemAttributes = [CFString : Any]
  
   static let shared = KeychainManager()
  
   private init() {}
}


