// https://www.linkedin.com/feed/update/urn:li:activity:7259232958207660032/

// Actor approach
actor Cache_Actor<Key: Hashable, Value> {
    private var _cache: [Key: Value] = [:]

    func get(_ key: Key) -> Value? {
        _cache[key]
    }

    func set(_ key: Key, value: Value) {
        _cache[key] = value
    }
}

let cacheActor = Cache_Actor<String, String>()

func updateCacheActor() async {
    await cacheActor.set("key", value: "value")
}

// OSAllocatedUnfairLock approach
import os.lock

class Cache_OSAllocatedUnfairLock<Key: Hashable, Value> {
    private var _cache: [Key: Value] = [:]
    private var lock = OSAllocatedUnfairLock()

    func get(_ key: Key) -> Value? {
        lock.lock()
        defer { lock.unlock() }
        return _cache[key]
    }

    func set(_ key: Key, value: Value) {
        lock.lock()
        defer { lock.unlock() }
        _cache[key] = value
    }
}

let cacheOSAllocatedUnfairLock = Cache_OSAllocatedUnfairLock<String, String>()

func updateCacheOSAllocatedUnfairLock() {
    cacheOSAllocatedUnfairLock.set("key", value: "value")
}

/*
 **Comparison of the Two Code Samples**

 **Sample 1 (Actor-Based Approach):**

 * **Synchronization:** Uses actors to ensure thread safety. Actors are lightweight threads that are isolated and can only be accessed through asynchronous messages.
 * **Performance:** Generally slower than the synchronous approach due to the overhead of message passing and scheduling.
 * **Complexity:** More complex to implement and reason about due to the asynchronous nature of actors.
 * **Use Case:** Best suited for scenarios where there are many concurrent accesses to the cache and you want to avoid data races and ensure correctness. This is especially useful for distributed systems and highly concurrent applications.

 **Sample 2 (Synchronous Locking Approach):**

 * **Synchronization:** Uses a `OSAllocatedUnfairLock` to protect shared state. This lock ensures that only one thread can access the cache at a time.
 * **Performance:** Generally faster than the actor-based approach, especially for short-lived critical sections.
 * **Complexity:** Simpler to implement and reason about compared to actors.
 * **Use Case:** Best suited for scenarios where there are occasional concurrent accesses to the cache and performance is a critical factor. This is suitable for most traditional applications.

 **When to Use Which:**

 * **Choose the actor-based approach when:**
     * You have a highly concurrent application with many threads accessing the cache.
     * You need strong isolation between threads.
     * You want to avoid explicit locking and the complexity that comes with it.
 * **Choose the synchronous locking approach when:**
     * You have a less concurrent application.
     * Performance is a critical factor.
     * You need fine-grained control over locking.

 **Additional Considerations:**

 * **Lock Contention:** If there is high contention for the lock in the synchronous approach, it can degrade performance. In such cases, consider using a more efficient locking mechanism or the actor-based approach.
 * **Error Handling:** Both approaches require careful error handling to prevent deadlocks and other issues.
 * **Testing:** Thorough testing is essential to ensure the correctness of both approaches.

 By carefully considering these factors, you can choose the best approach for your specific use case.

 
 **Practical Use Cases**

 **Actor-Based Approach**

 * **Distributed Systems:** In distributed systems, actors can be used to model individual components that communicate asynchronously. This can help improve scalability and fault tolerance.
 * **Real-time Systems:** For real-time systems with strict timing constraints, actors can help ensure that tasks are processed in a timely manner.
 * **Web Servers:** Web servers can use actors to handle incoming requests concurrently, improving performance and scalability.
 * **Game Engines:** Game engines can use actors to represent game objects, such as characters and enemies. This can help manage complex interactions between objects in a concurrent and efficient manner.

 **Synchronous Locking Approach**

 * **Database Access:** When accessing a database, a lock can be used to ensure that only one thread can access the database at a time, preventing data corruption.
 * **File I/O:** When reading or writing to a file, a lock can be used to prevent multiple threads from accessing the file simultaneously.
 * **Shared Resources:** For any shared resource, such as a network connection or a printer, a lock can be used to ensure that only one thread can access it at a time.
 * **Caching:** In caching systems, a lock can be used to protect the cache from concurrent modifications.

 **Choosing the Right Approach**

 Ultimately, the best approach depends on the specific requirements of your application. Here are some factors to consider:

 * **Concurrency Level:** If your application has a high level of concurrency, the actor-based approach may be more suitable.
 * **Performance:** If performance is critical, the synchronous locking approach may be more appropriate, especially for short-lived critical sections.
 * **Complexity:** The actor-based approach can be more complex to implement and reason about, but it can also lead to more robust and scalable systems.
 * **Error Handling:** Both approaches require careful error handling to prevent deadlocks and other issues.

 By carefully considering these factors, you can choose the best approach for your specific use case.

 */


