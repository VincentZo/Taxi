//
//  HomePage-Map.swift
//  Taxi
//
//  Created by Vincent on 2016/10/26.
//  Copyright © 2016年 com.vincent.study. All rights reserved.
//

import Foundation

extension HomePage : BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,BMKPoiSearchDelegate,BMKRouteSearchDelegate{
    
    
    // 添加地图 view
    func addMapView(){
        self.mapView = BMKMapView.init(frame: self.view.bounds)
        self.view.addSubview(self.mapView!)
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(hidenkeyBoard(sender:)))
        self.mapView?.addGestureRecognizer(tap)
        self.geoCoder = BMKGeoCodeSearch.init()
        self.poiSearch = BMKPoiSearch.init()
        self.routeSearch = BMKRouteSearch.init()
    }
   
    //MARK : 开启定位
    func startLocation(){
        self.mapView?.showsUserLocation = false
        // 移动10米过后自动更新定位
        self.localService.distanceFilter = 50
        // 地图渲染的精确度
        self.localService.desiredAccuracy = kCLLocationAccuracyBest
        self.localService.delegate = self
        self.localService.startUserLocationService()
        self.mapView?.showsUserLocation = true
        //self.mapView?.userTrackingMode = BMKUserTrackingModeNone
    }
    /*
     自2.0.0起，BMKMapView新增viewWillAppear、viewWillDisappear方法来控制BMKMapView的生命周期，并且在一个时刻只能有一个BMKMapView接受回调消息，因此在使用BMKMapView的viewController中需要在viewWillAppear、viewWillDisappear方法中调用BMKMapView的对应的方法，并处理delegate
     */
    override func viewWillAppear(_ animated: Bool) {
        self.mapView?.viewWillAppear()
        self.mapView?.delegate = self
        self.geoCoder?.delegate = self
        self.poiSearch?.delegate = self
        self.routeSearch?.delegate = self
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.mapView?.viewWillDisappear()
        self.mapView?.delegate = nil
        self.geoCoder?.delegate = nil
        self.poiSearch?.delegate = nil
        self.routeSearch?.delegate = nil
    }

    
    // MARK: localService 代理方法调用,定位更新后调用的方法
    // 104.410534680583,30.8583771172902
    func didUpdate(_ userLocation: BMKUserLocation!) {
       // self.mapView?.updateLocationData(userLocation)
        if self.currentCoordinate.latitude != userLocation.location.coordinate.latitude || self.currentCoordinate.longitude != userLocation.location.coordinate.longitude {
            let annotation = BMKPointAnnotation.init()
            annotation.coordinate = userLocation.location.coordinate
            annotation.title = "You is here"
            self.mapView?.addAnnotation(annotation)
        }
        self.moveMapViewToCoordinate(coordinate: userLocation.location.coordinate)
//        self.mapView?.showAnnotations(self.mapView?.annotations, animated: true)
        self.addCars(coor: userLocation.location.coordinate)
//        self.startTimer()
        self.getCarsArriveTime(currentPoint: userLocation.location.coordinate)
        self.currentCoordinate = userLocation.location.coordinate
    }
    
    // MARK: mapView 代理方法调用
    func mapView(_ mapView: BMKMapView!, viewFor annotation: BMKAnnotation!) -> BMKAnnotationView! {
        //Log(messageType: "Infomation", message: "AnnotationView")
        if annotation .isKind(of: BMKPointAnnotation.classForCoder()) && annotation === self.mapView?.annotations[0] as! BMKPointAnnotation{
            let annotationView = LocationAnnotationView.init(annotation: annotation, reuseIdentifier: "annotation")
            annotationView?.isDraggable = true
            return annotationView
        }else if annotation.title!().contains("目的地"){
            let endAnnotationView = EndPointAnnotationView.init(annotation: annotation, reuseIdentifier: "end")
            return endAnnotationView

        }else if annotation.title!().contains("起点"){
            let startAnno = StartPointAnnotationView.init(annotation: annotation, reuseIdentifier: "anno")
            startAnno?.isDraggable = false
            return startAnno
        }else{
            let carAnnotationView = CarAnnotationView.init(annotation: annotation, reuseIdentifier: "CarAnnotation")
            carAnnotationView?.isDraggable = false
            return carAnnotationView
        }
    }
    // 地图加载完成
    func mapViewDidFinishLoading(_ mapView: BMKMapView!) {
        //Log(messageType: "Infomation", message: "完成地图加载...正在移动至定位点...")
        self.mapView(self.mapView, regionDidChangeAnimated: true)
    }
    
    // 地图区域改变后调用的方法
    func mapView(_ mapView: BMKMapView!, regionDidChangeAnimated animated: Bool) {
        let point = self.mapView!.convert(self.pinPointButton.center, toCoordinateFrom: self.view)
        let option = BMKReverseGeoCodeOption.init()
        option.reverseGeoPoint = point
        self.geoCoder?.reverseGeoCode(option)
    }
    // 地理反编码信息处理方法
    func onGetReverseGeoCodeResult(_ searcher: BMKGeoCodeSearch!, result: BMKReverseGeoCodeResult!, errorCode error: BMKSearchErrorCode) {
        if error.rawValue == 0{
            self.geoResult = result
            self.startAddressLabel.isHidden = false
            self.startAddressLabel.text = result.address
        }else{
            Log("Error", message: "\(error)")
        }
    }
    
    
    // MARK: 移动地图到某一点
    func moveMapViewToCoordinate(coordinate : CLLocationCoordinate2D){
        let span = BMKCoordinateSpan.init(latitudeDelta: 0.01, longitudeDelta: 0.01)
        self.mapView?.setRegion(BMKCoordinateRegion.init(center:coordinate, span: span), animated: true)
       // self.localService.distanceFilter = 0
    }
    
       
    // MARK: 根据地理位置名称获取地理位置信息
    func getLocationInfomation(address : String){
        let option = BMKCitySearchOption.init()
        option.keyword = address
        self.poiSearch?.poiSearch(inCity: option)
    }
    
    // MARK: 实现BMKPoiSearchDelegate代理方法,获取检索结果
    // 此方法中需要获取 POI 信息列表, 对城市和详细的地理位置信息进行检索,现在暂时处理一个
    func onGetPoiResult(_ searcher: BMKPoiSearch!, result poiResult: BMKPoiResult!, errorCode: BMKSearchErrorCode) {
        if errorCode.rawValue == 0 && poiResult.poiInfoList != nil && poiResult.poiInfoList.count > 0{
            // 刷新下拉列表
            self.dataSources = poiResult.poiInfoList as! [BMKPoiInfo]
            self.tableView?.reloadData()
        }else{
            self.dataSources = [BMKPoiInfo]()
            self.tableView.reloadData()
            self.tableView.isHidden = true
            Log("Error", message: "\(errorCode)")
        }
    }
    // MARK:点击 searchTextField leftView 的 button 进行检索
    func searchAddress(sender:UIButton){
        if self.searchTextField.text == nil || (self.searchTextField.text?.isEmpty)!{
            return
        }
        if self.endCoordinate != nil{
            let annotations = self.mapView?.annotations as! [BMKPointAnnotation]
            for annotation in annotations{
                if annotation.title.contains("目的地"){
                    self.mapView?.removeAnnotation(annotation)
                }
            }
        }
        self.getLocationInfomation(address: self.searchTextField.text!)
        if self.endCoordinate != nil{
            let annotation = BMKPointAnnotation.init()
            annotation.coordinate = self.endCoordinate!
            annotation.title = "目的地:\(self.endAddress)"
            self.mapView?.addAnnotation(annotation)
            self.mapView?.showAnnotations([annotation], animated: true)
        }
        self.searchTextField.resignFirstResponder()
    }

    // MARK: 切换车辆类型
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
                        let i = index % 1000
                        //print("\(self.sits[i])")
                        if self.endCoordinate == nil{
                            self.carArriveTimeLabel.text = "\(self.carsArriveTimes[i])分钟"
                            self.boardPersonLabel.text = "\(self.sits[i])人"
                            self.priceLabel.text = "￥\(self.prices[i])"
                        }else{
                            self.doGetCost(sender: sender)
                        }
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
    // MARK: 定位到当前位置
    @IBAction func doLocation(sender:UIButton){
        self.localService.startUserLocationService()
        self.moveMapViewToCoordinate(coordinate: self.localService.userLocation.location.coordinate)
//        self.mapView?.showAnnotations([self.mapView?.annotations[0]], animated: true)
    }
    // MARK: 计算路程所需的费用
    // 获取服务器中每种车辆的单价,按照总公里数进行计算
    @IBAction func doGetCost(sender: UIButton) {

        if self.endCoordinate == nil{
            let alertController = UIAlertController.init(title: "信息提示", message: "请设置目的地!", preferredStyle: .alert)
            let okAction = UIAlertAction.init(title: "知道了", style: .default, handler: { (action) in
                alertController.dismiss(animated: true, completion: {
                    self.searchTextField.becomeFirstResponder()
                })
            })
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }else{
            var button = UIButton.init()
            for tag in 1000...1003{
                let btn = self.view.viewWithTag(tag) as! UIButton
                if btn.currentImage != nil{
                    button = btn
                    break
                }
            }
            let index = button.tag - 1000
            let price:CGFloat = self.prices[index]
            let speed = self.speeds[index]
            let endAnnotationPoint = BMKMapPointForCoordinate(self.endCoordinate!)
            let coor = self.currentCallCarPoint ?? self.currentCoordinate
            
            let mCurrentPoint = BMKMapPointForCoordinate(coor)
            let distance = BMKMetersBetweenMapPoints(mCurrentPoint , endAnnotationPoint)
            let cost = String.init(format: "%.1f", CGFloat(distance / 1000.0) * price)
            self.priceLabel.text = "￥\(cost)"
            self.carArriveTimeLabel.text = String.init(format: "%.f分钟",CGFloat(distance) / (CGFloat(1000)*speed) * 60)
            self.boardPersonLabel.text = "\(self.sits[index])人"
            // 在地图上同时展示出指定的annotation集合
            let startAnnotation = BMKPointAnnotation.init()
            startAnnotation.coordinate = coor
            let endAnnotation = BMKPointAnnotation.init()
            endAnnotation.coordinate = self.endCoordinate!
            self.getCarsArriveTime(currentPoint: coor)
//            self.getWay(startCoor: coor, endCoor: self.endCoordinate!)
           
        }
    }
    // MARK: 从这里开始叫车
    @IBAction func startFromHere(sender : UIButton){
        self.currentCallCarPoint = self.geoResult?.location ?? self.currentCoordinate
        self.addCars(coor: self.currentCallCarPoint!)
        self.getCarsArriveTime(currentPoint: self.currentCallCarPoint!)
        if self.endCoordinate != nil{
            self.getWay(startCoor: self.currentCallCarPoint!, endCoor: self.endCoordinate!)
        }
    }


    // MARK: 检索路径规划
    func getWay(startCoor : CLLocationCoordinate2D , endCoor : CLLocationCoordinate2D){
        let startNode = BMKPlanNode.init()
        startNode.pt = startCoor
        let endNode = BMKPlanNode.init()
        endNode.pt = endCoor
        let option = BMKDrivingRoutePlanOption.init()
        option.from = startNode
        option.to = endNode
        let isWork = self.routeSearch!.drivingSearch(option)
        if isWork{
            Log("Success_Infomation", message: "获取驾车路线成功")
        }else{
            Log("Error", message: "获取驾车路线失败")
        }
    }
    // MARK: 处理 routeSearch 结果的代理方法,处理路径检索结果
    func onGetDrivingRouteResult(_ searcher: BMKRouteSearch!, result: BMKDrivingRouteResult!, errorCode error: BMKSearchErrorCode) {
        if error.rawValue == 0{
            let plan = result.routes[0] as! BMKDrivingRouteLine
            let size = plan.steps.count
            var planPointCounts = 0
            for index in 0..<size{
                let transitStep = plan.steps[index] as! BMKDrivingStep
                if index == 0{
                    let startAnno = BMKPointAnnotation.init()
                    startAnno.title = "起点"
                    startAnno.coordinate = plan.starting.location
                    self.mapView?.addAnnotation(startAnno)
                }
                // 轨迹点总数累计
                planPointCounts = Int(transitStep.pointsCount) + planPointCounts
            }
            
            var points = Array.init(repeating: BMKMapPoint.init(x: 0, y: 0), count: planPointCounts)
            var i = 0
            for j in 0..<size{
                let transitStep = plan.steps[j] as! BMKDrivingStep
                for k in 0..<Int(transitStep.pointsCount){
                    points[i].x = transitStep.points[k].x
                    points[i].y = transitStep.points[k].y
                    i += 1
                }
            }
            // 通过 point 构建 BMKPolyLine
            let polyLine = BMKPolyline.init(points: &points, count: UInt(planPointCounts))
            self.mapView?.add(polyLine)
            self.mapViewFitPolyLine(polyline: polyLine)
        }else{
            Log("Error", message: "处理驾车路线结果失败")
        }
    }

     // MARK: 根据overlay生成对应的View
    func mapView(_ mapView: BMKMapView!, viewFor overlay: BMKOverlay!) -> BMKOverlayView! {
        if overlay.isKind(of: BMKPolyline.classForCoder()){
            let polyLineView = BMKPolylineView.init(overlay: overlay as! BMKPolyline)
            polyLineView?.strokeColor = UIColor.init(red: 114/255.0, green: 112/255.0, blue: 206/255.0, alpha: 0.9)
            polyLineView?.lineWidth = 10
            return polyLineView
        }
        return nil
    }
    
    
    // MARK: 点击大头针显示按钮
    @IBAction func clickedPinPoint(sender : UIButton){
        self.startFromHereButton.isHidden = !self.startFromHereButton.isHidden
    }
    
    
    // MARK: 根据polyline设置地图范围
    func mapViewFitPolyLine(polyline: BMKPolyline!) {
        if polyline.pointCount < 1 {
            return
        }
        
        let pt = polyline.points[0]
        var ltX = pt.x
        var rbX = pt.x
        var ltY = pt.y
        var rbY = pt.y
        
        for i in 1..<polyline.pointCount {
            let pt = polyline.points[Int(i)]
            if pt.x < ltX {
                ltX = pt.x
            }
            if pt.x > rbX {
                rbX = pt.x
            }
            if pt.y > ltY {
                ltY = pt.y
            }
            if pt.y < rbY {
                rbY = pt.y
            }
        }
        
        let rect = BMKMapRectMake(ltX, ltY, rbX - ltX, rbY - ltY)
        self.mapView?.visibleMapRect = rect
        self.mapView?.zoomLevel = self.mapView!.zoomLevel - 0.3
    }
    
    // MARK: searchTextField 改变时进行地址检索
    func searchTextFieldDidChanged(sender: UITextField) {
        if sender.text == nil || sender.text!.isEmpty{
            self.tableView?.isHidden = true
            self.dataSources = [BMKPoiInfo]()
        }else{
            //print("\(sender.text!)")
            self.getLocationInfomation(address: sender.text!)
            self.tableView?.isHidden = false
        }
    }
    
    func searchTextFieldShouldEidting(sender : UITextField) {
        if sender.text == nil || sender.text!.isEmpty{
            self.tableView?.isHidden = true
            self.dataSources = [BMKPoiInfo]()
        }else{
            self.getLocationInfomation(address: sender.text!)
            self.tableView?.isHidden = false
        }
    }
}











