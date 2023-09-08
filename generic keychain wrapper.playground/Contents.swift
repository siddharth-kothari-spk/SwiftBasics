/*
 Understanding the Keychain

 We’ll need to use the following methods from the Keychain API:

     SecItemAdd(_:_:) to add a new item.
     SecItemCopyMatching(_:_:) to retrieve an existing item.
     SecItemUpdate(_:_:) to update an existing item.
     SecItemDelete(_:) to delete an existing item.

 If we take a quick look at the documentation, we’re going to notice that for all four methods, we’ll need to pass a CFDictionary as a parameter. This dictionary is a set of attributes with pre-defined keys that contains information about the type of data that will be stored, and additional information that will help us to make the search for retrieving, updating, and deleting items.

 There is one key that must be present in the dictionary for all four methods: kSecClass, which refers to the type of item that we are operating with.
 
 Apple gives us five types of items to interact with the keychain:

     Generic Password: Indicates a generic password item.
     Internet Password: Indicates an internet password.
     Certificate: Indicates a certificate item.
     Class Key: Indicates a cryptographic item.
     Class Identity: Indicates an identity item.
 */

import Foundation

let apiToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJnb2Fsc2J1ZGR5IiwiZXhwIjo2NDA5MjIxMTIwMH0.JoDuSMARI2Ihh8fisiUxfQiP8AE_WFz9Hcogkk8QMcQ"

do {
   let apiTokenAttributes: KeychainManager.ItemAttributes = [
      kSecAttrLabel: "ApiToken"
   ]

   try KeychainManager.shared.saveItem(
      apiToken,
      itemClass: .generic,
      key: "ApiToken",
      attributes: apiTokenAttributes
   )

   let token: String = try KeychainManager.shared.retrieveItem(
      ofClass: .generic,
      key: "ApiToken",
      attributes: apiTokenAttributes
   )

   try KeychainManager.shared.updateItem(
      with: "new-token-value",
      ofClass: .generic,
      key: "ApiToken",
      attributes: apiTokenAttributes
   )

   try KeychainManager.shared.deleteItem(
      ofClass: .generic,
      key: "ApiToken",
      attributes: apiTokenAttributes
   )

} catch let keychainError as KeychainManager.KeychainError {
   print(keychainError.localizedDescription)
} catch {
   print(error)
}
