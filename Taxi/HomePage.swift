//
//  HomePage.swift
//  Taxi
//
//  Created by Vincent on 16/10/20.
//  Copyright © 2016年 com.vincent.study. All rights reserved.
//

import UIKit

class HomePage: BasePage{

    var userCenterInfoPage : UserCenterInfoPage?
    var backControl : UIControl?
    var mapView : BMKMapView?
    var localService : BMKLocationService = BMKLocationService.init()
    var updateCarTimer : Timer?
    var carsArriveTimes : Array<String> = []
    var currentCoordinate : CLLocationCoordinate2D = CLLocationCoordinate2D.init()
    var isShowBottomView : Bool = false
   //var geoCoder : BMKGeoCodeSearch = BMKGeoCodeSearch.init()
    @IBOutlet weak var bottomView : UIView!
    @IBOutlet weak var locationButton : UIButton!
    @IBOutlet weak var firstCarButton : UIButton!

    @IBOutlet weak var bottomViewBottomHeight: NSLayoutConstraint!
    @IBOutlet weak var bottomViewTopHeight : NSLayoutConstraint!
    @IBOutlet weak var boardPersonTextField: UILabel!
    @IBOutlet weak var carArriveTimeTextField: UILabel!
    
    @IBOutlet weak var priceTextField: UILabel!
    
    @IBOutlet weak var getCostBtn: UIButton!
    
    @IBOutlet weak var searchView: UIView!
    
    @IBOutlet weak var searchTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initNavigationItem()
        self.addMapView()
        self.startLocation()
        self.configSubviews()
        
    }
    
    func configSubviews(){
        self.view.bringSubview(toFront: self.bottomView)
        self.view.bringSubview(toFront: self.locationButton)
        self.firstCarButton.isUserInteractionEnabled = false
        //self.doGetCost(self.firstCarButton)
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(showBottomView(sender:)))
        self.bottomView.isUserInteractionEnabled = true
        self.bottomView.addGestureRecognizer(tap)
    
        self.view.bringSubview(toFront: self.searchView)
        //self.searchView.layer.borderColor = UIColor.black.cgColor
        self.searchView.layer.borderWidth = 1
        self.searchView.layer.cornerRadius = 5
        self.searchTextField.leftView = UIImageView.init(image: UIImage.init(named: "Search"))
        self.searchTextField.leftViewMode = .always
     }
    // MARK:展示 bottomView
    func showBottomView(sender:UITapGestureRecognizer){
        if self.isShowBottomView{
            return
        }
        self.stopTimer()
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
                self.bottomViewBottomHeight.constant = 0
                self.bottomViewTopHeight.constant -= 192
                self.view.layoutIfNeeded()
            }) { (finished) in
                self.isShowBottomView = true
        }
    }
    // MARK: 关闭 bottomView
    func closeBottomView(){
        if !self.isShowBottomView{
            return
        }
        // 关闭费用bottomView 时开启定时器
        //self.startTimer()
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
            self.bottomViewBottomHeight.constant = -192
            self.bottomViewTopHeight.constant += 192
            self.view.layoutIfNeeded()
        }) { (finished) in
            self.isShowBottomView = false
        }

    }
    
    @IBAction func doSwitchCar(sender:UIButton){
        for index in 1000...1003{
            // 通过 tag 获取 button
            let button = self.view.viewWithTag(index) as! UIButton
            if sender.tag == index{
                // 设置 button 的图片是需要调用 setImage 方法
                sender.setImage(UIImage.init(named: "CarBtn"), for: UIControlState.normal)
                let label = self.view.viewWithTag(index + 10) as! UILabel
             UIView.animate(withDuration: 0.2, delay: 0, options: .curveLinear, animations: { 
                    var frame = label.frame
                    frame.origin.y -= 6
                    label.frame = frame
                }, completion: { (finished) in
                    sender.isUserInteractionEnabled = false
                    self.doGetCost(sender)
             })
                
            }else{
               button.setImage(nil, for: .normal)
                let label = self.view.viewWithTag(index+10) as! UILabel
                UIView.animate(withDuration: 0.2, delay: 0, options: .curveLinear, animations: {
                        label.frame.origin.y = 12
                    }, completion: { (finished) in
                        button.isUserInteractionEnabled = true
                })
            }
        }
    }

    @IBAction func doLocation(sender:UIButton){
        self.localService.startUserLocationService()
        self.moveMapViewToCoordinate(coordinate: self.localService.userLocation.location.coordinate)
    }
    // MARK: 计算路程所需的费用
    // 获取服务器中每种车辆的单价,按照总公里数进行计算
    @IBAction func doGetCost(_ sender: UIButton) {
        
        //这里模拟每公里10块钱
        var button = UIButton.init()
        for tag in 1000...1003{
            let btn = self.view.viewWithTag(tag) as! UIButton
            if btn.currentImage != nil{
                button = btn
            }
        }
        let index = button.tag - 999
        let car = self.mapView!.annotations[index] as! BMKAnnotation
//        if sender.tag > 1000{
//            index = sender.tag - 1000
//            car = self.mapView!.annotations[index] as! BMKAnnotation
//        }
        let carAnnotationPoint = BMKMapPointForCoordinate(car.coordinate)
        let mCurrentPoint = BMKMapPointForCoordinate(self.currentCoordinate)
        let distance = BMKMetersBetweenMapPoints(mCurrentPoint , carAnnotationPoint)
        let cost = String.init(format: "%.1f", distance / 1000 * 10)
        self.priceTextField.text = "￥\(cost)"
        self.carArriveTimeTextField.text = "\(self.carsArriveTimes[index])分钟"
    }
    
}










