import Foundation

let a = #"2 hello world 2"#
let b = #"hello world"#

let difference = zip(a, b)
    .filter { $0 != $1 }
difference
