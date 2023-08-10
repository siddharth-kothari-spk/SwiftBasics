import UIKit

//courtsey: https://www.avanderlee.com/swift/asyncthrowingstream-asyncstream/

// Async streams allow you to replace existing code that is based on closures or Combine publishers.
// AsyncThrowingStream as a stream of elements that could potentially result in a thrown error. Values deliver over time, and the stream can be closed by a finish event. A finish event could either be a success or a failure once an error occurs.
// An AsyncStream is similar to the throwing variant but will never result in a throwing error
// An AsyncThrowingStream can be an excellent replacement for existing code based upon closures like progress and completion handlers

struct Downloader {
    enum DownloadStatus {
        case downloading(Double)
        case finished(Data)
    }
    
    func downloadData(_ url: URL, progressHandler: (Double) -> Void, completionHandler: (Result<Data, Error>) -> Void) throws {
        // code to download
    }
}

// now writing overload method using AsyncthrowingStream

extension Downloader {
    func downloadData(_ url: URL) -> AsyncThrowingStream<DownloadStatus, Error> {
        return AsyncThrowingStream { continuation in
            do {
                try self.downloadData(url, progressHandler: { progress in
                    continuation.yield(.downloading(progress))
                }, completionHandler: { result in
                    switch result {
                    case .success(let data):
                        continuation.yield(.finished(data))
                    case .failure(let error):
                        continuation.finish(throwing: error)
                    } 
                })
            } catch {
                continuation.finish(throwing: error)
            }
            
        }
    }
}

// It’s essential to not forget about the finish() callback after you’ve received the final status update. Otherwise, we will keep the stream alive, and code at the implementation level will never continue.


