import Foundation

extension KeychainManager {
   public func deleteItem(
       ofClass itemClass: ItemClass,
       key: String, attributes:
       ItemAttributes? = nil) throws {

           var query: KeyChainDictionary = [
          kSecClass as String: itemClass.rawValue,
          kSecAttrAccount as String: key as AnyObject
       ]

       if let itemAttributes = attributes {
          for(key, value) in itemAttributes {
             query[key as String] = value
          }
       }

       let result = SecItemDelete(query as CFDictionary)
       if result != errSecSuccess {
          throw convertError(result)
       }
    }
}

/*
 The delete operation is the simplest one. Like in every other method, we create our query with the item class and the key. Try to add the extra attributes, and perform the keychain delete operation. Last, we check the result and throw an error in case that the operation wasn’t successful.
 */
