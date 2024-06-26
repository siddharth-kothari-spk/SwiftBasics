// https://www.hackingwithswift.com/plus/advanced-swift/how-to-use-phantom-types-in-swift

// a type that doesn’t use at least one of its generic type parameters

struct Employee<Role>: Equatable {
    var name: String
}

// That is generic over some sort of Role, but Role doesn’t appear in the type’s definition – there’s only that one string.

//That doesn’t use Role at all, so we could just have used this instead:
/*
'''
        struct Employee: Equatable {
            var name: String
        }
'''
*/

// there’s an important difference: although we don’t use the generic parameter, Swift does. This allows Swift to enforce rules for us much more strictly.

enum Sales {}
enum Programmer {}

//  It’s a good idea to use a no-case enum rather than a struct, because the enum cannot be instantiated, whereas someone could create an instance of the struct and wonder what it’s good for.

// Now lets have 2 employees, both named Sid , one working as programmer and one in sales

let sid1 = Employee<Programmer>(name: "Sid")
let sid2 = Employee<Sales>(name: "Sid")

// we made Employee conform to Equatable, and because its single property already conforms to Equatable Swift will be able to synthesize an == function to let us compare two employees. So, we can check whether our two employees are actually the same person

print(sid1 == sid2) // Error: Cannot convert value of type 'Employee<Sales>' to expected argument type 'Employee<Programmer>'

// we aren’t comparing two instances of Employee any more, we’re comparing an Employee<Programmer> and an Employee<Sales>, and Swift considers them to be different. In comparison, if we had made someone’s role a string property, Swift would say that the two Zoe’s are different at runtime, but it wouldn’t stop us from compiling.

// Example :

enum OPositive { }
enum APositive { }
enum BPositive { }

struct BloodSample<Type> {
    let amount: Double

    static func +(lhs: BloodSample, rhs: BloodSample) -> BloodSample {
        BloodSample(amount: lhs.amount + rhs.amount)
    }
}

// That has a + operator that lets us combine two blood samples, but Swift will automatically understand that two samples from different blood types are different and stop us from mixing them by accident.

// working code
let sample1 = BloodSample<OPositive>(amount: 5)
let sample2 = BloodSample<APositive>(amount: 5)
let sample3 = BloodSample<OPositive>(amount: 7)

let combined1 = sample1 + sample3

// not working code

let combined2 = sample1 + sample2 // Error: Cannot convert value of type 'BloodSample<APositive>' to expected argument type 'BloodSample<OPositive>'

// Example 2:

//Sometimes the differences between types are less subtle. For example, consider a user struct like this one:

struct User {
    let id: Int
    let age: Int
}
//Both id and age are integers, so there’s nothing stopping us from comparing them like this

let user = User(id: 53, age: 53)
print(user.id == user.age)
// integers are identical, but if you’re comparing user IDs to ages then it’s almost certainly a mistake – and it’s a mistake phantom types can help us catch.


enum UserID { }
enum Age { }

struct Tag<Type>: Equatable {
    var value: Int
}

struct User_Phantom {
    let id: Tag<UserID>
    let age: Tag<Age>
    
    init(id: Tag<UserID>, age: Tag<Age>) {
        self.id = id
        self.age = age
    }
}

let user2 = User_Phantom(id: Tag(value: 100), age: Tag(value: 100))

print(user2.age == user2.id) // Error: Cannot convert value of type 'Tag<UserID>' to expected argument type 'Tag<Age>'


// using ExpressibleByIntegerLiteral

struct Tag2<Type>: Equatable, ExpressibleByIntegerLiteral {
    init(integerLiteral value: IntegerLiteralType) {
        self.value = value
    }
    var value: Int
}

struct User_Phantom2 {
    let id: Tag2<UserID>
    let age: Tag2<Age>
}

let user3 = User_Phantom2(id: Tag2(integerLiteral: 50), age: Tag2(integerLiteral: 70))

print(user3.age == user3.id) // Error: Cannot convert value of type 'Tag2<UserID>' to expected argument type 'Tag2<Age>'
