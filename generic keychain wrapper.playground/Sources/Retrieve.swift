import Foundation

extension KeychainManager {
   public func retrieveItem<T: Decodable>(
       ofClass itemClass: ItemClass,
       key: String, attributes:
       ItemAttributes? = nil) throws -> T {

       // 1
       var query: [String: Any] = [
          kSecClass as String: itemClass.rawValue,
          kSecAttrAccount as String: key as AnyObject,
          kSecReturnAttributes as String: true,
          kSecReturnData as String: true
       ]

       // 2
       if let itemAttributes = attributes {
          for(key, value) in itemAttributes {
              query[key as String] = value as AnyObject
          }
       }

       // 3
       var item: CFTypeRef?

       // 4
       let result = SecItemCopyMatching(query as CFDictionary, &item)

       // 5
       if result != errSecSuccess {
          throw convertError(result)
       }

       // 6
       guard
          let keychainItem = item as? [String : Any],
          let data = keychainItem[kSecValueData as String] as? Data
       else {
          throw KeychainError.invalidData
       }

       // 7
       return try JSONDecoder().decode(T.self, from: data)
    }
}

/*
 As in the save, we take advantage of the generic feature to reuse the function for every type. In this case, as we are retrieving data from the keychain that we’ll decode, the generic type must be a Decodable type.

     We create the query just like in the save operation, but we add a new entry to tell the keychain that the data stored must be returned.
     We add the attributes if we receive some.
     Create a reference to holding the keychain result.
     Perform the operation.
     Check the result just like in the save operation.
     We make sure that data is present in the keychain result.
     We try to decode the data retrieved and send it back.
 */
