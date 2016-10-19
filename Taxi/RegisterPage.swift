//
//  RegisterPage.swift
//  Taxi
//
//  Created by Vincent on 16/10/14.
//  Copyright © 2016年 com.vincent.study. All rights reserved.
//

import UIKit

class RegisterPage: BasePage {

    @IBOutlet weak var registerView: UIView!
    
    @IBOutlet weak var emailText: UITextField!
    
    @IBOutlet weak var phoneNumberText: UITextField!
    
    @IBOutlet weak var passwordText: UITextField!
    
    var currentSelectIndexPath : IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initNavigationItem()
        self.configSubViews()
    }

    func configSubViews(){
        // 设置 view 圆角
        self.registerView.layer.cornerRadius = 5
        self.registerView.layer.masksToBounds = true
        
        // 添加 textField 右视图
        
        let countryBtn = UIButton.init(type: UIButtonType.system)
        countryBtn.setTitle("国家", for: UIControlState.normal)
        countryBtn.frame = CGRect.init(x: 0, y: 0, width: 35, height: 28)
        countryBtn.addTarget(self, action: #selector(chooseCountry(sender:)), for: .touchUpInside)
        self.phoneNumberText.rightView = countryBtn
        self.phoneNumberText.rightViewMode = .always
        
        // 添加 textField 左视图
        let label = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 20))
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.darkGray
        self.phoneNumberText.leftView = label
        self.phoneNumberText.leftViewMode = .always
        label.isHidden = true
        
    }
    
    // MARK: 点击国家按钮,弹出国家选择页面
    func chooseCountry(sender:UIButton){
        let storyBoard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        let selectCountryPage = storyBoard.instantiateViewController(withIdentifier: SelectCountryPageIndentifier) as! SelectCountryPage
        selectCountryPage.currentSelectIndexPath = self.currentSelectIndexPath
        let navigation = UINavigationController.init(rootViewController: selectCountryPage)
        
        NotificationCenter.default.addObserver(self, selector: #selector(didSelectCountryCell(sender:)), name:NSNotification.Name(rawValue: DidSelectCellNotificationIndentifier), object: nil)
        
        self.present(navigation, animated: true, completion: nil)
    }
    
    func didSelectCountryCell(sender:Notification){
        let country = sender.userInfo!["data"] as! Country
        if let image = UIImage.init(named: country.code){
            let button = self.phoneNumberText.rightView as! UIButton
            button.setTitle("", for: UIControlState.normal)
            button.setBackgroundImage(image, for: UIControlState.normal)
            
        }
        
        if !country.diallingCode.isEmpty{
            let label = self.phoneNumberText.leftView as! UILabel
            label.text = country.diallingCode
            label.isHidden = false
        }else{
            let label = self.phoneNumberText.leftView as! UILabel
            label.isHidden = true

        }
        
        let indexPath = sender.userInfo!["indexPath"] as! IndexPath
        self.currentSelectIndexPath = indexPath
        
    }
    // MARK: 设置 navigationItem
    func initNavigationItem(){
        self.title = "创建用户"
        self.navigationController?.navigationBar.isTranslucent = false
        self.setNavigationItem(title: "取消", selector: #selector(doBack), isLeft: true)
        self.setNavigationItem(title: "下一步", selector: #selector(doNext(sender:)), isLeft: false)
    }
    
    // MARK: 下一步操作
    override func doNext(sender: UIBarButtonItem) {
        let storyBoard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        let registerUserInfoPage = storyBoard.instantiateViewController(withIdentifier: RegisterUserInfoIndentifier) as! RegisterUserInfoPage
        self.navigationController?.pushViewController(registerUserInfoPage, animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.emailText.resignFirstResponder()
        self.phoneNumberText.resignFirstResponder()
        self.passwordText.resignFirstResponder()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
 
}
