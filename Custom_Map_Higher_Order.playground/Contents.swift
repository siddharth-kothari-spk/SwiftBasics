// https://www.youtube.com/watch?v=EosnYzSwIw8
import Foundation

let arr = [1,2,3]
print(arr.map({ value in
    value * 2
}))


func customMap<T>(elements: [T],
                  mapTransform: (T) -> T) -> [T] {
    
    var results: [T] = []
    
    for item in elements {
        results.append(mapTransform(item))
    }
    return results
}

print(customMap(elements: arr, mapTransform: { element in
    element * element
}))
