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


// error

extension KeychainManager {
   enum KeychainError: Error {
      case invalidData
      case itemNotFound
      case duplicateItem
      case incorrectAttributeForClass
      case unexpected(OSStatus)

      var localizedDescription: String {
         switch self {
         case .invalidData:
            return "Invalid data"
         case .itemNotFound:
            return "Item not found"
         case .duplicateItem:
            return "Duplicate Item"
         case .incorrectAttributeForClass:
            return "Incorrect Attribute for Class"
         case .unexpected(let oSStatus):
            return "Unexpected error - \(oSStatus)"
         }
      }
   }
}

// We’ll get a result of OSStatus type from all four operations. As we want to return our own errors, let’s create a helper function that convert that result type to our custom error.

extension KeychainManager {
   
   private func convertError(_ error: OSStatus) -> KeychainError {
      switch error {
      case errSecItemNotFound:
         return .itemNotFound
      case errSecDataTooLarge:
         return .invalidData
      case errSecDuplicateItem:
         return .duplicateItem
      default:
         return .unexpected(error)
      }
   }
}
