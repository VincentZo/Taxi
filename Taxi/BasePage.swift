//
//  BasePage.swift
//  Taxi
//
//  Created by Vincent on 16/10/14.
//  Copyright © 2016年 com.vincent.study. All rights reserved.
//

import UIKit

class BasePage: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK:添加导航栏按钮
    func setNavigationItem(title:String , selector : Selector , isLeft : Bool){
        var item : UIBarButtonItem?
        
        if title.hasSuffix("png"){
            item = UIBarButtonItem.init(image: UIImage.init(named: title), style: .plain, target: self, action: selector)
            
        }else{
            item = UIBarButtonItem.init(title: title, style: .plain, target: self, action: selector)
        }
        item?.tintColor = UIColor.darkGray
        if isLeft{
            self.navigationItem.leftBarButtonItem = item
        }else{
            self.navigationItem.rightBarButtonItem = item
        }
        
    }
    
    func doNext(sender:UIBarButtonItem){
        
    }
    
    func doBack(){
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
}
