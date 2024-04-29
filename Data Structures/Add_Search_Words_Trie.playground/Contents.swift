/*
 https://leetcode.com/problems/design-add-and-search-words-data-structure/description/
 Design a data structure that supports adding new words and finding if a string matches any previously added string.

 Implement the WordDictionary class:

 WordDictionary() Initializes the object.
 void addWord(word) Adds word to the data structure, it can be matched later.
 bool search(word) Returns true if there is any string in the data structure that matches word or false otherwise. word may contain dots '.' where dots can be matched with any letter.
 
 Example:

 Input
 ["WordDictionary","addWord","addWord","addWord","search","search","search","search"]
 [[],["bad"],["dad"],["mad"],["pad"],["bad"],[".ad"],["b.."]]
 Output
 [null,null,null,null,false,true,true,true]

 Explanation
 WordDictionary wordDictionary = new WordDictionary();
 wordDictionary.addWord("bad");
 wordDictionary.addWord("dad");
 wordDictionary.addWord("mad");
 wordDictionary.search("pad"); // return False
 wordDictionary.search("bad"); // return True
 wordDictionary.search(".ad"); // return True
 wordDictionary.search("b.."); // return True
 */


class TrieNode {
    var children: [Character: TrieNode] = [:]
    var isEndOfWord: Bool = false
}

class WordDictionary {
    private var root: TrieNode

    init() {
        root = TrieNode()
    }

    func addWord(_ word: String) {
        var currentNode = root
        for char in word {
            if currentNode.children[char] == nil {
                currentNode.children[char] = TrieNode()
            }
            currentNode = currentNode.children[char]!
        }
        currentNode.isEndOfWord = true
    }

    func search(_ word: String) -> Bool {
        return searchHelper(word, node: root, index: 0)
    }

    private func searchHelper(_ word: String, node: TrieNode, index: Int) -> Bool {
        if index == word.count {
            return node.isEndOfWord
        }
        
        let charIndex = word.index(word.startIndex, offsetBy: index)
        let char = word[charIndex]

        if char == "." {
            // If it's a wildcard, try all possible children nodes.
            for childNode in node.children.values {
                if searchHelper(word, node: childNode, index: index + 1) {
                    return true
                }
            }
        } else if let nextNode = node.children[char] {
            return searchHelper(word, node: nextNode, index: index + 1)
        }

        return false
    }
}

// Example Usage
let wordDictionary = WordDictionary()
wordDictionary.addWord("bad")
wordDictionary.addWord("dad")
wordDictionary.addWord("mad")
print(wordDictionary.search("pad"))  // Output: false
print(wordDictionary.search("bad"))  // Output: true
print(wordDictionary.search(".ad"))  // Output: true
print(wordDictionary.search("b.."))  // Output: true
