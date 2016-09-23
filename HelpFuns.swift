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
