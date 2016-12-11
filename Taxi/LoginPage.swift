//
//  LoginPage.swift
//  Taxi
//
//  Created by Vincent on 16/10/14.
//  Copyright © 2016年 com.vincent.study. All rights reserved.
//

import UIKit

class LoginPage: BasePage {

    @IBOutlet weak var userNameTextField: UITextField!
    
    @IBOutlet weak var passWordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    var location : Location = Location.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initNavigationItem()
    }
    func initNavigationItem(){
        self.title = "登录"
        self.setNavigationItem(title: "Back.png", selector: #selector(doBack), isLeft: true)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
      
    }
    @IBAction func login(sender: UIButton) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.showHomePage()
        self.location.startLocation()
    }
}
