//: Playground - noun: a place where people can play

import Cocoa

var str = "Hello, playground"


func loadArticles(ifLogin login: Bool, page: Int? = 1,failHandler: (NSError?) -> Void,completionHandler: (Bool) -> Void ) {
    
    if login {
        completionHandler(true)
    } else {
        failHandler(NSError(domain: "没有登录", code: 1, userInfo: nil))
        completionHandler(false)
    }
}
loadArticles(ifLogin: true, failHandler: {
    (error) in
    print(error)
}) { (success) in
    print(success)
}

struct RegexHelper {
    let regex: NSRegularExpression
    
    init(_ pattern: String) throws {
        try regex = NSRegularExpression(pattern: pattern,
                                        options: .CaseInsensitive)
    }
    
    func match(input: String) -> Bool {
        let matches = regex.matchesInString(input,
                                            options: [],
                                            range: NSMakeRange(0, input.utf16.count))
        return matches.count > 0
    }
}
let mailPattern =
"^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$"

let matcher: RegexHelper
do {
    matcher = try RegexHelper(mailPattern)
}

let maybeMailAddress = "onev@onevcat.com"

if matcher.match(maybeMailAddress) {
    print("有效的邮箱地址")
}
