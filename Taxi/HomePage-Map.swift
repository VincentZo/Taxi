//
//  HomePage-Map.swift
//  Taxi
//
//  Created by Vincent on 2016/10/26.
//  Copyright © 2016年 com.vincent.study. All rights reserved.
//

import Foundation

extension HomePage : BMKMapViewDelegate,BMKLocationServiceDelegate{
    
    func addMapView(){
        self.mapView = BMKMapView.init(frame: self.view.bounds)
        self.view.addSubview(self.mapView!)
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(hidenkeyBoard(sender:)))
        self.mapView?.addGestureRecognizer(tap)
    }
    // MARK:关闭键盘和隐藏 bottomView
    func hidenkeyBoard(sender:UITapGestureRecognizer){
        self.searchTextField.resignFirstResponder()
        if self.isShowBottomView{
            self.closeBottomView()
        }
    }
    func startLocation(){
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
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.mapView?.viewWillDisappear()
        self.mapView?.delegate = nil
    }

    
    // MARK: localService 代理方法调用,定位更新后调用的方法
    // 104.410534680583,30.8583771172902
    func didUpdate(_ userLocation: BMKUserLocation!) {
        //self.mapView?.updateLocationData(userLocation)
        self.moveMapViewToCoordinate(coordinate: userLocation.location.coordinate)
        if self.currentCoordinate.latitude != userLocation.location.coordinate.latitude || self.currentCoordinate.longitude != userLocation.location.coordinate.longitude {
            let annotation = BMKPointAnnotation.init()
            annotation.coordinate = userLocation.location.coordinate
            annotation.title = "Vincent is here"
            self.mapView?.addAnnotation(annotation)
        }
        self.addCars()
        self.startTimer()
        self.getCarsArriveTime()
        self.currentCoordinate = userLocation.location.coordinate
    }
    
    // MARK: mapView 代理方法调用
    func mapView(_ mapView: BMKMapView!, viewFor annotation: BMKAnnotation!) -> BMKAnnotationView! {
        //Log(messageType: "Infomation", message: "AnnotationView")
        if annotation .isKind(of: BMKPointAnnotation.classForCoder()) && annotation === self.mapView?.annotations[0] as! BMKPointAnnotation{
            let annotationView = LocationAnnotationView.init(annotation: annotation, reuseIdentifier: "annotation")
            annotationView?.isDraggable = true
            return annotationView
        }else{
            let carAnnotationView = CarAnnotationView.init(annotation: annotation, reuseIdentifier: "CarAnnotation")
            carAnnotationView?.isDraggable = false
            return carAnnotationView
        }
    }
    // 地图加载完成
    func mapViewDidFinishLoading(_ mapView: BMKMapView!) {
        Log(messageType: "Infomation", message: "完成地图加载...正在移动至定位点...")
        
    }
    
    
    
    // MARK: 移动地图到某一点
    func moveMapViewToCoordinate(coordinate : CLLocationCoordinate2D){
        let span = BMKCoordinateSpan.init(latitudeDelta: 0.01, longitudeDelta: 0.01)
        self.mapView?.setRegion(BMKCoordinateRegion.init(center:coordinate, span: span), animated: true)
       // self.localService.distanceFilter = 0
    }
    
    // MARK: 添加汽车大头针视图
    // 104.410534680583,30.8583771172902
    func addCars(){
        //if self.mapView!.annotations.count > 1{
        self.mapView?.removeOverlays(self.mapView?.overlays)
        let anno = self.mapView!.annotations[0] as! BMKPointAnnotation
        self.mapView?.removeAnnotations(self.mapView!.annotations)
        self.mapView?.addAnnotation(anno)
       // }
        let coor = self.localService.userLocation.location.coordinate
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
        
    }
    
    // MARK: 实现车辆实时更新位置的方法
    func startTimer(){
        self.updateCarTimer = Timer.init(timeInterval: 1, target: self, selector: #selector(updateCars), userInfo: nil, repeats: true)
        self.updateCarTimer?.fire()
    }
    func stopTimer(){
        self.updateCarTimer?.invalidate()
    }
    
    // 实际需要与服务器交互,获取车辆的位置信息,进行实时刷新
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
    func getCarsArriveTime(){
        let annotaions = self.mapView?.annotations as! [BMKPointAnnotation]
        for index in 1..<annotaions.count{
            let annotaion = annotaions[index]
            let mCurrentPoint = BMKMapPointForCoordinate(self.localService.userLocation.location.coordinate)
            let mAnnotationPoint = BMKMapPointForCoordinate(annotaion.coordinate)
            let distance = BMKMetersBetweenMapPoints(mCurrentPoint , mAnnotationPoint)
            let time = distance / (1000) * 60
            let timeStr = String(format: "%.f", time)
            annotaion.title = "到达时间:\(timeStr)分钟"
            self.carsArriveTimes.append(timeStr)
        }
    }
}











