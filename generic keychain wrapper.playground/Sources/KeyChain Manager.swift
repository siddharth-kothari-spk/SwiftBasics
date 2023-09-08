import Foundation

final class KeychainManager {
  
   typealias ItemAttributes = [CFString : Any]
  
   static let shared = KeychainManager()
  
   private init() {}
}

// every item that we want to store in the keychain must be one of the pre-defined classes.
// So, for every method that our manager exposes, we’ll need to have a parameter that indicates the type of class of the item to interact with.
/*
 Each of those classes has a constant key to identify them:

     kSecClassGenericPassword
     kSecClassInternetPassword
     kSecClassCertificate
     kSecClassKey
     kSecClassIdentity
 
 However, as the Keychain API was written in obj-c, those keys are a CFString type. As we're trying to build a Swift wrapper, it would be a good idea to use an enum to store the different class type that the keychain supports.

 We still need to use the CFString type in our functions, because we don't know the actual value of the constant. For this reason, we need to implement the RawRepresentable on our ItemClass enum.
 */


extension KeychainManager {
   enum ItemClass: RawRepresentable {
      typealias RawValue = CFString

      case generic
      case password
      case certificate
      case cryptography
      case identity

      init?(rawValue: CFString) {
         switch rawValue {
         case kSecClassGenericPassword:
            self = .generic
         case kSecClassInternetPassword:
            self = .password
         case kSecClassCertificate:
            self = .certificate
         case kSecClassKey:
            self = .cryptography
         case kSecClassIdentity:
            self = .identity
         default:
            return nil
         }
      }

      var rawValue: CFString {
         switch self {
         case .generic:
            return kSecClassGenericPassword
         case .password:
            return kSecClassInternetPassword
         case .certificate:
            return kSecClassCertificate
         case .cryptography:
            return kSecClassKey
         case .identity:
            return kSecClassIdentity
         }
      }
   }
}
