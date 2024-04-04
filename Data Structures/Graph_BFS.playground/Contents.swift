public struct Graph<Value> {
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

  public func breadthFirstSearch(from source: Int, visit: (Vertex<Value>) -> Void) {
    var queue = Queue<Vertex<Value>>()
    var visited = [Bool](repeating: false, count: vertices.count)

    queue.enqueue(vertices[source])
    visited[source] = true

    while !queue.isEmpty {
      let currentVertex = queue.dequeue()!
      visit(currentVertex)

      for neighbor in currentVertex.neighbors {
        if !visited[vertices.firstIndex(of: neighbor)!] {
          queue.enqueue(neighbor)
          visited[vertices.firstIndex(of: neighbor)!] = true
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


// Define a graph to represent a social network of people
var socialNetwork = Graph<String>()

socialNetwork.addVertex("Alice")
socialNetwork.addVertex("Bob")
socialNetwork.addVertex("Charlie")
socialNetwork.addVertex("Diana")
socialNetwork.addVertex("Eve")

socialNetwork.addEdge(from: 0, to: 1) // Alice -> Bob
socialNetwork.addEdge(from: 0, to: 2) // Alice -> Charlie
socialNetwork.addEdge(from: 1, to: 3) // Bob -> Diana
socialNetwork.addEdge(from: 2, to: 4) // Charlie -> Eve

// Perform BFS traversal starting from Alice and print visited people's names
socialNetwork.breadthFirstSearch(from: 0) { person in
  print("Visited: \(person.value)")
}
