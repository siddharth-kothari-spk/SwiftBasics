/// courtsey: https://medium.com/geekculture/leveraging-grand-central-dispatch-gcd-in-swift-for-efficient-concurrency-management-c9a62e189966
///
/*
 Key Features of GCD

     Queues: GCD uses queues to manage tasks. There are two types of queues: serial and concurrent. Serial queues execute tasks one after the other, while concurrent queues can execute multiple tasks simultaneously.
     Dispatch Groups: Dispatch groups enable synchronization of multiple tasks. You can use them to wait for a group of tasks to complete before executing further code.
     Dispatch Semaphores: Semaphores provide a mechanism to control access to shared resources. They can be used to ensure that a limited number of tasks access a particular resource at a time.
     Dispatch Sources: Dispatch sources enable monitoring of system events like file changes, timers, signals, and more.
 */


// A News Aggregator App

// 1. Fetching Articles Concurrently :
//Fetching articles from multiple sources can be time-consuming if done serially. With GCD, we can create a concurrent queue and fetch articles from different sources simultaneously.

let concurrentQueue = DispatchQueue(label: "com.example.articleFetching", attributes: .concurrent)

sources.forEach { source in
    concurrentQueue.async {
        let articles = fetchArticles(from: source)
        processAndDisplay(articles)
    }
}

// 2. Synchronizing Article Processing

//When processing articles, it’s essential to ensure that they’re displayed correctly and without any race conditions. To achieve this, we can use a dispatch group to synchronize the processing of articles.

let dispatchGroup = DispatchGroup()

sources.forEach { source in
    concurrentQueue.async(group: dispatchGroup) {
        let articles = fetchArticles(from: source)
        dispatchGroup.enter()
        processAndDisplay(articles)
        dispatchGroup.leave()
    }
}

dispatchGroup.notify(queue: .main) {
    print("All articles processed and displayed.")
}
