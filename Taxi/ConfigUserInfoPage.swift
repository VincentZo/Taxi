//
//  ConfigUserInfoPage.swift
//  Taxi
//
//  Created by Vincent on 16/10/24.
//  Copyright © 2016年 com.vincent.study. All rights reserved.
//

import UIKit

class ConfigUserInfoPage: BasePage {

    @IBOutlet var backScrollView : UIScrollView!
    @IBOutlet var backInfoView : UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initNavigationItem()
    }
    
    func initNavigationItem(){
        self.title = "设置用户信息"
        self.navigationController?.navigationBar.isTranslucent = false
        self.view.backgroundColor = UIColor.white
        self.setNavigationItem(title: "Close.png", selector: #selector(doBack), isLeft: true)
    }

}
