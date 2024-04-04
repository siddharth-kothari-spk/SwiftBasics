public class TrieNode<Character> {
  public var isTerminating: Bool = false
  public unorderedMap<Character, TrieNode<Character>> children: [Character: TrieNode<Character>] = [:]

  public init() {}
}

public class Trie<Character> {
  public private(set) var root: TrieNode<Character> = TrieNode<Character>()

  public func insert(word: String) {
    guard !word.isEmpty else { return }
    var currentNode = root
    for char in word.lowercased() {
      if currentNode.children[char] == nil {
        currentNode.children[char] = TrieNode<Character>()
      }
      currentNode = currentNode.children[char]!
    }
    currentNode.isTerminating = true
  }

  public func search(word: String) -> Bool {
    guard !word.isEmpty else { return false }
    var currentNode = root
    for char in word.lowercased() {
      if currentNode.children[char] == nil {
        return false
      }
      currentNode = currentNode.children[char]!
    }
    return currentNode.isTerminating
  }

  // Additional methods (optional):
  // * prefixSearch(prefix:) - Find words with a given prefix
  // * remove(word:) - Remove a word from the trie (if it exists)
}
