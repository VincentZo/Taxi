//
//  UserInfoPage.swift
//  Taxi
//
//  Created by Vincent on 16/10/20.
//  Copyright © 2016年 com.vincent.study. All rights reserved.
//

import UIKit

class UserCenterInfoPage: BasePage,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var homePage : HomePage?
    
    var dataSources : Array<UserCenterInfo> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
        self.initDataSources()
        self.configTableView()
    }
    
    func initDataSources(){
        let info1 = UserCenterInfo.init(title: "Vincent", icon: "avatar")
        let info2 = UserCenterInfo.init(title: "付款", icon: "CreditCard")
        let info3 = UserCenterInfo.init(title: "历史记录", icon: "CreditCard")
        let info4 = UserCenterInfo.init(title: "帮助", icon: "CreditCard")
        let info5 = UserCenterInfo.init(title: "分享", icon: "CreditCard")
        let info6 = UserCenterInfo.init(title: "优惠", icon: "CreditCard")
        let info7 = UserCenterInfo.init(title: "通知", icon: "CreditCard")
        let info8 = UserCenterInfo.init(title: "设置", icon: "CreditCard")
        
        self.dataSources.append(info1)
        self.dataSources.append(info2)
        self.dataSources.append(info3)
        self.dataSources.append(info4)
        self.dataSources.append(info5)
        self.dataSources.append(info6)
        self.dataSources.append(info7)
        self.dataSources.append(info8)
    }
    
    func configTableView(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "userCell")
        self.tableView.backgroundColor = UIColor.black
        self.tableView.separatorStyle = .none
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSources.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath)
        
        let userInfo = self.dataSources[indexPath.row]
        cell.imageView!.image = UIImage.init(named: userInfo.icon)
        cell.textLabel!.text = userInfo.title
        cell.textLabel!.textColor = UIColor.white
        cell.selectionStyle = .none
        if indexPath.row == 0{
            cell.backgroundColor = UIColor.darkGray
            cell.imageView!.contentMode = .center
            cell.imageView!.layer.cornerRadius = self.tableView(self.tableView!, heightForRowAt: indexPath) / 2
            cell.imageView!.layer.masksToBounds = true
        }else{
            cell.backgroundColor = UIColor.black
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 70
        }
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 7{
//            let nib = UINib.init(nibName: "ConfigUserInfoPage", bundle: Bundle.main)
            let configUserInfoPage = ConfigUserInfoPage()
            let navPage = UINavigationController.init(rootViewController: configUserInfoPage)
            self.homePage?.present(navPage, animated: true, completion: nil)
            self.homePage?.showHomePage(sender: self.homePage!.backControl!)
        }
    }
    
    

}










