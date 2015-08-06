//
//  ViewController.swift
//  SwiftErrorHandling
//
//  Created by Shad Downey on 8/6/15.
//  Copyright © 2015 Shad's Goode Apps. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()



        enum Foo : ErrorType {
            case Fizz, Buzz
        }

        enum Bar : ErrorType {
            case Baz, Qux
        }

        func doStuff(withWhat: Int) throws -> () {
            if (withWhat > 5) {
                throw Bar.Baz
            }
            if (withWhat > 4) {
                throw Bar.Qux
            }
            print("`doStuff` finished executing")
        }

        func doIt() -> () {

            //I know what I'm doing!!!!
            try! doStuff(3)

            //try! doStuff(6)

            do {
                defer {
                    print("I still ran!")
                }
                try doStuff(6)//This will throw
//            } catch Bar.Baz {
//                print("baz")
//            } catch Bar.Qux {
//                print("foo")
            } catch {
                print("An error was thrown")
            }

            defer {
                print("A) I will run")
            }

            defer {
                print("B) I will also run")
            }

            print("C) `doIt` reached the end of scope")
        }
        
        doIt()



    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

