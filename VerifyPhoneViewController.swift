//
//  VerifyPhoneViewController.swift
//  uread
//
//  Created by Hao Dong on 27/09/2016.
//  Copyright © 2016 Hao Dong. All rights reserved.
//

import UIKit
import RealmSwift
import ElasticTransition


class LoginViewController: UIViewController, UITextFieldDelegate,UIViewControllerTransitioningDelegate {
    var transition = ElasticTransition()
    var keyBoardNeedLayout: Bool = true

    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var passwordInput: UITextField! // 密码输入框
    @IBOutlet weak var accountInput: UITextField! // 帐号输入框
    
    var offsetLeftHand : CGFloat = 60
    @IBInspectable
    let bartintcolor : UIColor = UIColor.whiteColor()
    @IBInspectable
    let titleColor : UIColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
    @IBAction func loginButton(sender: UIButton) {
        login()
    }
    @IBAction func registerButtonTapped(sender: UIButton) {
        let sb = UIStoryboard(name: "Login+Register", bundle: nil)
        let vc = sb.instantiateViewControllerWithIdentifier("RegisterPickNameViewController") as! RegisterPickNameViewController
        self.transition.edge = .Right
        vc.transitioningDelegate = self.transition
        vc.modalPresentationStyle = .Custom
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        accountInput.delegate = self
        passwordInput.delegate = self
        loginButton.hidden = true
        passwordInput.secureTextEntry = true
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.keyboardWillShow(_:)), name:UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.keyboardWillHide(_:)), name:UIKeyboardWillHideNotification, object: nil)
//        ArticleHandler.shareHandler.clearArticles()
        
    }
    
    private func login() {
        view.endEditing(true)
        guard let password = passwordInput.text, let mobilePhone = accountInput.text else {
            showAlert("登录错误", message: "请输入手机号码或密码")
            return
        }
        guard mobilePhone.characters.count == 11 else {
            showAlert("登录错误", message: "请输入争取的手机号码")
            return
        }
        loginByMobile(mobilePhone, withAreaCode: "+86", password: password, failureHandler: { (reason: Reason, errorMessage: String?) in
            switch reason {
            case .PhoneIsExist:
                print("")
                break
            case .LoginByUnRegisteUser:
                showAlert("登录错误", message: errorMessage!)
                break
            case .CouldNotParseJSON:
                showAlert("登录错误", message: errorMessage!)
                break
            case .Other(_):
                showAlert("登录错误", message: errorMessage!)
                break
            case .unKnown:
                showAlert("登录错误", message: errorMessage!)
            }
            }, completion: { loginUser in
                print("login")
                saveTokenAndUserInfoOfLoginUser(loginUser)
                self.dismissViewControllerAnimated(true, completion: nil)
        })
        
    }
    
    //MARK: -TextFieldDelegate
    //输入框获取焦点开始编辑
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == accountInput {
            passwordInput.becomeFirstResponder()
            return true
        } else {
            login()
            return true
        }
    }
    
    // MARK: UIViewControllerTransitioningDelegate
//    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        return TKFadeInAnimator(transitionDuration: 0.5, startingAlpha: 0.8)
//    }
//    
//    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        return nil
//    }
    
    
    // MARK：-KeyboardAnimation
    func keyboardWillShow(notification: NSNotification) {
        print("show")
        
        if let userInfo = notification.userInfo,
            value = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue,
            duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double,
            curve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? UInt {
            
            let frame = value.CGRectValue()
            let intersection = CGRectIntersection(frame, self.view.frame)
            
            let deltaY = CGRectGetHeight(intersection)
            
            if keyBoardNeedLayout {
                UIView.animateWithDuration(duration, delay: 0.0,
                                           options: UIViewAnimationOptions(rawValue: curve),
                                           animations: { _ in
                                            self.view.frame = CGRectMake(0,-deltaY/2,self.view.bounds.width,self.view.bounds.height)
                                            self.keyBoardNeedLayout = false
                                            self.view.layoutIfNeeded()
                    }, completion: nil)
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        print("hide")
        if let userInfo = notification.userInfo,
            value = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue,
            duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double,
            curve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? UInt {
            
            let frame = value.CGRectValue()
            let intersection = CGRectIntersection(frame, self.view.frame)
            
            let deltaY = CGRectGetHeight(intersection)
            
            UIView.animateWithDuration(duration, delay: 0.0,
                                       options: UIViewAnimationOptions(rawValue: curve),
                                       animations: { _ in
                                        self.view.frame = CGRectMake(0,deltaY/2,self.view.bounds.width,self.view.bounds.height)
                                        self.keyBoardNeedLayout = true
                                        self.view.layoutIfNeeded()
                }, completion: nil)
        }
    }
    
}


