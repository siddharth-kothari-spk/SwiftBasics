import UIKit

print("----------------------------")
// for loop : stride
for i in stride(from: 0, to: 10, by: 2) {
    print("stride index: \(i) by 2")
}

// for loop : where clause
// remove Java from an array

let languages = ["Swift", "Java", "Go", "JavaScript"]

for language in languages where language != "Java"{
  print(language)
}






print("----------------------------")
// while : repeat while
// program to display numbers

var i = 1, n = 5

// repeat...while loop from 1 to 5
repeat {
  
  print(i)

  i = i + 1

} while (i <= n)



print("----------------------------")
// Swift labeled break
outerloop: for i in 1...3{

  innerloop: for j in 1...3 {

    if j == 3 {
        print("j == 3 so outerloop of i broken")
      break outerloop
    }

      print("i = \(i), j = \(j)")
  }
}




print("----------------------------")
// Swift labeled continue
outerloop: for i in 1...3{
  
  innerloop: for j in 1...3 {
    
    if j == 3 {
        print("j == 3 so outerloop of i continue")
      continue outerloop
    }
    
    print("i = \(i), j = \(j)")
  }
}

