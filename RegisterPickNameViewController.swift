//
//  RegisterPickNameViewController.swift
//  uread
//
//  Created by Hao Dong on 9/18/16.
//  Copyright © 2016 Hao Dong. All rights reserved.
//

import Foundation
import UIKit
import ElasticTransition

func getRandomColor() -> UIColor {
    let randomRed: CGFloat = CGFloat(drand48())
    let randomGreen: CGFloat = CGFloat(drand48())
    let randomBlue: CGFloat = CGFloat(drand48())
    return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
}

final class RegisterPickNameViewController: UIViewController, UITextFieldDelegate, ElasticMenuTransitionDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    
    //var dismissByForegroundDrag: Bool = true
    
    var phone: String = ""
    var verifyCode: String = ""
    var password: String = ""
    let rgr = UIScreenEdgePanGestureRecognizer()
    var transition = ElasticTransition()
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "pickNumber" {
            if let vc = segue.destinationViewController as? RegisterByMobleController {
                vc.delegate = self
                vc.name = nameTextField.text!
                vc.phone = phone
                vc.password = password
                vc.verifyCode = verifyCode
                
                segue.destinationViewController.transitioningDelegate = transition
                segue.destinationViewController.modalPresentationStyle = .Custom
            }
        }
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if nameTextField.text == "" {
            return false
        } else {
            performSegueWithIdentifier("pickNumber", sender: nil)
            return true
        }
    }
    func handleRightPan(pan: UIPanGestureRecognizer) {
        if pan.state == .Began{
            transition.edge = .Right
            transition.startInteractiveTransition(self, segueIdentifier: "pickNumber", gestureRecognizer: pan)
        }else{
            transition.updateInteractiveTransition(gestureRecognizer: pan)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
        setUpTransition()
        
    }
    private func setUpTransition() {
        rgr.addTarget(self, action: #selector(RegisterPickNameViewController.handleRightPan(_:)))
        rgr.edges = .Right
        view.addGestureRecognizer(rgr)
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        nameTextField.becomeFirstResponder()
    }
}
extension RegisterPickNameViewController: RegisterByMobleControllerDelegate {
    func saveInput(phone: String, verifyCode: String, password: String) {
        self.phone = phone
        print(phone)
        self.verifyCode = verifyCode
        self.password = password
    }
}
