//
//  PayPage.swift
//  Taxi
//
//  Created by Vincent on 16/10/19.
//  Copyright © 2016年 com.vincent.study. All rights reserved.
//

import UIKit

class PayPage: BasePage,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var dataSources : Array<PayInfo>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initData()
        self.configTableView()
        self.initNavigationItem()
    }
    
    func initNavigationItem(){
        self.title = "添加支付方式"
//        self.setNavigationItem(title: "取消", selector: #selector(doBack), isLeft: true)
        self.setNavigationItem(title: "验证", selector: #selector(doNext(sender:)), isLeft: false)
    }

    override func doNext(sender:UIBarButtonItem){
        Log(messageType: "Infomation", message: "支付方式添加成功,正在准备验证手机...")
        let storyBoard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        let verifyPhonePage = storyBoard.instantiateViewController(withIdentifier: VerifyPhonePageIndentifier) as! VerifyPhonePage
        let naviController = UINavigationController.init(rootViewController: verifyPhonePage)
        self.present(naviController, animated: true, completion: nil)
    }
    
    func initData(){
        self.dataSources = []
        let pay = PayInfo()
        pay.type = "支付宝"
        pay.icon = "AliPay"
        
        let pay1 = PayInfo()
        pay1.type = "百度钱包"
        pay1.icon = "BaiDuWallet"
        
        let pay2 = PayInfo()
        pay2.type = "信用卡"
        pay2.icon = "CreditCard"
        
        let pay3 = PayInfo()
        pay3.type = "银联"
        pay3.icon = "YinLian"
        
        self.dataSources!.append(pay)
        self.dataSources!.append(pay1)
        self.dataSources!.append(pay2)
        self.dataSources!.append(pay3)
    }
    
    func configTableView(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "payCell")
        // 隐藏同一界面内多余的 cell
        self.tableView.tableFooterView = UIView.init(frame: CGRect.zero)
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSources!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "payCell", for: indexPath)
        let payInfo = self.dataSources![indexPath.row]
        cell.imageView!.image = UIImage.init(named: payInfo.icon!)
        cell.textLabel!.text = payInfo.type!
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let payInfo = self.dataSources![indexPath.row]
        Log(messageType: "Infomation", message: "使用\(payInfo.type!)进行支付,正在跳转到支付页面(请集成支付的SDK)...")
    }
    
}
