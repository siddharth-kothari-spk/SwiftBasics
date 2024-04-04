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
            visit(current1, neighbor)
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
  // ... same Queue implementation as before
}


// Define a graph to represent a maze
var maze = Graph<String>()

// Add vertices (maze cells) and edges (connections between cells)
// ... (code to define the maze structure)

// Perform bidirectional search to find a path from entrance (index 0) to exit (index 10)
maze.bidirectionalSearch(from: 0, to: 10) { startCell, endCell in
  print("Found path: \(startCell.value) -> \(endCell.value)")
}
