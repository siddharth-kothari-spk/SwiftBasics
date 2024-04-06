class TrieNode {
    var children: [Character: TrieNode] = [:]
    var isEndOfWord: Bool = false
}

class Trie {
    private let root: TrieNode
    
    init() {
        root = TrieNode()
    }
    
    func insert(_ word: String) {
        var node = root
        for char in word {
            if let childNode = node.children[char] {
                node = childNode
            } else {
                let newNode = TrieNode()
                node.children[char] = newNode
                node = newNode
            }
        }
        node.isEndOfWord = true
    }
    
    func search(_ word: String) -> Bool {
        var node = root
        for char in word {
            guard let childNode = node.children[char] else {
                return false
            }
            node = childNode
        }
        return node.isEndOfWord
    }
    
    func startsWith(_ prefix: String) -> Bool {
        var node = root
        for char in prefix {
            guard let childNode = node.children[char] else {
                return false
            }
            node = childNode
        }
        return true
    }
    
    func remove(_ word: String) {
            guard !word.isEmpty else { return }
            removeHelper(root, word, index: 0)
        }
        
    private func removeHelper(_ node: TrieNode, _ word: String, index: Int) -> Bool {
        if index == word.count {
            if node.isEndOfWord {
                node.isEndOfWord = false
                return node.children.isEmpty
            }
            return false
        }
        
        let char = word[word.index(word.startIndex, offsetBy: index)]
        guard let childNode = node.children[char] else {
            return false
        }
        
        let shouldDeleteNode = removeHelper(childNode, word, index: index + 1)
        
        if shouldDeleteNode {
            node.children[char] = nil
            return node.children.isEmpty
        }
        
        return false
    }
}

let trie = Trie()
trie.insert("apple")
print(trie.search("apple"))   // Output: true
print(trie.search("app"))     // Output: false
print(trie.startsWith("app")) // Output: true
trie.insert("app")
print(trie.search("app"))     // Output: true

trie.insert("temple")
print(trie.search("temp")) // false
print(trie.startsWith("temp")) // true
trie.insert("temp")
trie.insert("tempest")
print(trie.search("app")) // true

trie.remove("temp")
print(trie.search("temp")) // false
print(trie.startsWith("temp")) // true
