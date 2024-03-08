
// https://iamankurjain.medium.com/uncovering-hidden-gems-in-swift-0e785b323dcf

/*
 The concept of in-out parameters is a powerful tool for modifying variables passed to functions. However, there’s a catch when it comes to managing memory access: in-out parameters can lead to conflicts if not handled carefully. Let’s see how Swift deals with overlapping memory access in functions with in-out parameters and propose a solution to avoid conflicts.

 Understanding the Issue: When a function takes in-out parameters, it gains long-term write access to those variables. This means that the function can modify the variables for the entire duration of its execution. However, this also poses a risk of conflicting memory access, especially if the function modifies global variables or variables accessed elsewhere in the code.

 For instance, consider a scenario where a global variable stepSize is being modified within a function increment that takes an in-out parameter number. This could lead to conflicts because both stepSize and number refer to the same memory location.
 
 ////////////////////////////////////////
             var step = 1

             func update(_ num: inout Int) {
                 num += step
             }

             update(&step)
 ////////////////////////////////////////
 
 In the code above, step is a global variable, and it’s normally accessible from within update(_:). However, the read access to step overlaps with the write access to num. The read and write accesses refer to the same memory and they overlap, producing a conflict.
 
 */

// Sol:
/*
 Proposed Solution: To resolve conflicts arising from overlapping memory access, we can make an explicit copy of the variable before passing it to the function with in-out parameters. By doing so, we ensure that the function operates on a separate copy of the variable, preventing conflicts with the original variable.
 */


var step = 1

func update(_ num: inout Int) {
    num += step
}

var stepCopy = step
update(&stepCopy)
step = stepCopy
print(step)
