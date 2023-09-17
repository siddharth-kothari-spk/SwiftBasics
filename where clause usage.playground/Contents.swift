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

