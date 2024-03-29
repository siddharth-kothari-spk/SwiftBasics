// https://www.donnywals.com/observing-changes-to-managed-objects-across-contexts-with-combine/

import Combine

// A common pattern in Core Data is to fetch objects and show them in your UI using one managed object context, and then use another context to update, insert or delete managed objects. There are several ways for you to update your UI in response to these changes, for example by using an NSFetchedResultsController

// We will see a useful technique that allows you to observe specific managed objects across different contexts so you can easily update your UI when, for example, that managed object was changed on a background queue.

// Building a simple managed object observer
// The simplest way to observe changes in a Core Data store is by listening for one of the various notifications that are posted when changes occur within Core Data.

// NSManagedObjectContext.didSaveObjectsNotification - when a managed object context saved objects,
// NSManagedObjectContext.didMergeChangesObjectIDsNotification - notified when a specific context merged changes for specific objectIDs into its own context.
// Typically you will merge changes that occurred on a background context into your view context automatically by setting the automaticallyMergesChangesFromParent property on your persistent container's viewContext to true. This means that whenever a background context saves managed objects, those changes are merged into the viewContext automatically, providing easy access to updated properties and objects.


class CoreDataStorage {
  // configure and create persistent container
  // viewContext.automaticallyMergesChangesFromParent is set to true

  func publisher<T: NSManagedObject>(for managedObject: T,
                                     in context: NSManagedObjectContext) -> AnyPublisher<T, Never> {

    // implementation goes here
  }
}

// The API is pretty simple and elegant. We can pass the managed object that should be observed to this method, and we can tell it which context should be observed. Note that the context that's expected here is the context that we want to observe, not the context that will make the change. In other words, this will usually be your viewContext since that's the context that will merge in changes from background contexts and trigger a UI update.

// If you pass the managed object context that makes the changes, you will not receive updates with the implementation I'm about to show you. The reason for that is that the context that makes the changes doesn't merge in its own changes because it already contains them.


// If you want to receive updates even if the context that makes changes is also the context that's observed you can use the NSManagedObjectContext.didSaveObjectIDsNotification instead since that will fire for the context that saved (which is the context that made changes) rather than the context that merged in changes.

class CoreDataStorage1 {
    func publisher<T: NSManagedObject>(for managedObject: T,
                                       in context: NSManagedObjectContext) -> AnyPublisher<T, Never> {

      let notification = NSManagedObjectContext.didMergeChangesObjectIDsNotification
      return NotificationCenter.default.publisher(for: notification, object: context)
        .compactMap({ notification in
          if let updated = notification.userInfo?[NSUpdatedObjectIDsKey] as? Set<NSManagedObjectID>,
             updated.contains(managedObject.objectID),
             let updatedObject = context.object(with: managedObject.objectID) as? T {

            return updatedObject
          } else {
            return nil
          }
        })
        .eraseToAnyPublisher()
    }
}

// The code above creates a notification publisher for NSManagedObjectContext.didMergeChangesObjectIDsNotification and passes the context argument as the object that should be associated with the notification. This ensures that we only receive and handle notifications that originated in the target context.

//Next, I apply a compactMap to this publisher to grab the notification and check whether it has a list of updated managed object IDs. If it does, I check whether the observed managed object's objectID is in the set, and if it is I pull the managed object into the target context using object(with:). This will retrieve the managed object from the persistent store and associate it with the target context.

// If the notification doesn't contain updates, or if the notification doesn't contain the appropropriate objectID I return nil. This will ensure that the the publisher doesn't emit anything if we don't have anything to emit since compactMap will prevent any nil values from being delivered to our subscribers.

//Because I want to keep my return type clean I erase the created publisher to AnyPublisher.


class ViewModel: ObservableObject {

  var album: Album // a managed object subclass
  private var cancellables = Set<AnyCancellable>()

  init(album: Album, storage: CoreDataStorage1) {
    self.album = album

    guard let ctx = album.managedObjectContext else {
      return
    }

    storage.publisher(for: album, in: ctx)
      .sink(receiveValue: { [weak self] updatedObject in
        self?.album = updatedObject
        self?.objectWillChange.send()
      })
      .store(in: &cancellables)
  }
}


// to listen for one or more kinds of changes that a managed object might go through

enum ChangeType {
  case inserted, deleted, updated

  var userInfoKey: String {
    switch self {
    case .inserted: return NSInsertedObjectIDsKey
    case .deleted: return NSDeletedObjectIDsKey
    case .updated: return NSUpdatedObjectIDsKey
    }
  }
}

class CoreDataStorage2 {
    func publisher<T: NSManagedObject>(for managedObject: T,
                                       in context: NSManagedObjectContext,
                                       changeTypes: [ChangeType]) -> AnyPublisher<(object: T?, type: ChangeType), Never> {

      let notification = NSManagedObjectContext.didMergeChangesObjectIDsNotification
      return NotificationCenter.default.publisher(for: notification, object: context)
        .compactMap({ notification in
          for type in changeTypes {
            if let object = self.managedObject(with: managedObject.objectID, changeType: type,
                                                             from: notification, in: context) as? T {
              return (object, type)
            }
          }

          return nil
        })
        .eraseToAnyPublisher()
    }
    
    private func managedObject(with id: NSManagedObjectID, changeType: ChangeType,
                               from notification: Notification, in context: NSManagedObjectContext) -> NSManagedObject? {
              guard let objects = notification.userInfo?[changeType.userInfoKey] as? Set<NSManagedObjectID>,
                    objects.contains(id) else {
                return nil
              }

              return context.object(with: id)
            }
}


class ViewModel2: ObservableObject {

  var album: Album? // a managed object subclass
  private var cancellables = Set<AnyCancellable>()

  init(album: Album, storage: CoreDataStorage2) {
    self.album = album

    guard let ctx = album.managedObjectContext else {
      return
    }

    storage.publisher(for: album, in: ctx, changeTypes: [.updated, .deleted])
      .sink(receiveValue: { [weak self] change in
        if change.type != .deleted {
          self?.album = change.object
        } else {
          self?.album = nil
        }
        self?.objectWillChange.send()
      })
      .store(in: &cancellables)
  }
}

// add one more interesting publisher so we can listen for insertion, updating and deleting of any object that matches a specific managed object subclass

extension CoreDataStorage2 {
    func publisher2<T: NSManagedObject>(for type: T.Type,
                                       in context: NSManagedObjectContext,
                                       changeTypes: [ChangeType]) -> AnyPublisher<[([T], ChangeType)], Never> {
        let notification = NSManagedObjectContext.didMergeChangesObjectIDsNotification
        return NotificationCenter.default.publisher(for: notification, object: context)
            .compactMap({ notification in
                return changeTypes.compactMap({ type -> ([T], ChangeType)? in
                    guard let changes = notification.userInfo?[type.userInfoKey] as? Set<NSManagedObjectID> else {
                        return nil
                    }
                    
                    let objects = changes
                        .filter({ objectID in objectID.entity == T.entity() })
                        .compactMap({ objectID in context.object(with: objectID) as? T })
                    return (objects, type)
                })
            })
            .eraseToAnyPublisher()
    }
}
// This method takes a T.Type rather than a managed object instance as its first argument. By accepting T.Type callers can pass the type of object they want to observe. For example by passing Album.self as the type. The AnyPublisher that we create will return an array of ([T], ChangeType) since we can have multiple changes in a single notification and each change can have multiple managed objects.


class ViewMode3: ObservableObject {

  var album: Album? // a managed object subclass
  private var cancellables = Set<AnyCancellable>()

  init(album: Album, storage: CoreDataStorage2) {
    self.album = album

    guard let ctx = album.managedObjectContext else {
      return
    }

      storage.publisher(for: Album.self, in: storage.viewContext, changeTypes: [.inserted, .updated, .deleted])
        .sink(receiveValue: { [weak self] changes in
          self?.storage.viewContext.perform
            // iterate over changes
            // make sure to do so on the correct queue if applicable with .perform
          }
        })
        .store(in: &cancellables)
  }
}
