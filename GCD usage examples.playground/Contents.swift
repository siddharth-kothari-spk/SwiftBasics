/// courtsey: https://medium.com/geekculture/leveraging-grand-central-dispatch-gcd-in-swift-for-efficient-concurrency-management-c9a62e189966
///
/*
 Key Features of GCD

     Queues: GCD uses queues to manage tasks. There are two types of queues: serial and concurrent. Serial queues execute tasks one after the other, while concurrent queues can execute multiple tasks simultaneously.
     Dispatch Groups: Dispatch groups enable synchronization of multiple tasks. You can use them to wait for a group of tasks to complete before executing further code.
     Dispatch Semaphores: Semaphores provide a mechanism to control access to shared resources. They can be used to ensure that a limited number of tasks access a particular resource at a time.
     Dispatch Sources: Dispatch sources enable monitoring of system events like file changes, timers, signals, and more.
 */

