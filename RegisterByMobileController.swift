//
//  RegisterByMobileController.swift
//  URead1.0
//
//  Created by Hao Dong on 9/16/16.
//  Copyright © 2016 Hao Dong. All rights reserved.
//

import UIKit
import Alamofire
import ChameleonFramework
import ElasticTransition

protocol RegisterByMobleControllerDelegate: class {
    func saveInput(phone: String, verifyCode: String, password: String)
}
class RegisterByMobleController: UIViewController, ElasticMenuTransitionDelegate {
    
    var name: String = ""
    var phone: String = ""
    var verifyCode: String = ""
    var password: String = ""
    
    weak var delegate: RegisterByMobleControllerDelegate?
    
    var dismissByForegroundDrag: Bool = true

    @IBOutlet weak var phoneTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var verifyCodeTextField: UITextField!
    
    
    @IBAction func getVerifyCode(sender: AnyObject) {
        guard phoneTextField.text!.characters.count == 11 else {
            showAlert("获取验证码失败", message: "请输入正确的手机号码")
            return
        }
        phone = phoneTextField.text!
        
        checkIsExist(phone, failureHandler: { reason, message in
            print(reason)
            print(message)
            }, completionHandler: { phoneIsExist in
                if phoneIsExist {
                    showAlert("获取验证码失败", message: "该手机号已经注册，请切换手机号")
                    return
                }
                else {
                    SMSSDK.getVerificationCodeByMethod(SMSGetCodeMethodSMS, phoneNumber: self.phone, zone: "86", customIdentifier: nil, result: { error -> Void in
                        if error == nil {
                            showAlert("获取验证码成功", message: "请留意手机短信通知")
                        } else {
                            showAlert("获取验证码失败", message: "尝试更换手机号试试")
                        }
                    })
                }
        })
    }
    @IBAction func register(sender: UIButton!) {
        guard phoneTextField.text!.characters.count == 11 else {
            showAlert("注册失败", message: "请输入正确的手机号码")
            return
        }
        guard verifyCodeTextField.text! != "" else {
            showAlert("注册失败", message: "请输入验证码")
            return
        }
        guard passwordTextField.text! != "" else {
            showAlert("注册失败", message: "请输入密码")
            return
        }
        guard name != "" else {
            showAlert("注册失败", message: "请输入姓名")
            return
        }
        
        SMSSDK.commitVerificationCode(verifyCodeTextField.text!, phoneNumber: phoneTextField.text!, zone: "86", result: { error in
            guard let error = error else {
                return
            }
            print(error)
            showAlert("注册失败", message: "验证码错误，请重新输入")
        })
        
        registerByMobile(phoneTextField.text!, withAreaCode: "+86", password: passwordTextField.text!, name: passwordTextField.text!, failureHandler: { reason, message in
            
            print(reason)
            print(message)
            }, completionHandler: { register in
                
                guard let register = register else {
                    return
                }
                print(register)
        })
    }
    
    //MARK: -Controller Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        phoneTextField.text = phone
        verifyCodeTextField.text = verifyCode
        passwordTextField.text = password
        
    }
    override func dismissViewControllerAnimated(flag: Bool, completion: (() -> Void)?) {
        super.dismissViewControllerAnimated(flag, completion: {
            self.phone = self.phoneTextField.text!
            self.password = self.passwordTextField.text!
            self.verifyCode = self.verifyCodeTextField.text!
            self.delegate?.saveInput(self.phone, verifyCode: self.verifyCode, password: self.password)
        })
    }
    
}

