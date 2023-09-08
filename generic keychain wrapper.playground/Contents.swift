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
