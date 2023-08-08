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
