// localizedStandardCompare() https://www.swiftwithvincent.com/blog/discover-localizedstandardcompare

import Foundation

let fileNames = [
    "File 100.txt",
    "File 5.txt",
    "File 20.txt"
]


fileNames.sorted()
//  ["File 100.txt", "File 20.txt", "File 5.txt”]
// when you compare the Strings character by character, 1 does come before 2 and 2 does come before 5:

fileNames.sorted {
    $0.localizedStandardCompare($1) == .orderedAscending
}
//  ["File 5.txt", "File 20.txt", "File 100.txt”]
// localizedStandardCompare() -> function uses the current Locale in order to sort an array of strings in the same way the Finder app would
