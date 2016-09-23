//
//  LoginByMobileViewController.swift
//  URead1.0
//
//  Created by Hao Dong on 16/9/15.
//  Copyright © 2016年 Hao Dong. All rights reserved.
//

import UIKit
import Alamofire
import ElasticTransition

class LoginByMobileViewController: UIViewController, UITextFieldDelegate {
    
    var transition = ElasticTransition()
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var mobilePhoneTextField: UITextField!
    
    @IBAction func login(sender: UIButton) {
        login()
    }
    @IBAction func register(sender: UIButton) {
        let sb = UIStoryboard(name: "Login+Register", bundle: nil)
        let vc = sb.instantiateViewControllerWithIdentifier("RegisterPickNameViewController") as! RegisterPickNameViewController
        self.transition.edge = .Right
        vc.transitioningDelegate = self.transition
        vc.modalPresentationStyle = .Custom
        self.presentViewController(vc, animated: true, completion: nil)
    }
    private func login() {
        view.endEditing(true)
        guard let password = passwordTextField.text, let mobilePhone = mobilePhoneTextField.text else {
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
                saveTokenAndUserInfoOfLoginUser(loginUser)
                print(NSUserDefaults.standardUserDefaults().objectForKey(v1AccessTokenKey)!)
                print("login")
        })
    }
    
    //MARK: -UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == mobilePhoneTextField {
            passwordTextField.becomeFirstResponder()
            return true
        } else {
            login()
            return true
        }
    }
    //MARK: -Controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.delegate = self
        mobilePhoneTextField.delegate = self
    }
    
}


