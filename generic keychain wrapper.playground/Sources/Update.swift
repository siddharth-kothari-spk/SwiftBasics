import Foundation

extension KeychainManager {
   public func updateItem<T: Encodable>(
       with item: T,
       ofClass itemClass: ItemClass,
       key: String,
       attributes: ItemAttributes? = nil) throws {

       let itemData = try JSONEncoder().encode(item)

           var query: [String : Any] = [
          kSecClass as String: itemClass.rawValue,
          kSecAttrAccount as String: key as AnyObject
       ]

       if let itemAttributes = attributes {
          for(key, value) in itemAttributes {
             query[key as String] = value
          }
       }

       let attributesToUpdate: [String : Any] = [
          kSecValueData as String: itemData as AnyObject
       ]

       let result = SecItemUpdate(
          query as CFDictionary,
          attributesToUpdate as CFDictionary
       )

       if result != errSecSuccess {
          throw convertError(result)
       }
    }
}

/*
 The update operation is pretty similar to the save operation. We start by encoding the data that is going to replace the one that is currently stored in the keychain. Next, we create the query dictionary to identify the item and add the extra attributes.

 However, in order to update the item, we need to create another dictionary that is going to have the data to replace with.
 */
