import Foundation

extension KeychainManager {
   public func saveItem<T: Encodable>(
       _ item: T,
       itemClass: ItemClass,
       key: String,
       attributes: ItemAttributes? = nil) throws {

       // 1
       let itemData = try JSONEncoder().encode(item)

       // 2
       var query: [String: AnyObject] = [
          kSecClass as String: itemClass.rawValue,
          kSecAttrAccount as String: key as AnyObject,
          kSecValueData as String: itemData as AnyObject
       ]

       // 3
       if let itemAttributes = attributes {
          for(key, value) in itemAttributes {
              query[key as String] = value as AnyObject
          }
       }

       // 4
       let result = SecItemAdd(query as CFDictionary, nil)

       // 5
       if result != errSecSuccess {
          throw convertError(result)
       }
    }
}

/*
 We encode the item to store. For that reason, the item to store must conform the Encodable protocol. Combining the usage of generics, we write only one function that can be used to store any item as long as the Encodable protocol is implemented.
 We create a dictionary with all the item’s information to store it. kSecClass, the item class. kSecAttrAccount, to identify the item together with the item class. kSecValueData, the actual data to store into the keychain.
 If we’re receiving some extra attributes, we add them to the query.
 We perform the keychain operation.
 We check the result. If it’s something different from success we convert the error to our own API errors and throw it back.
 */
