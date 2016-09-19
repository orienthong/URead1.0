//
//  Alert.swift
//  URead1.0
//
//  Created by Hao Dong on 9/18/16.
//  Copyright © 2016 Hao Dong. All rights reserved.
//

import Foundation
import ChameleonFramework
import RKDropdownAlert

public func showAlert(title: String, message: String) {
    RKDropdownAlert.title(title, message: message, backgroundColor: UIColor.flatGreenColor(), textColor: UIColor.flatBlackColor())
}