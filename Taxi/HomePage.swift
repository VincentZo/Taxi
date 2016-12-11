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
    var currentCallCarPoint : CLLocationCoordinate2D? = nil
    var endCoordinate : CLLocationCoordinate2D?
    var isShowBottomView : Bool = false
    var geoCoder : BMKGeoCodeSearch?
    var poiSearch : BMKPoiSearch?
    var geoResult: BMKReverseGeoCodeResult?
    var routeSearch: BMKRouteSearch?
    var endAddress : String = ""
    var dataSources : [BMKPoiInfo] = []
    
    // 模拟四种车型的每公里单价
    let prices : Array<CGFloat> = [5,7,10,13]
    // 模拟四种车型的行驶速度,每小时多少公里
    let speeds : Array<CGFloat> = [30,40,50,60]
    // 模拟四种车型最多准坐多少人
    let sits : Array<Int> = [5,4,7,3]
    
    @IBOutlet weak var bottomView : UIView!
    @IBOutlet weak var locationButton : UIButton!
    @IBOutlet weak var firstCarButton : UIButton!

    @IBOutlet weak var bottomViewBottomHeight: NSLayoutConstraint!
    @IBOutlet weak var bottomViewTopHeight : NSLayoutConstraint!
    @IBOutlet weak var boardPersonLabel: UILabel!
    @IBOutlet weak var carArriveTimeLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var getCostBtn: UIButton!
    
    @IBOutlet weak var searchView: UIView!
    
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var pinPointButton : UIButton!
    
    @IBOutlet weak var startFromHereButton : UIButton!
    
    @IBOutlet weak var tableView : UITableView!
    
    @IBOutlet weak var startAddressLabel : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initNavigationItem()
        self.addMapView()
        self.startLocation()
        self.configSubviews()
        self.configTabelView()
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
        let btn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 28, height: 28))
        btn.setImage(UIImage.init(named: "Search"), for: UIControlState.normal)
//        btn.addTarget(self, action: #selector(searchAddress(sender:)), for: .touchUpInside)
        self.searchTextField.leftView = btn
        self.searchTextField.leftViewMode = .always
        //self.searchTextField.delegate = self
        self.searchTextField.addTarget(self, action: #selector(searchTextFieldDidChanged(sender : )), for: UIControlEvents.editingChanged)
        self.searchTextField.addTarget(self, action: #selector(searchTextFieldShouldEidting(sender : )), for: UIControlEvents.editingDidBegin)
        self.view.bringSubview(toFront: self.pinPointButton)
        self.view.bringSubview(toFront: self.startFromHereButton)
        self.startFromHereButton.layer.cornerRadius = 10
        
        self.startAddressLabel.layer.cornerRadius = 15
        self.startAddressLabel.isHidden = true
        self.view.bringSubview(toFront: self.startAddressLabel)
     }
    // MARK: 添加汽车大头针视图
    // 104.410534680583,30.8583771172902
    func addCars(coor : CLLocationCoordinate2D){
        
        self.mapView?.removeOverlays(self.mapView?.overlays)
        let firstAnnotation = self.mapView!.annotations[0] as! BMKPointAnnotation
        var startAnno : BMKPointAnnotation? = nil
        var endAnno : BMKPointAnnotation? = nil
        for item in self.mapView?.annotations as! [BMKPointAnnotation]{
            if item.title.contains(" 起点"){
                startAnno = item
            }
            if item.title.contains("目的地"){
                endAnno = item
            }
        }
        self.mapView?.removeAnnotations(self.mapView!.annotations)
        self.mapView?.addAnnotation(firstAnnotation)
        
        let annotation = BMKPointAnnotation.init()
        annotation.coordinate = CLLocationCoordinate2D.init(latitude: coor.latitude + 0.0008 , longitude: coor.longitude - 0.0003)
        annotation.title = "待客车辆"
        
        let annotation1 = BMKPointAnnotation.init()
        annotation1.coordinate = CLLocationCoordinate2D.init(latitude: coor.latitude + 0.001 , longitude: coor.longitude + 0.001)
        annotation1.title = "待客车辆"
        
        let annotation2 = BMKPointAnnotation.init()
        annotation2.coordinate = CLLocationCoordinate2D.init(latitude:coor.latitude + 0.000, longitude: coor.longitude + 0.0008)
        annotation2.title = "待客车辆"
        
        let annotation3 = BMKPointAnnotation.init()
        annotation3.coordinate = CLLocationCoordinate2D.init(latitude:coor.latitude - 0.0003, longitude: coor.longitude - 0.001)
        annotation3.title = "待客车辆"
        
        let annotation4 = BMKPointAnnotation.init()
        annotation4.coordinate = CLLocationCoordinate2D.init(latitude:coor.latitude - 0.0009, longitude: coor.longitude - 0.000)
        annotation4.title = "待客车辆"
        
        self.mapView?.addAnnotations([annotation,annotation1,annotation2,annotation3,annotation4])
        
        if startAnno != nil{
            self.mapView?.addAnnotation(startAnno!)
        }
        if endAnno != nil{
            self.mapView?.addAnnotation(endAnno!)
        }
        
    }
    
    // MARK: 实现车辆实时更新位置的方法
    func startTimer(){
        self.updateCarTimer = Timer.init(timeInterval: 1, target: self, selector: #selector(updateCars), userInfo: nil, repeats: true)
        self.updateCarTimer?.fire()
    }
    func stopTimer(){
        self.updateCarTimer?.invalidate()
    }
    
    // MARK:实际需要与服务器交互,获取车辆的位置信息,进行实时刷新
    func updateCars(){
        let annotations = self.mapView?.annotations as! [BMKPointAnnotation]
        for index in 1..<annotations.count{
            let annotation = annotations[index]
            annotation.coordinate.latitude -= 0.0008
            annotation.coordinate.longitude += 0.0008
        }
        //        self.mapView?.removeAnnotations(self.mapView?.annotations)
        //        self.mapView?.addAnnotations(annotations)
    }
    
    // MARK: 实现车辆到达时间
    func getCarsArriveTime(currentPoint : CLLocationCoordinate2D){
        let annotaions = self.mapView?.annotations as! [BMKPointAnnotation]
        for index in 1..<annotaions.count{
            let annotaion = annotaions[index]
            if !annotaion.title.contains("起点") && !annotaion.title.contains("目的地"){
                let mCurrentPoint = BMKMapPointForCoordinate(currentPoint)
                let mAnnotationPoint = BMKMapPointForCoordinate(annotaion.coordinate)
                let distance = BMKMetersBetweenMapPoints(mCurrentPoint , mAnnotationPoint)
                let time = (distance / (1000*35)) * 60
                let realTime : CGFloat = time > 0 && time < 1 ? CGFloat(1) : CGFloat(time)
                let timeStr = String(format: "%.f", realTime)
                annotaion.title = "到达时间:\(timeStr)分钟"
                self.carsArriveTimes.append(timeStr)
            }
        }
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
            if self.firstCarButton.currentImage != nil && self.endCoordinate == nil{
                self.carArriveTimeLabel.text = "\(self.carsArriveTimes[0])分钟"
                self.boardPersonLabel.text = "\(self.sits[0])人"
                self.priceLabel.text = "￥\(self.prices[0])"
            }
            if self.endCoordinate != nil{
                self.doGetCost(sender: self.firstCarButton)
            }
        }
    }
    //    let image = UIImage.init(named: nav)
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
    // MARK:关闭键盘和隐藏 bottomView
    func hidenkeyBoard(sender:UITapGestureRecognizer){
        self.tableView.isHidden = true
        self.searchTextField.resignFirstResponder()
        if self.isShowBottomView{
            self.closeBottomView()
        }
    }

}










