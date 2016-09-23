//: Playground - noun: a place where people can play

import Cocoa

var str = "Hello, playground"
func loadArticles(ifLogin login: Bool, var page: Int = 1, completionHandler: (Bool, Int?, [String]) -> Void ) -> String {
//    page = "2"
    completionHandler(login, page + 1, ["dfdfd","fdfdfdf","fdfdfdf"])
    return "1"
}

loadArticles(ifLogin: false, completionHandler: { flag, json, arrays in
    print(flag)
    print(json)
    print(arrays)
})
