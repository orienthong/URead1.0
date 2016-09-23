//
//  ThirdViewController.swift
//  URead1.0
//
//  Created by Hao Dong on 9/19/16.
//  Copyright © 2016 Hao Dong. All rights reserved.
//

import UIKit
import ElasticTransition

class ThirdViewController: UIViewController {
    
    let transition = ElasticTransition()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let vc = segue.destinationViewController as! FourthViewController
        vc.transitioningDelegate = transition
        vc.modalPresentationStyle = .Custom
    }
    
}

extension ThirdViewController: YALTabBarDelegate {
    func tabBarDidSelectExtraLeftItem(tabBar: YALFoldingTabBar!) {
        print("hhahah")
        let vc = loadVC(withStroyBoardName: "Main", VCidentifer: "FourthViewController") as! FourthViewController
        vc.transitioningDelegate = transition
        transition.edge = .Bottom
        vc.modalPresentationStyle = .Custom
        presentViewController(vc, animated: true, completion: nil)
    }
}
