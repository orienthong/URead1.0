//
//  BaseViewController.swift
//  URead1.0
//
//  Created by Hao Dong on 9/18/16.
//  Copyright © 2016 Hao Dong. All rights reserved.
//

import UIKit
import ChameleonFramework

class BaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        guard let navigationController = navigationController else {
            return
        }
        navigationController.navigationBar.backgroundColor = nil
    }
    
}