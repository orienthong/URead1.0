//
//  HelpFuns.swift
//  URead1.0
//
//  Created by Hao Dong on 9/20/16.
//  Copyright © 2016 Hao Dong. All rights reserved.
//

import Foundation
import UIKit

public func loadVC(withStroyBoardName storyboardIdentifier: String,VCidentifer idetifier: String) -> UIViewController {
    let sb = UIStoryboard(name: storyboardIdentifier, bundle: nil)
    let vc = sb.instantiateViewControllerWithIdentifier(idetifier)
    return vc
}

extension String {
    /**
     判断是否为正确格式的email
     */
    func isEmail() -> Bool {
        let regex = try! NSRegularExpression(pattern: "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,4}$",
                                             options: [.CaseInsensitive])
        return regex.firstMatchInString(self, options:[],
                                        range: NSMakeRange(0, utf16.count)) != nil
    }
}