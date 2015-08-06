//: Playground - noun: a place where people can play

import UIKit

enum blergh : ErrorType {
    case BlerghyBlergh
}

class FizzBuzz : NSObject, ErrorType {
    var _domain: String { get {
        return "Fake"
        } }
    var _code: Int { get {
        return 42
        } }
}

func blah() throws -> () {
    defer {
        var foo = "Foo"
        print(foo)
        defer {
            print("oh yeah! \(foo)")
        }
    }
    throw blergh.BlerghyBlergh
}


func huff() -> () {
    try! blah()
}

