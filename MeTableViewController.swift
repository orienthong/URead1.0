//
//  MeTableViewController.swift
//  uread
//
//  Created by Hao Dong on 27/09/2016.
//  Copyright © 2016 Hao Dong. All rights reserved.
//

import UIKit

class MeTableViewController: UITableViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(indexPath)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.section == 2 && indexPath.row == 0 {
            if UserKit.sharedInstance.isLoggedIn {
                UserKit.sharedInstance.logout()
                showAlert("登出成功", message: "")
            } else {
                let vc = loadVC(withStroyBoardName: "Login+Register", VCidentifer: "LoginViewController")
                self.presentViewController(vc, animated: true, completion: nil)
            }
        }
    }

}
