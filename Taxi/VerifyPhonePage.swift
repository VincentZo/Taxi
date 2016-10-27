//
//  VerifyPhonePage.swift
//  Taxi
//
//  Created by Vincent on 16/10/19.
//  Copyright © 2016年 com.vincent.study. All rights reserved.
//

import UIKit

class VerifyPhonePage: BasePage {

    
    @IBOutlet weak var verifyNumberOneTextField: UITextField!
    
    @IBOutlet weak var verifyNumberTwoTextField: UITextField!
    
    @IBOutlet weak var verifyNumberThreeTextField: UITextField!
    
    @IBOutlet weak var verifyNumberFourTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.initNavigationItem()
    }
    
    func initNavigationItem(){
        self.title = "验证手机"
        self.navigationController?.navigationBar.isTranslucent = false
        self.setNavigationItem(title: "Close.png", selector: #selector(doBack), isLeft: true)
    }
    
    // MARK: TextField 改变TextField值后调用的方法
    @IBAction func textFieldChanged(sender:UITextField){
        let tag = sender.tag
        if tag == 4{
            self.doVerify()
        }
//        print("\(sender.text)")
        if sender.text!.characters.count > 1{
            let index = sender.text?.index(sender.text!.startIndex, offsetBy: 1)
            sender.text = sender.text?.substring(to:index!)
        }
        
        if !sender.text!.isEmpty {
            if tag+1 <= 4{
                let view = self.view.viewWithTag(tag + 1)
                view?.becomeFirstResponder()
            }
        }
        
    }
    
    // MARK: 执行手机验证
    func doVerify(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.showHomePage()
        Log(messageType: "Infomation", message: "正在验证手机...验证成功,正在前往主页面...")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.verifyNumberOneTextField.resignFirstResponder()
        self.verifyNumberTwoTextField.resignFirstResponder()
        self.verifyNumberThreeTextField.resignFirstResponder()
        self.verifyNumberFourTextField.resignFirstResponder()

    }

    @IBAction func changePhoneNumber(_ sender: AnyObject) {
        Log(messageType: "Infomation", message: "更改手机号码...")
    }
    
    @IBAction func resend(_ sender: AnyObject) {
        Log(messageType: "Infomation", message: "重新发送验证码")
    }
}









