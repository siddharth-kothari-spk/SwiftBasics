public class AdjacencyMatrix<Element> {
  private var matrix: [[Element?]] = []

  public init(vertices: Int) {
    for _ in 0..<vertices {
      matrix.append(Array(repeating: nil, count: vertices))
    }
  }

  public func setEdge(_ value: Element, from source: Int, to destination: Int) {
    guard source >= 0 && source < matrix.count &&
          destination >= 0 && destination < matrix.count else {
      return // Handle invalid indices
    }
    matrix[source][destination] = value
  }

  public func getEdge(from source: Int, to destination: Int) -> Element? {
    guard source >= 0 && source < matrix.count &&
          destination >= 0 && destination < matrix.count else {
      return nil
    }
    return matrix[source][destination]
  }
    
    public func currentAdjacencyMatrix() {
        for row in matrix {
          print(row)
        }
    }
  // You can add methods for graph traversal (BFS, DFS) here (may require additional logic)
}


// Define a graph to represent a transportation network (cities)
var transportationNetwork = AdjacencyMatrix<Int>(vertices: 4) // 4 cities

// Add edges (routes) with travel times between cities
transportationNetwork.setEdge(100, from: 0, to: 1) // City 0 -> City 1 (travel time 100)
transportationNetwork.setEdge(200, from: 0, to: 2) // City 0 -> City 2 (travel time 200)
transportationNetwork.setEdge(250, from: 1, to: 2) // City 1 -> City 2 (travel time 200)
transportationNetwork.setEdge(150, from: 1, to: 3) // City 1 -> City 3 (travel time 150)

// Print the adjacency matrix (showing edge weights or nil for no connection)
transportationNetwork.currentAdjacencyMatrix()

// Get travel time between City 0 and City 3 (indirect travel)
var travelTime = transportationNetwork.getEdge(from: 0, to: 3) ?? -1 // Check for nil value
print("Travel time from City 0 to City 3 (indirect): \(travelTime)")

travelTime = transportationNetwork.getEdge(from: 1, to: 3) ?? -1 // Check for nil value
print("Travel time from City 0 to City 3 (indirect): \(travelTime)")
