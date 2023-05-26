import UIKit

// bit wise NOT
/*It is important to note that the bitwise NOT of any integer N is equal to -(N + 1). For example,

Consider an integer 35. As per the rule, the bitwise NOT of 35 should be -(35 + 1) = -36.

35 = 00100011 (In Binary)

// Using bitwise NOT operator
~  00100011
   ________
   11011100

In the above example, bitwise NOT of 00100011 is 11011100. Here, if we convert the result into decimal we get 220.

However, it is important to note that we cannot directly convert the result into decimal and get the desired output. This is because the binary result 11011100 is also equivalent to -36.

To understand this we first need to calculate the binary output of -36. We use 2's complement to calculate the binary of negative integers.
2's complement

The 2's complement of a number N gives -N. It is computed by inverting the bits(0 to 1 and 1 to 0) and then adding 1. For example,

36 = 00100100 (In Binary)

1's Complement = 11011011

2's Complement :
11011011
 +     1
________
11011100

Here, we can see the 2's complement of 36 (i.e. -36) is 11011100. This value is equivalent to the bitwise complement of 35 that we have calculated in the previous section.

Hence, we can say that the bitwise complement of 35 = -36. */
print("----------------------------")
var  bit = 12

var result = ~bit

print("bitwise NOT of \(bit) is \(result)")     // -13






// left shift operator : multiply by 2
/*
 We have a 4-digit number. When we perform a 1 bit left shift operation on it, each bit is shifted to the left by 1 bit.
 As a result, the left-most bit is discarded, while the right-most bit remains vacant. This vacancy is replaced by 0.

 */
print("----------------------------")
var leftShift = 3

result = leftShift << 2

print("leftShift of \(leftShift) is \(result)")     // 12






// right shift operator : divide by 2
/*
 We have a 4-digit number. When we perform a 1-bit right shift operation on it, each bit is shifted to the right by 1 bit.
 As a result, the right-most bit is discarded, while the left-most bit remains vacant. This vacancy is replaced by 0 for unsigned numbers.
 For signed numbers, the sign bit (0 for positive number, 1 for negative number) is used to fill the vacated bit positions.

 */
print("----------------------------")
var rightShift = 4

result = rightShift >> 2
print("rightShift of \(rightShift) is \(result)")    // 1

rightShift = -4

result = rightShift >> 2
print("rightShift of \(rightShift) is \(result)")    // -1

