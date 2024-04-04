public struct Heap<Element: Comparable> {
  private var elements: [Element] = []

  public var isEmpty: Bool {
    return elements.isEmpty
  }

  public var peek: Element? {
    return elements.first
  }

  public mutating func insert(_ element: Element) {
    elements.append(element)
    siftUp(from: elements.count - 1)
  }

  public mutating func remove() -> Element? {
    guard !isEmpty else { return nil }
    if elements.count == 1 {
      return elements.removeFirst()
    }
    elements.swapAt(0, elements.count - 1)
    let removedElement = elements.removeLast()
    siftDown(from: 0)
    return removedElement
  }

  // Helper methods for heap operations
  private mutating func siftUp(from index: Int) {
    var currentIndex = index
    while currentIndex > 0 {
      let parentIndex = (currentIndex - 1) / 2
      if isOrdered(elements[currentIndex], elements[parentIndex]) {
        break
      }
      elements.swapAt(currentIndex, parentIndex)
      currentIndex = parentIndex
    }
  }

  private mutating func siftDown(from index: Int) {
    var currentIndex = index
    while 2 * currentIndex + 1 < elements.count {
      var nextIndex = 2 * currentIndex + 1
      if nextIndex + 1 < elements.count && isOrdered(elements[nextIndex + 1], elements[nextIndex]) {
        nextIndex += 1
      }
      if isOrdered(elements[currentIndex], elements[nextIndex]) {
        break
      }
      elements.swapAt(currentIndex, nextIndex)
      currentIndex = nextIndex
    }
  }

  // This function defines the order relation for the heap (Min Heap by default)
  private func isOrdered(_ element1: Element, _ element2: Element) -> Bool {
    return element1 < element2 // Min Heap
  }
}
