import UIKit

/*
 sample
 Input: strs = ["eat","tea","tan","ate","nat","bat"]
 Output: [["bat"],["nat","tan"],["ate","eat","tea"]]
 
 logic:
 1. Initialize an empty dictionary, anagram_dict, where the keys will be the sorted characters of each word, and the values will be the corresponding lists of anagrams.
 2. Iterate through each word in the input list strs.
 3. Sort the characters of the current word and store it in a variable, sorted_word.
 4. Check if sorted_word exists as a key in anagram_dict.
    a. If it exists, append the current word to the corresponding value list in anagram_dict.
    b. If it doesn't exist, create a new key-value pair in anagram_dict with sorted_word as the key and a list containing the current word as the value.
 5.After iterating through all the words, collect the values from anagram_dict and return them as the grouped anagrams.
 */


func groupAnagrams(strings: [String]) -> [[String]] {
    var anagramDict : [String: [String] ] = [:]
    for word in strings {
        let sortedWord = String(word.sorted())
            guard let _ = anagramDict[sortedWord] else {
                anagramDict[sortedWord] = [word]
                continue
            }
            anagramDict[sortedWord]?.append(word)
     
    }
    return Array(anagramDict.values)
}

let strs = ["eat","tea","tan","ate","nat","bat"]
print(groupAnagrams(strings: strs))
