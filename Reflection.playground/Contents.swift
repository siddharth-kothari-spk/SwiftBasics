import UIKit
import XCTest
// https://useyourloaf.com/blog/using-swift-reflection/

struct Record {
  var locked: Bool = false
  var name1: String
  var name2: String
  var name3: String
  var name4: String
  var name5: String
  
  var updated_at: Date = Date()
}

extension String {
  public var isBlank: Bool {
    allSatisfy { $0.isWhitespace }
  }
}

/*extension Record {
  var isValid: Bool {
      !name1.isBlank &&
      !name2.isBlank &&
      !name3.isBlank &&
      !name4.isBlank &&
      !name5.isBlank
  }
}*/


let record = Record(name1: "aaa", name2: "bbb",
  name3: "ccc", name4: "ddd", name5: "eee")
let mirror = Mirror(reflecting: record)

for child in mirror.children {
  let label = child.label ?? "-"
  print("\(label) \(child.value)")
}


/*
 locked false
 name1 aaa
 name2 bbb
 name3 ccc
 name4 ddd
 name5 eee
 updated_at 2023-05-23 10:35:39 +0000
*/


extension Record {
  var isValid: Bool {
    let mirror = Mirror(reflecting: self)
    return mirror.children.compactMap {
      $0.value as? String
    }
    .allSatisfy { !$0.isBlank }
  }
}



let record1 = Record(name1: "aaa", name2: "  ",
  name3: "ccc", name4: "ddd", name5: "eee")
record1.isValid


func testNormalizeStrings() {
  let record = Record(name1: " xyz", name2: "xyz ",
    name3: " xyz ", name4: "  xyz", name5: "xyz  ")
 // let normal = record.normalize()
  
  let mirror = Mirror(reflecting: record)
  mirror.children.forEach { child in
    if let value = child.value as? String {
      XCTAssertEqual(value, "xyz")
    }
  }
}

testNormalizeStrings()
