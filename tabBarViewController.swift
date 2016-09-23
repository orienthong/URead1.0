//
//  tabBarViewController.swift
//  URead1.0
//
//  Created by Hao Dong on 9/19/16.
//  Copyright © 2016 Hao Dong. All rights reserved.
//

import UIKit
import ElasticTransition
import BubbleTransition

class tabBarViewController: YALFoldingTabBarController, UITabBarControllerDelegate, UIViewControllerTransitioningDelegate {
    
    
    var touchPoint: CGPoint?
    
    let transition = CircleTransition()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.delegate = self
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        if let touch = touches.first {
            let position: CGPoint = touch.locationInView(view)
            print(position.x)
            print(position.y)
            touchPoint = position
        }
        
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        print("hey")
        transition.startingPoint = CGPoint(x: 207.0, y: 686.0)
        return transition
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func tabBarController(tabBarController: UITabBarController, animationControllerForTransitionFromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        toVC.transitioningDelegate = self
        
        transition.bubbleColor = UIColor.redColor()
        transition.startingPoint = CGPoint(x: 207.0, y: 686.0)
        return transition
    }

}

