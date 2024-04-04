public struct Vertex<Value> {
  public let value: Value
  public var neighbors: [Vertex<Value>] = []

  public init(value: Value) {
    self.value = value
  }
}

public struct Graph<Value> {
  var vertices: [Vertex<Value>] = []

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

  // You can add methods for graph traversal (BFS, DFS) here
}


// Define a graph to represent a social network
var socialNetwork = Graph<String>()

// Add some vertices (people)
socialNetwork.addVertex("Alice")
socialNetwork.addVertex("Bob")
socialNetwork.addVertex("Charlie")
socialNetwork.addVertex("Diana")
socialNetwork.addVertex("Eve")

// Add edges (friendships)
socialNetwork.addEdge(from: 0, to: 1) // Alice -> Bob
socialNetwork.addEdge(from: 0, to: 2) // Alice -> Charlie
socialNetwork.addEdge(from: 1, to: 3) // Bob -> Diana
socialNetwork.addEdge(from: 2, to: 4) // Charlie -> Eve

// Print the neighbors (friends) for each person
for (index, vertex) in socialNetwork.vertices.enumerated() {
  print("Person: \(vertex.value)")
  print("  Friends:")
  for neighbor in vertex.neighbors {
    print("    \(neighbor.value)")
  }
}
