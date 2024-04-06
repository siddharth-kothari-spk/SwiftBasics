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

  public func depthFirstSearch(from source: Int, visit: (Vertex<Value>) -> Void) {
    var visited = [Bool](repeating: false, count: vertices.count)
    depthFirstSearch(at: source, visited: &visited, visit: visit)
  }

  private func depthFirstSearch(at index: Int, visited: inout [Bool], visit: (Vertex<Value>) -> Void) {
    guard !visited[index] else { return }
    visited[index] = true
    visit(vertices[index])

    for neighbor in vertices[index].neighbors {
      depthFirstSearch(at: vertices.firstIndex(of: neighbor)! , visited: &visited, visit: visit)
    }
  }
}


// Define a graph to represent a network of computers
var computerNetwork = Graph<String>()

computerNetwork.addVertex("Computer A")
computerNetwork.addVertex("Computer B")
computerNetwork.addVertex("Computer C")
computerNetwork.addVertex("Computer D")
computerNetwork.addVertex("Computer E")

computerNetwork.addEdge(from: 0, to: 1)
computerNetwork.addEdge(from: 0, to: 2)
computerNetwork.addEdge(from: 1, to: 3)
computerNetwork.addEdge(from: 2, to: 4)

// Perform DFS traversal starting from Computer A and print visited computer names
print("Computer A--------")
computerNetwork.depthFirstSearch(from: 0) { computer in
  print("Visited: \(computer.value)")
}

print("Computer B--------")
computerNetwork.depthFirstSearch(from: 1) { computer in
  print("Visited: \(computer.value)")
}

print("Computer C--------")
computerNetwork.depthFirstSearch(from: 2) { computer in
  print("Visited: \(computer.value)")
}

print("Computer D--------")
computerNetwork.depthFirstSearch(from: 3) { computer in
  print("Visited: \(computer.value)")
}

print("Computer E--------")
computerNetwork.depthFirstSearch(from: 4) { computer in
  print("Visited: \(computer.value)")
}
