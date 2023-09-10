// https://www.donnywals.com/implementing-a-one-way-sync-strategy-with-core-data-urlsession-and-combine/

import Combine
import Foundation

// sample server response
/*
 {
   "events": [
     {
       "id": 1,
       "title": "My Event",
       "location": {
         "id": 2,
         "name": "Donny's House"
       }
     }
   ],
   "locations": [
     {
       "id": 3,
       "name": "Melkweg, Amsterdam"
     }
   ],
   "deleted": {
     "events": [2, 8],
     "locations": [4, 7]
   },
   "version_token": "1234567890"
 }
 */

// Configuring your Core Data store
// When you implement a sync strategy that writes remote data to a local Core Data store it's crucial that you prevent data duplication. While Core Data should typically not be treated as a store that has a concept of primary keys, we can apply a unique constraint on one or more properties of a Core Data model.


class DataImporter {
    var versionToken: String? {
        get { UserDefaults.standard.string(forKey: "DataImporter.versionToken") }
        set { UserDefaults.standard.set(newValue, forKey: "DataImporter.versionToken") }
      }
    
  let importContext: NSManagedObjectContext

  init(persistentContainer: NSPersistentContainer) {
    importContext = persistentContainer.newBackgroundContext()
    importContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
      // we tell Core Data to resolve any conflicts between the store and the data we're attempting to save using the properties from the object we want to save. This means that if we have a stored Event, and want to save an event with the same id as the Event that's already stored, Core Data will overwrite the stored event's values with the new event's values.
  }
}

//You can create an instance of this DataImporter wherever you need it in your application. Typically this will be somewhere in a ViewModel or other place that you would normally use to make network requests, fetch data, or perform other potentially slow and costly operations.

/*
 Since we'll be importing data on a background context and the persistent container's viewContext should pick up any changes we make automatically, we'll need to set the viewContext's automaticallyMergesChangesFromParent property to true. If you're using one of Apple's premade templates you can insert container.viewContext.automaticallyMergesChangesFromParent = true at the point where the container is created.

 If you're using a custom abstraction you can do the same except you'll be adding this line in code you wrote yourself.

 Setting automaticallyMergesChangesFromParent = true will make sure that the viewContext is aware of any changes that were made to the persistent container. When you save a background context, the persistent container is automatically informed of the changes that were made. The viewContext is considered to be a child of the persistent container so when you set automaticallyMergesChangesFromParent to true, the viewContext will automatically be made aware of changes in the persistent container.

 This is particularly useful if your UI uses an NSFetchedResultsController. When your viewContext does not automatically merge changes from its parent, your NSFetchedResultsController won't automatically update when your background context saves after running your import.
 */


struct ImporterResponse: Decodable {
  let events: [Event]
  let locations: [Location]
  let deleted: ImporterResponse.Deleted
  let versionToken: String
}

extension ImporterResponse {
  struct Deleted: Decodable {
    let events: [Int]
    let locations: [Int]
  }
}


func runImport() {
  // 1. Build the correct URL
  var url = URL(string: "https://www.mywebsite.com/datasource")!
  if let versionToken = self.versionToken {
    url.appendPathComponent(versionToken)
  }

  URLSession.shared.dataTaskPublisher(for: url)
    .map(\.data)
    .sink(receiveCompletion: { completion in
      if case .failure(let error) = completion {
        print("something went wrong: \(error)")
      }
    }, receiveValue: { [weak self] data in
      guard let self = self
        else { return }

      self.importContext.perform {
          do {
              // 2. Decode the response
              let response = try self.decoder.decode(ImporterResponse.self, from: data)
              
              // 3. Store the version token
              self.versionToken = response.versionToken
              
              // 4. Build batch delete requests
              let deletedEventsPredicate = NSPredicate(format: "id IN %@", response.deleted.events)
              let deletedEventsRequest: NSFetchRequest<Event> = Event.fetchRequest()
              deletedEventsRequest.predicate = deletedEventsPredicate
              let batchDeleteEvents = NSBatchDeleteRequest(fetchRequest: deletedEventsRequest)
              
              let deletedLocationsPredicate = NSPredicate(format: "id IN %@", response.deleted.locations)
              let deletedLocationsRequest: NSFetchRequest<Location> = Location.fetchRequest()
              deletedLocationsRequest.predicate = deletedLocationsPredicate
              let batchDeleteLocations = NSBatchDeleteRequest(fetchRequest: deletedLocationsRequest)
              
              do {
                          // 5. Execute deletions
                          try self.importContext.execute(batchDeleteEvents)
                          try self.importContext.execute(batchDeleteLocations)

                          // 6. Finish import by calling save() on the import context
                          try self.importContext.save()
                        } catch {
                          print("Something went wrong: \(error)")
                        }
                      } catch {
                        print("Failed to decode json: \(error)")
                      }
                    }

                  }).store(in: &cancellables) // store the returned cancellable in a property on `DataImporter`
              }

lazy var decoder: JSONDecoder = {
  let decoder = JSONDecoder()
  decoder.keyDecodingStrategy = .convertFromSnakeCase
  decoder.userInfo[.managedObjectContext] = importContext
  return decoder
}()

