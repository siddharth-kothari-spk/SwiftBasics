import UIKit

///courtsey: https://www.avanderlee.com/concurrency/task-groups-in-swift/

//You can see a Task Group as a container of several child tasks that are dynamically added. Child tasks can run in parallel or in serial, but the Task Group will only be marked as finished once its child tasks are done.

enum ImageFetchingError: Error {
    case imageDecodingFailed
}

func downloadPhoto(urlString: String) async throws -> UIImage {
    let url = URL(string: urlString)!
    let (data, _) = try await URLSession.shared.data(from: url)
    guard let image = UIImage(data: data) else {
        throw ImageFetchingError.imageDecodingFailed
    }
    return image
}

let imagesToDownload = try await withThrowingTaskGroup(of: UIImage.self, returning: [UIImage].self) { taskGroup in
    let photoURLs : [String] = ["https://picsum.photos/200/300", "https://picsum.photos/300/300", "https://picsum.photos/200/200"]
    for photoUrl in photoURLs {
        taskGroup.addTask {
            do {
               return try await downloadPhoto(urlString: photoUrl)
            }
            catch {
                print("error : \(error)")
                return UIImage()
            }
        }
        
        return try await taskGroup.reduce(into: [UIImage]()) { partialResult, name in
                partialResult.append(name)
        }
    }
    return [UIImage()]
}



// failing a group when child task throws
let images = try await withThrowingTaskGroup(of: UIImage.self, returning: [UIImage].self) { taskGroup in
    let photoURLs = ["https://picsum.photos/200/300", "https://picsum.photos/300/300", "https://picsum.photos/200/200"]
    for photoURL in photoURLs {
        taskGroup.addTask {
            do {
               return try await downloadPhoto(urlString: photoURL)
            }
            catch {
                print("error : \(error)")
                return UIImage()
            }
        }
    }

    var images = [UIImage]()

    /// Note the use of `next()`:
    /// If the next child task throws an error
    /// and you propagate that error from this method
    /// out of the body of a call to the
    /// `ThrowingTaskGroup.withThrowingTaskGroup(of:returning:body:)` method,
    /// then all remaining child tasks in that group are implicitly canceled.
    ///
    while let downloadImage = try await taskGroup.next() {
        images.append(downloadImage)
    }
    return images
}


//Cancellations in groups
//You can cancel a group of tasks by canceling the task it’s running in or by calling the cancelAll() method on the group itself.
