//
//  SelectCountryPage.swift
//  Taxi
//
//  Created by Vincent on 16/10/18.
//  Copyright © 2016年 com.vincent.study. All rights reserved.
//

import UIKit

class SelectCountryPage: BasePage,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    var currentSelectIndexPath : IndexPath?
    
    var cellDataSources : Dictionary<String,Array<Country>> = [:]
    var sectionsDataSources : Array<String> = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initNavigationItem()
        self.initData()
        self.configTableView()
    }

    // MARK: 获取数据源
    func initData(){
        // 通过 Local获取城市的code
        let countryCodes = Locale.isoRegionCodes
        let local = Locale.init(identifier: "zh")
        //let indens = Locale.availableIdentifiers
        var countrys = [Country]()
        //print("\(indens)")
        for code in countryCodes{
            let country = Country()
            country.code = code
            // 通过 Local 对象返回当前地区信息所表示的国家名称,这里返回中文
            country.name =  local.localizedString(forRegionCode: code)
            country.diallingCode = "+\(HundleTools.getCountryDiallingCode(countryName: country.name))"
            countrys.append(country)
        }
        // 对比字符串按升序排列
        countrys.sort { (country1, country2) -> Bool in
            return country1.name.localizedCaseInsensitiveCompare(country2.name) == .orderedAscending
        }
        
        //print("\(countrys.count)")
        // 根据拼音排序
        // 逻辑是判断 section 中是否有该拼音,若没有拼音则进入 if 中进行添加,主要逻辑是检查到没有该拼音则把上一个拼音保存的数据 datas 设置到 cell 数据中,最后再加入最后一个拼音的数据
        var pinyin = ""
        var datas = [Country]()
        for country in countrys{
            pinyin = HundleTools.switchIntoSyllables(chinese: country.name)
            // 如果没有拼音则进入 if 语句内
            if !(self.sectionsDataSources.contains(pinyin)){
                // datas 有值则加入cell 的 dataSource 中
                if datas.count > 0 {
                    self.cellDataSources[self.sectionsDataSources.last!] = datas
                }
                // 加入 section 数据中
                self.sectionsDataSources.append(pinyin)
                // 重新设置 datas 的数据
                datas = []
            }
           datas.append(country)
        }
        // 加入最后一个拼音的数据
        self.cellDataSources[self.sectionsDataSources.last!] = datas
        // 按字母顺序排列
        self.sectionsDataSources.sort { (str1, str2) -> Bool in
            return str1.localizedCaseInsensitiveCompare(str2) == .orderedAscending
        }
    }
    
    // MARK:配置 tableView
    func configTableView(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: SelectCountryCellIndentifier)
    }
    
    func initNavigationItem(){
        self.title = "选择国家/地区"
        self.setNavigationItem(title: "取消", selector: #selector(doBack), isLeft: true)
//        self.setNavigationItem(title: "完成", selector: #selector(doNext(sender:)), isLeft: false)
    }
    
//    override func doNext(sender: UIBarButtonItem) {
//        self.dismiss(animated: true, completion: nil)
//        Log(messageType: "Infomation", message: "选择国家完成按钮")
//    }
    
    // MARK: 实现 tableView 的代理方法
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sectionsDataSources.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = self.sectionsDataSources[section]
        return self.cellDataSources[key]!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: SelectCountryCellIndentifier, for: indexPath)
        
        //获取数据源中的数据
        let key = self.sectionsDataSources[indexPath.section]
        let country = self.cellDataSources[key]![indexPath.row]
        cell.textLabel?.text = country.name
        cell.imageView?.image = UIImage.init(named: country.code)
        cell.detailTextLabel?.text = country.diallingCode
        cell.selectionStyle = .none
        
        if self.currentSelectIndexPath?.section == indexPath.section && self.currentSelectIndexPath?.row == indexPath.row{
            cell.accessoryType = .checkmark
        }else{
            cell.accessoryType = .none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sectionsDataSources[section]
    }
    // 返回 section 的索引数据
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return self.sectionsDataSources
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.currentSelectIndexPath != nil{
            let selectCell = self.tableView.cellForRow(at: self.currentSelectIndexPath!)
            selectCell?.accessoryType = .none
            self.currentSelectIndexPath = nil
        }
        let cell = self.tableView.cellForRow(at: indexPath)!
        cell.accessoryType = .checkmark
        self.currentSelectIndexPath = indexPath
        
        let country = self.cellDataSources[self.sectionsDataSources[indexPath.section]]?[indexPath.row]
        NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: DidSelectCellNotificationIndentifier), object: nil, userInfo: ["data":country,"indexPath":self.currentSelectIndexPath])
        self.doBack()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
