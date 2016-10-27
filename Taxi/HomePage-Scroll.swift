//
//  HomePage-Scroll.swift
//  Taxi
//
//  Created by Vincent on 2016/10/26.
//  Copyright © 2016年 com.vincent.study. All rights reserved.
//

import Foundation

extension HomePage{
    
    // MARK: 添加 leftPage 和 backControl
    override func viewDidAppear(_ animated: Bool) {
        self.initLeftPageAndBackControl()
    }
    
    // MARK: 设置左页面和 backControl
    func initLeftPageAndBackControl(){
        self.addLeftPage()
        self.addBackControl()
    }
    
    func addLeftPage(){
        if self.userCenterInfoPage == nil{
            self.userCenterInfoPage = MainStoryBoard.instantiateViewController(withIdentifier: UserCenterInfoPageIndentifier) as? UserCenterInfoPage
            self.userCenterInfoPage!.homePage = self
            var frame = self.navigationController!.view.bounds
            frame.origin.x = -(frame.size.width - LeftViewGap)
            frame.size.width = frame.size.width - LeftViewGap
            self.userCenterInfoPage?.view.frame = frame
            self.navigationController?.view.addSubview(self.userCenterInfoPage!.view)
        }
    }
    
    func addBackControl(){
        if self.backControl == nil{
            self.backControl = UIControl.init(frame: self.navigationController!.view.bounds)
            self.backControl?.addTarget(self, action: #selector(showHomePage(sender:)), for: .touchUpInside)
            self.backControl?.backgroundColor = UIColor.black
            self.backControl?.alpha = 0.3
            self.navigationController?.view.addSubview(self.backControl!)
            self.navigationController?.view.sendSubview(toBack: self.backControl!)
        }
    }
    
    func initNavigationItem(){
        self.setNavigationItem(title: "user.png", selector: #selector(showUserInfoPage(sender:)), isLeft: true)
    }
    
    func showUserInfoPage(sender:UIBarButtonItem){
        self.showLeftPage()
    }
    
    func showLeftPage(){
        self.configShadow(view: self.userCenterInfoPage!.view, offset: -2, isShadow: true)
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveLinear, animations: {
            var frame = self.userCenterInfoPage!.view.bounds
            frame.origin.x = 0
            self.userCenterInfoPage!.view.frame = frame
            
            var navFrame = self.navigationController!.navigationBar.bounds
            navFrame.origin.x = navFrame.size.width - LeftViewGap
            self.navigationController?.navigationBar.frame = navFrame
        }) { (finished) in
            self.navigationController?.view.bringSubview(toFront: self.backControl!)
            self.navigationController?.view.bringSubview(toFront: self.userCenterInfoPage!.view)
        }
    }
    
    func showHomePage(sender:UIControl){
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveLinear, animations: {
            var frame = self.userCenterInfoPage!.view.bounds
            frame.origin.x = -frame.size.width
            self.userCenterInfoPage!.view.frame = frame
            
            var navFrame = self.navigationController!.navigationBar.bounds
            navFrame.origin.x = 0
            self.navigationController?.navigationBar.frame = navFrame
            
        }) { (finished) in
            self.navigationController?.view.sendSubview(toBack: self.backControl!)
            self.configShadow(view: self.userCenterInfoPage!.view, offset: 0, isShadow: false)
        }
    }
    
    func configShadow(view : UIView , offset:CGFloat , isShadow:Bool){
        if isShadow{
            view.layer.shadowColor = UIColor.black.cgColor
            view.layer.shadowOpacity = 0.2
            view.layer.shadowOffset = CGSize.init(width: offset, height: offset)
        }else{
            view.layer.shadowColor = UIColor.clear.cgColor
            view.layer.shadowOpacity = 0
            view.layer.shadowOffset = CGSize.init(width: 0, height: 0)
        }
    }

}
