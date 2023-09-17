// https://levelup.gitconnected.com/mastering-where-keyword-in-swift-2d3f01314f24

// 1. Adding constraints to generic parameters
// Without ‘where’

func findIndexWithoutWhere<T: Equatable>(_ array: [T], value: T) -> Int? {
    for (index, item) in array.enumerated() {
        if item == value {
            return index
        }
    }
    return nil
}

// With where
func findIndexWithWhere<T>(_ array: [T], value: T) -> Int? where T: Equatable //  the ‘where’ keyword is used to add a constraint to the generic parameter T, so T must conform to the Equatable protocol.
{
    for (index, item) in array.enumerated() where item == value // where’ to filter the elements in the enumerate method.
    {
        return index
    }
    return nil
}


// 2. Adding constraints to associated types

// without where
protocol Container {
    associatedtype Item: Equatable
    var count: Int { get }
    subscript(i: Int) -> Item { get }
}

extension Container {
    func indexOf(item: Item) -> Int? {
        for i in 0..<count {
            if self[i] == item {
                return i
            }
        }
        return nil
    }
}

// with where
// usage 1
protocol Container1 {
    associatedtype Item
    var count: Int { get }
    subscript(i: Int) -> Item { get }
}

extension Container1 where Item: Equatable {
    func indexOf(item: Item) -> Int? {
        for i in 0..<count where self[i] == item {
                   return i
        }
        return nil

    }
}


// usage 2
protocol Container2 {
    associatedtype Item where Item: Equatable
    var count: Int { get }
    subscript(i: Int) -> Item { get }
}

extension Container2 {
    func indexOf(item: Item) -> Int? {
        for i in 0..<count where self[i] == item {
            return i
        }
        return nil
    }
}

// 3. Adding constraints to function parameters
// without where
func isEqual<T: Equatable>(_ a: T, _ b: T) -> Bool {
    return a == b
}

// with where
func isEqual<T>(_ a: T, _ b: T) -> Bool where T: Equatable {
    return a == b
}
