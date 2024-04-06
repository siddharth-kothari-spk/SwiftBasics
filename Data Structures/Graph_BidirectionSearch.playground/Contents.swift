public struct Vertex<Value: Comparable>: Equatable {
    public static func == (lhs: Vertex<Value>, rhs: Vertex<Value>) -> Bool {
        lhs.value == rhs.value
    }
    
  public let value: Value
  public var neighbors: [Vertex<Value>] = []

  public init(value: Value) {
    self.value = value
  }
}

public func ==<T: Equatable>(lhs: Vertex<T>, rhs: Vertex<T>) -> Bool {
   return lhs.value == rhs.value
}

public struct Graph<Value: Comparable> {
  private var vertices: [Vertex<Value>] = []

  public mutating func addVertex(_ value: Value) {
    vertices.append(Vertex(value: value))
  }

  public mutating func addEdge(from source: Int, to destination: Int) {
    guard source >= 0 && source < vertices.count &&
          destination >= 0 && destination < vertices.count else {
      return // Handle invalid indices
    }
    vertices[source].neighbors.append(vertices[destination])
  }

  public func getVertex(at index: Int) -> Vertex<Value>? {
    guard index >= 0 && index < vertices.count else {
      return nil
    }
    return vertices[index]
  }

  public func bidirectionalSearch(from start: Int, to end: Int, visit: (Vertex<Value>, Vertex<Value>) -> Void) {
    guard start >= 0 && start < vertices.count &&
          end >= 0 && end < vertices.count else {
      return // Handle invalid start or end indices
    }

    var frontier1 = Queue<Vertex<Value>>() // Frontier for searching from start
    var frontier2 = Queue<Vertex<Value>>() // Frontier for searching from end
    var visited1 = [Bool](repeating: false, count: vertices.count) // Visited for search from start
    var visited2 = [Bool](repeating: false, count: vertices.count) // Visited for search from start

    frontier1.enqueue(vertices[start])
    visited1[start] = true
    frontier2.enqueue(vertices[end])
    visited2[end] = true

    while !frontier1.isEmpty && !frontier2.isEmpty {
      // Explore from start side
      if let current1 = frontier1.dequeue() {
        for neighbor in current1.neighbors {
          let neighborIndex = vertices.firstIndex(of: neighbor)!
          if visited2[neighborIndex] {
            visit(current1, neighbor)
            return // Found a meeting point
          }
          if !visited1[neighborIndex] {
            frontier1.enqueue(neighbor)
            visited1[neighborIndex] = true
          }
        }
      }

      // Explore from end side
      if let current2 = frontier2.dequeue() {
        for neighbor in current2.neighbors {
          let neighborIndex = vertices.firstIndex(of: neighbor)!
          if visited1[neighborIndex] {
            visit(current2, neighbor)
            return // Found a meeting point
          }
          if !visited2[neighborIndex] {
            frontier2.enqueue(neighbor)
            visited2[neighborIndex] = true
          }
        }
      }
    }
  }
}

public struct Queue<Element> {
  private var items: [Element] = []

  public mutating func enqueue(_ element: Element) {
    items.append(element)
  }

  public mutating func dequeue() -> Element? {
    guard !items.isEmpty else { return nil }
    return items.removeFirst()
  }

  public var isEmpty: Bool {
    return items.isEmpty
  }
}


// Add vertices (maze cells) and edges (connections between cells)
// ... (code to define the maze structure)

var socialNetwork = Graph<String>()

socialNetwork.addVertex("Alice")
socialNetwork.addVertex("Bob")
socialNetwork.addVertex("Charlie")
socialNetwork.addVertex("Diana")
socialNetwork.addVertex("Eve")
socialNetwork.addVertex("Sid")
socialNetwork.addVertex("Dev")
socialNetwork.addVertex("Prateek")
socialNetwork.addVertex("Rishabh")
socialNetwork.addVertex("Kartik")
socialNetwork.addVertex("Nikku")

socialNetwork.addEdge(from: 0, to: 1) // Alice -> Bob
socialNetwork.addEdge(from: 0, to: 2) // Alice -> Charlie
socialNetwork.addEdge(from: 1, to: 3) // Bob -> Diana
socialNetwork.addEdge(from: 2, to: 4) // Charlie -> Eve
socialNetwork.addEdge(from: 4, to: 5) // Eve -> Sid
socialNetwork.addEdge(from: 6, to: 5) // Sid <- Dev
socialNetwork.addEdge(from: 7, to: 6) // Dev <- Prateek
socialNetwork.addEdge(from: 8, to: 7) // Prateek <- Rishabh
socialNetwork.addEdge(from: 9, to: 8) // Rishabh <- Kartik
socialNetwork.addEdge(from: 10, to: 9) // Kartik <- Nikku
socialNetwork.addEdge(from: 10, to: 0) // Nikku <- Alice

// Perform bidirectional search to find a path from entrance (index 0) to exit (index 10)
socialNetwork.bidirectionalSearch(from: 0, to: 10) { startCell, endCell in
  print("Found path: \(startCell.value) -> \(endCell.value)")
}

